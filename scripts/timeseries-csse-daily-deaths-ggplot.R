library(tidyverse)
library(ggthemes)
library(ggdark)
library(ggtext)

ggplot() +
  
  #add trend line
  geom_line(data = covid19_day1,
              aes(x = Day,
                  y = Deaths_Daily,
                  colour = Country), 
            stat = "smooth",
            alpha = 0.5,
            method = "gam") +
  
  #add points
  geom_point(data = covid19_day1,
             aes(x = Day,
                 y = Deaths_Daily,
                 alpha = Day,
                 colour = Country,
                 size = Deaths_Daily)) +
  
  # #add points
  # geom_line(data = covid19_day1,
  #            aes(x = Day,
  #                y = Deaths_Daily,
  #                colour = Country)) +
  
  geom_text(data = covid19_day1 %>%
              filter(Date == max(Date),
                     Country != "Canada"),nudge_x = 1, nudge_y = 16,
            aes(x = Day,
                y = Deaths_Daily,
                label = Country,
                colour = Country),
            size = 5, alpha = 0.95,  family = "bold") +
  
  geom_text(data = covid19_day1 %>%
              filter(Date == max(Date),
                     Country == "Canada"),nudge_x = 2, nudge_y = -15,
            aes(x = Day,
                y = Deaths_Daily,
                label = Country,
                colour = Country),
            size = 5, alpha = 0.95,  family = "bold") +
  
  #customize the theme
  dark_mode(theme_fivethirtyeight()) +
  
  labs(title = paste("COVID-19 New Daily Deaths"),
       x = "Days Since First Death",
       y = "Deaths per Day",
       subtitle = "_Day 1 = First COVID-19 Death in Country_ <br> _Data Source: Johns Hopkins CSSE_") +
  
  theme(legend.position = "none",
        plot.title = element_markdown(size = 30),
        plot.subtitle = element_markdown(size = 16),
        axis.title = element_markdown(size = 14),
        axis.text = element_text(size = 12,face = "bold")) +
  
  # scale_colour_colorblind() +
  
  NULL

ggsave("figures/covid19-daily-deaths.png", width = 11.8, height = 8.68)
