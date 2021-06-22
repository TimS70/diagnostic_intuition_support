root <- "C:/Users/TimSchneegans/Documents"
setwd(file.path(root, 'github', 'diagnostic_intuition_support', 'user_stats'))

library(tidyverse)
library(anytime)
library(scales)
library(lubridate)

source('load_data.R')

data = load_data()

grouped_new_connect <- data %>% 
    group_by(date) %>%
    dplyr::summarise(
        n=sum(new_connect),
        .groups='keep'
    )

ggplot(data=grouped_new_connect, aes(x=date, y=n)) +
    geom_bar(stat="identity") + 
    theme_minimal() +
    scale_x_date(
        labels = date_format("%d-%m-%Y"),
        breaks = grouped_new_connect$date) + 
    theme(
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.x=element_blank()
    ) +
    ggtitle('New Connections by Day')

ggsave(
    filename = file.path('results', 'connections.png'),
    width=5.5, height=5
)

data_cum_connections <- data %>%  
    select(n_connect, date) %>% 
    gather(key="key", value="value", -date)

ggplot(data_cum_connections) +
    labs(title="Cumulative Connections", x="", y="") +
    geom_line(aes(x=date, y=value, colour=key)) +
    facet_wrap(~key)

ggsave(
    filename = file.path('results', 'connections_cumulative.png'),
    width=5.5, height=5
)