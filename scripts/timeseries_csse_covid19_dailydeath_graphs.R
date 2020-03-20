library(tidyverse)
library(ggthemes)
library(ggtext)
library(ggrepel)

covid19_tidy <- read_csv("csse_covid19_timeseries_combined_tidy.csv")

countries_of_interest <- c("China", "US", "Canada")

i = 1

for (i in 1:length(countries_of_interest)) {
  
country <- countries_of_interest[i]

covid_italy <- covid19_tidy %>% 
  filter(Country == "Italy",
         Deaths_Total > 0)

covid_italy$Day <- 1:length(covid_italy$Date)

covid_other <- covid19_tidy %>% 
  filter(Country == country,
         Deaths_Total > 0) %>% 
  group_by(Date) %>% 
  summarise(Deaths_Daily = sum(Deaths_Daily))

covid_other$Day <- 1:length(covid_other$Date)

deaths_total_italy <- covid_italy$Deaths_Total[length(covid_italy$Deaths_Total)]

ggplot() +
  geom_point(data = covid_italy, aes(x = Day, y = Deaths_Daily, size = Deaths_Daily), colour = "#00000050") +
  geom_point(data = covid_other, aes(x = Day, y = Deaths_Daily, size = Deaths_Daily), colour = "#cc000050") +
  stat_smooth(data = covid_italy, aes(x = Day, y = Deaths_Daily), colour = "#000000", alpha = 0.1, method = "gam", fill = NA) +
  stat_smooth(data = covid_other, aes(x = Day, y = Deaths_Daily), colour = "#cc0000", alpha = 0.1, method = "gam", fill = NA) +
  geom_text(data = covid_italy[c(1,length(covid_italy$Date)),], aes(x = Day, y = Deaths_Daily + 25, label = as.character(Date)), colour = "#000000", size = 5) +
  geom_text(data = covid_other[c(1,length(covid_other$Date)),], aes(x = Day, y = Deaths_Daily - 20, label = as.character(Date)), colour = "#cc0000", size = 5) +
  theme_fivethirtyeight() +
  geom_text(mapping = "tr", aes(label = "Data from Johns Hopkins")) +
  labs(title = paste("COVID-19 Daily Deaths for **<span style='color:#000000'>Italy**</span> & **<span style='color:#cc0000'>", country, "</span>**", sep = ""),
       x = "Days Since First Death",
       y = "Deaths per Day",
       subtitle = "_Day 1 = First COVID-19 Death in Country_") +
  theme(legend.position = "none",
        plot.title = element_markdown(size = 30),
        plot.subtitle = element_markdown(size = 16),
        axis.title = element_markdown(size = 14)) +
  NULL

ggsave(paste0("figures/covid-19_daily_deaths_italy_",country,"_",Sys.Date(),".png"))

}
