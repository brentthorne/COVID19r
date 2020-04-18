library(tidyverse)

new.data <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")


europe <- new.data %>% filter(region == "Europe")

covid_europe <- covid19_day1 %>% 
  filter(Country %in% c(europe$name,"United Kingdom")) %>% 
  group_by(Date) %>% 
  summarise(Deaths_Daily = sum(Deaths_Daily)) %>% 
  mutate(Day = 1:length(Date),
         Country = "Europe")

covid_usa <- covid19_day1 %>% 
  filter(Country == "US")


covid_us_europe <- full_join(covid_usa,covid_europe)


ggplot() +
  
  #add trend line
  geom_line(data = covid_us_europe,
            aes(x = Day,
                y = Deaths_Daily,
                colour = Country), 
            stat = "smooth",
            alpha = 0.5,
            method = "gam") +
  
  #add points
  geom_point(data = covid_us_europe,
             aes(x = Day,
                 y = Deaths_Daily,
                 alpha = Day,
                 colour = Country,
                 size = Deaths_Daily)) +
  
  geom_text(data = covid_us_europe %>%
              filter(Date == max(Date)),
            hjust = -0.5,
            vjust = 0.5,
            aes(x = Day,
                y = Deaths_Daily,
                label = Country,
                colour = Country),
            size = 5, angle = 90, alpha = 0.95,  family = "bold") +
  
  #customize the theme
  dark_mode(theme_fivethirtyeight()) +
  
  labs(title = paste0("COVID-19 New Daily Deaths ",max(covid19_day1$Date)),
       x = "Days Since First Death",
       y = "Deaths per Day",
       subtitle = "<span style='color: yellow;'>**Day 1**: _First COVID-19 Death in Country_</span> <br>
       **Data Source**: _Johns Hopkins CSSE_ <br>
       <span style='color: #cc0000;'>**Source Code**: _github.com/brentthorne/COVID19r_</span>") +
  
  theme(legend.position = "none",
        plot.title = element_markdown(size = 30),
        plot.subtitle = element_markdown(size = 14),
        axis.title = element_markdown(size = 14),
        axis.text = element_text(size = 12,face = "bold")) +
  
  # scale_colour_colorblind() +
  
  NULL

ggsave("figures/covid19-daily-deaths_USvEurope.png", width = 11.7, height = 8.68)
