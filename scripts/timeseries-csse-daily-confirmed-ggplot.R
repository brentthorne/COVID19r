library(tidyverse)
library(ggthemes)
library(ggdark)
library(ggtext)

ggplot() +
  
  #add trend line
  geom_line(data = covid19_day1_confirmed,
            aes(x = Day,
                y = Confirmed_Daily,
                colour = Country), 
            stat = "smooth",
            alpha = 0.5,
            method = "gam") +
  
  #add points
  geom_point(data = covid19_day1_confirmed,
             aes(x = Day,
                 y = Confirmed_Daily,
                 alpha = Day,
                 colour = Country,
                 size = Confirmed_Daily)) +
  
  # #add points
  # geom_line(data = covid19_day1_confirmed,
  #            aes(x = Day,
  #                y = Confirmed_Daily,
  #                colour = Country)) +
  
  geom_text(data = covid19_day1_confirmed %>%
              filter(Date == max(Date)), vjust = -0.75,
            aes(x = Day,
                y = Confirmed_Daily,
                label = Country,
                colour = Country),
            size = 5, alpha = 0.95,  family = "bold") +

  
  #customize the theme
  dark_mode(theme_fivethirtyeight()) +
  
  labs(title = paste0("COVID-19 New Daily Confirmed Cases ", max(covid19_day1_confirmed$Date)),
       x = "Days Since First Case",
       y = "New Confirmed Cases per Day",
       subtitle = "<span style='color: yellow;'>**Day 1**: _First COVID-19 Case in Country_</span> <br>
       **Data Source**: _Johns Hopkins CSSE_ <br>
       <span style='color: #cc0000;'>**Source Code**: _github.com/brentthorne/COVID19r_</span>") +
  
  theme(legend.position = "none",
        plot.title = element_markdown(size = 30),
        plot.subtitle = element_markdown(size = 14),
        axis.title = element_markdown(size = 14),
        axis.text = element_text(size = 12,face = "bold")) +
  
  # scale_colour_colorblind() +
  
  NULL

ggsave("figures/covid19-daily-confirmed.png", width = 11.7, height = 8.68)
