library(tidyverse)
library(lubridate)

covid19_tidy <- read_csv("csse_covid19_timeseries_combined_tidy.csv")

covid19_day1 <- c()

i = 1

for (i in 1:length(countries_of_interest)) {
  
country <- countries_of_interest[i]

if (country == "France") {

  covid_other <- covid19_tidy %>%
    filter(Country == country,
           Deaths_Total > 0) %>%
    group_by(Date) %>%
    summarise(Deaths_Daily = sum(Deaths_Daily))

  covid_other$Day <- 1:length(covid_other$Date)
  covid_other$Country <- country
  covid_other <- covid_other %>% filter(Day > 12)
  covid_other$Day <- 1:length(covid_other$Date)

}else{
  
  covid_other <- covid19_tidy %>% 
    filter(Country == country,
           Deaths_Total > 0) %>% 
    group_by(Date) %>% 
    summarise(Deaths_Daily = sum(Deaths_Daily))
  
  covid_other$Day <- 1:length(covid_other$Date)
  covid_other$Country <- country

}

covid19_day1 <- rbind(covid19_day1,covid_other)

}
