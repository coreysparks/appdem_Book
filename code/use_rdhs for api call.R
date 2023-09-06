library(rdhs)
set_rdhs_config(email = "corey.sparks@utsa.edu", timeout = 60, project = "Predictive modeling of Sub-Saharan African child health indicators", global = F, password_prompt = T)

#paste in password
datasets <- dhs_datasets(surveyIds = survs$SurveyId[1], fileFormat = "FL", fileType = "IR")
downloads <- get_datasets(datasets$FileName)



## stat compiler
resp <- dhs_data(indicatorIds = "ML_FEVT_C_AML", surveyYearStart = 2010,breakdown = "subnational")

# filter it to 12 countries for space
countries  <- c("Angola","Ghana","Kenya","Liberia",
                "Madagascar","Mali","Malawi","Nigeria",
                "Rwanda","Sierra Leone","Senegal","Tanzania")

# and plot the results
library(ggplot2)
ggplot(resp[resp$CountryName %in% countries,],
       aes(x=SurveyYear,y=Value,colour=CountryName)) +
  geom_point() +
  geom_smooth(method = "glm") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5)) +
  ylab(resp$Indicator[1]) +
  facet_wrap(~CountryName,ncol = 6)



## geographic data
d <- dhs_data(countryIds = "UG",
              indicatorIds = "FE_FRTR_W_A15",
              surveyYearStart = 2016,
              breakdown = "subnational", )

# d<-d%>%
#     filter(SurveyId=="UG2016DHS")
# get our related spatial data frame object
sp <- download_boundaries(surveyId = d$SurveyId[1], method = "sf" )

library(tidyverse)
sp<-left_join(sp$sdr_subnational_boundaries, d, by=c("REG_ID" = "RegionId"))
names(sp)

sp%>%
  ggplot()+
  geom_sf(aes(fill= Value))

plot(sp["Value"])

