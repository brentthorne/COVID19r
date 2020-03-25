#load libraries used
library(tidyverse)
library(lubridate)

#read raw data
link <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
deaths_raw    <- read_csv(paste0(link,"deaths_global.csv"))
confirm_raw   <- read_csv(paste0(link,"confirmed_global.csv"))

#tidy data
#deaths
deaths_tidy <- deaths_raw %>% 
  gather(key = "Date", value = "Deaths_Total", c(5:length(deaths_raw))) %>% 
  rename(Country = `Country/Region`,
         ProvState = `Province/State`) %>% 
  mutate(Date = as_date(x = Date, format = "%m/%d/%y", tz = "UTC")) %>% 
  group_by(Country, ProvState) %>% 
  arrange(Country, ProvState, Date) %>%
  mutate(Deaths_Daily = Deaths_Total - lag(Deaths_Total, default = first(Deaths_Total)))

#confirmed
confirm_tidy <- confirm_raw %>% 
  gather(key = "Date", value = "Confirmed_Total", c(5:length(confirm_raw))) %>% 
  rename(Country = `Country/Region`,
         ProvState = `Province/State`) %>% 
  mutate(Date = as_date(x = Date, format = "%m/%d/%y", tz = "UTC")) %>% 
  group_by(Country, ProvState) %>% 
  arrange(Country, ProvState, Date) %>%
  mutate(Confirmed_Daily = Confirmed_Total - lag(Confirmed_Total, default = first(Confirmed_Total)))

# #recovered
# recovered_tidy <- recovered_raw %>% 
#   gather(key = "Date", value = "Recovered_Total", c(5:length(confirm_raw))) %>% 
#   rename(Country = `Country/Region`,
#          ProvState = `Province/State`) %>% 
#   mutate(Date = as_date(x = Date, format = "%m/%d/%y", tz = "UTC")) %>% 
#   group_by(Country, ProvState) %>% 
#   arrange(Country, ProvState, Date) %>%
#   mutate(Recovered_Daily = Recovered_Total - lag(Recovered_Total, default = first(Recovered_Total)))

#combine confirmed and deaths  
covid19_tidy <- full_join(deaths_tidy,confirm_tidy)
# covid19_tidy   <- full_join(covid19_tidy_1,recovered_tidy)

#write outputff
write_csv(covid19_tidy,"csse_covid19_timeseries_combined_tidy.csv")
