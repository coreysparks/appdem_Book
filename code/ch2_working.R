library(tidycensus)
library(tidyverse)
library(srvyr)
library(survey)

pums_vars_18<- pums_variables%>%
  filter(year== 2018, survey == "acs1")%>%
  distinct(var_code, var_label, data_type, level)%>%
  filter(level == "person")


TX_pums <- get_pums(
  variables = c("PUMA", "SEX", "AGEP", "CIT", "JWTR", "HISP"),
  state = "TX",
  survey = "acs1",
  year = 2018
)

names(TX_pums)
head(TX_pums)

library(ipumsr)
ddi<- read_ipums_ddi(ddi_file = "data/usa_00096.xml")
ipums <- read_ipums_micro(ddi = ddi)


dhs<-haven::read_dta("https://github.com/coreysparks/data/blob/master/ZZIR62FL.DTA?raw=true")
dhs<-haven::zap_labels(dhs)
dhs$v005<- dhs$v005/1000000
dhs2<- select(dhs, v021, v022, v005, v139, v151)

names(dhs2)
library(dplyr); library(gtsummary)
options(survey.lonely.psu = "adjust")
t1<- survey::svydesign(ids = ~v021,
               strata=~v022,
               weights = ~v005,
               data=dhs2)%>%
  gtsummary::tbl_svysummary(by = "v139", include = c(v139,v151))%>%
  as_kable()

survey::svydesign(ids = ~v021,
                  strata=~v022,
                  weights = ~v005,
                  data=dhs2)%>%
  tbl_svysummary(by = "v139", include = c(v151, v139))


library(tableone)
svyCreateTableOne(vars = "v151", strata= "v139", data=t1)
