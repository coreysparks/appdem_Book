"""
Download ACS PUMS data from the Census API and save as Parquet.

Requires a Census API key in the environment variable CENSUS_API_KEY.
Get a free key at https://api.census.gov/data/key_signup.html

Dependencies: requests, pandas, pyarrow
  pip install requests pandas pyarrow
"""

import os
import time
import requests
import pandas as pd
from pathlib import Path


# ---------------------------------------------------------------------------
# Census API constants
# ---------------------------------------------------------------------------

BASE_URL = "https://api.census.gov/data/{year}/acs/acspums{span}y"

# Maximum variables the Census API will return in one call.
_BATCH_SIZE = 48  # leave headroom under the 50-var limit; SERIALNO always added


def _get_api_key() -> str:
    key = os.environ.get("CENSUS_API_KEY", "")
    if not key:
        raise EnvironmentError(
            "Census API key not found. Set the CENSUS_API_KEY environment "
            "variable before running this script.\n"
            "  Windows PowerShell : $env:CENSUS_API_KEY = 'your_key_here'\n"
            "  bash/zsh           : export CENSUS_API_KEY='your_key_here'"
        )
    return key


# ---------------------------------------------------------------------------
# Variable helpers
# ---------------------------------------------------------------------------

def list_pums_variables(year: int = 2022, span: int = 5) -> pd.DataFrame:
    """Return a DataFrame of all available PUMS variables for a given dataset."""
    url = BASE_URL.format(year=year, span=span) + "/variables.json"
    resp = requests.get(url, timeout=30)
    resp.raise_for_status()
    data = resp.json().get("variables", {})
    rows = [
        {"name": k, "label": v.get("label", ""), "concept": v.get("concept", "")}
        for k, v in data.items()
        if k not in ("for", "in", "ucgid")
    ]
    return pd.DataFrame(rows).sort_values("name").reset_index(drop=True)


# ---------------------------------------------------------------------------
# Core download function
# ---------------------------------------------------------------------------

def download_pums(
    variables: list[str],
    states: list[str] | str = "all",
    year: int = 2022,
    span: int = 5,
    record_type: str = "person",
    output_dir: str | Path = "data",
    output_file: str | None = None,
    api_key: str | None = None,
    pause_between_requests: float = 0.5,
) -> pd.DataFrame:
    """
    Download ACS PUMS data from the Census API and save as a Parquet file.

    Parameters
    ----------
    variables : list[str]
        PUMS variable names to retrieve (e.g. ['AGEP', 'SEX', 'PWGTP']).
        SERIALNO is always included automatically.
    states : list[str] or "all"
        Two-digit FIPS state codes (e.g. ['48', '06']) or "all" for every
        state + DC. Puerto Rico is FIPS '72'.
    year : int
        ACS reference year (e.g. 2022).
    span : int
        1 for 1-year estimates, 5 for 5-year estimates.
    record_type : str
        "person" for person-level records (ST = 'person'),
        "housing" for housing-unit records (ST = 'housing').
    output_dir : str or Path
        Directory where the Parquet file will be written.
    output_file : str or None
        Parquet filename. Defaults to
        'acs{span}y_{year}_pums_{record_type}.parquet'.
    api_key : str or None
        Census API key. Reads from CENSUS_API_KEY env var if None.
    pause_between_requests : float
        Seconds to wait between state requests to avoid rate-limiting.

    Returns
    -------
    pd.DataFrame
        Combined DataFrame for all requested states.
    """
    key = api_key or _get_api_key()
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    if output_file is None:
        output_file = f"acs{span}y_{year}_pums_{record_type}.parquet"

    base = BASE_URL.format(year=year, span=span)

    # record_type maps to the PUMS 'for' clause geography code
    if record_type == "person":
        for_clause = "person:*"
    elif record_type == "housing":
        for_clause = "housing unit:*"
    else:
        raise ValueError("record_type must be 'person' or 'housing'")

    # Resolve state list
    if states == "all":
        state_list = _all_state_fips()
    elif isinstance(states, str):
        state_list = [states]
    else:
        state_list = list(states)

    # Always include SERIALNO so records can be linked; deduplicate
    vars_to_fetch = list(dict.fromkeys(["SERIALNO"] + [v.upper() for v in variables]))

    all_chunks: list[pd.DataFrame] = []

    for state_fips in state_list:
        print(f"  Fetching {record_type} records for state FIPS {state_fips} ...")
        in_clause = f"state:{state_fips}"

        state_frames: list[pd.DataFrame] = []

        # Batch variables to stay under the API limit
        # Always send SERIALNO in every batch so we can join later if needed
        non_serial = [v for v in vars_to_fetch if v != "SERIALNO"]
        batches = [
            ["SERIALNO"] + non_serial[i : i + _BATCH_SIZE]
            for i in range(0, len(non_serial), _BATCH_SIZE)
        ]
        if not batches:
            batches = [["SERIALNO"]]

        first_batch = True
        for batch in batches:
            params = {
                "get": ",".join(batch),
                "for": for_clause,
                "in": in_clause,
                "key": key,
            }
            resp = requests.get(base, params=params, timeout=60)
            resp.raise_for_status()

            raw = resp.json()
            header, *rows = raw
            df_batch = pd.DataFrame(rows, columns=header)

            if first_batch:
                state_frames.append(df_batch)
                first_batch = False
            else:
                # Merge additional batches on SERIALNO (drop duplicate SERIALNO col)
                df_merge = df_batch.drop(columns=["SERIALNO"], errors="ignore")
                state_frames[0] = pd.concat(
                    [state_frames[0].reset_index(drop=True),
                     df_merge.reset_index(drop=True)],
                    axis=1,
                )

        all_chunks.append(state_frames[0])
        time.sleep(pause_between_requests)

    df = pd.concat(all_chunks, ignore_index=True)

    out_path = output_dir / output_file
    df.to_parquet(out_path, index=False)
    print(f"\nSaved {len(df):,} records to {out_path}")
    return df


# ---------------------------------------------------------------------------
# State FIPS helper
# ---------------------------------------------------------------------------

def _all_state_fips() -> list[str]:
    """Return two-digit FIPS codes for all 50 states + DC + PR."""
    codes = list(range(1, 57))  # 01–56, with gaps for non-states
    # FIPS codes that don't correspond to states/DC/territories we want to skip
    skip = {3, 7, 14, 43, 52}
    return [str(c).zfill(2) for c in codes if c not in skip]


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Download ACS PUMS data from the Census API as Parquet."
    )
    parser.add_argument(
        "--variables", "-v",
        nargs="+",
        required=True,
        help="PUMS variable names, e.g. AGEP SEX PWGTP RAC1P HISP",
    )
    parser.add_argument(
        "--states", "-s",
        nargs="+",
        default=["all"],
        help="Two-digit state FIPS codes, or 'all' (default: all states).",
    )
    parser.add_argument("--year", "-y", type=int, default=2022,
                        help="ACS reference year (default: 2022).")
    parser.add_argument("--span", type=int, choices=[1, 5], default=5,
                        help="1-year or 5-year ACS (default: 5).")
    parser.add_argument(
        "--record-type", "-r",
        choices=["person", "housing"],
        default="person",
        help="Record type: person or housing (default: person).",
    )
    parser.add_argument("--output-dir", "-o", default="data",
                        help="Output directory (default: data/).")
    parser.add_argument("--output-file", "-f", default=None,
                        help="Output filename (default: auto-generated).")

    args = parser.parse_args()
    states_arg = args.states[0] if args.states == ["all"] else args.states

    download_pums(
        variables=args.variables,
        states=states_arg,
        year=args.year,
        span=args.span,
        record_type=args.record_type,
        output_dir=args.output_dir,
        output_file=args.output_file,
    )
