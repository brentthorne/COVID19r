countries_only <- covid19_tidy %>%
  group_by(Country, Date) %>% 
  summarise(Deaths_Daily = sum(Deaths_Daily))


ggplot() +
  
  #add trend line
  stat_smooth(data = countries_only, aes(x = Date, y = Deaths_Daily), colour = "#000000", alpha = 0.1, method = "gam", fill = NA) +
  
  #add points
  geom_point(data = countries_only, aes(x = Date, y = Deaths_Daily, size = Deaths_Daily), colour = "#00000050") +
  
  #add text
  geom_text(data = countries_only[c(1,length(countries_only$Date)),], aes(x = Date, y = Deaths_Daily + 25, label = Date), colour = "#000000", size = 5) +
  
  #customize the theme
  theme_fivethirtyeight() +
  labs(title = paste("COVID-19 Daily Deaths for **<span style='color:#000000'>Italy**</span> & **<span style='color:#cc0000'>", country, "</span>**", sep = ""),
       x = "Days Since First Death",
       y = "Deaths per Day",
       subtitle = "_Day 1 = First COVID-19 Death in Country_") +
  theme(legend.position = "none",
        plot.title = element_markdown(size = 30),
        plot.subtitle = element_markdown(size = 16),
        axis.title = element_markdown(size = 14)) +
  facet_wrap(~Country) +
  NULL
