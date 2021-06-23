load_connection_data <- function(date_from, date_to) {
    
    # http://docs.rstudio.com/shinyapps.io/metrics.html#ApplicationMetrics
    # data_usage <- rsconnect::showUsage(
    #     account = 'simplyrational', 
    #     appName = 'diagnostic_intuition_support', 
    #     usageType = 'hours', 
    #     from=as.numeric(as.POSIXct("2021-05-31", format="%Y-%m-%d")),
    #     until=as.numeric(as.POSIXct("2021-06-10", format="%Y-%m-%d"))
    # )
    
    data_connect <- rsconnect::showMetrics(
        metricSeries="container_status",
        metricNames=c("connect_count", 'connect_procs'),
        appName="diagnostic_intuition_support",
        server="shinyapps.io",
        from=as.numeric(as.POSIXct(date_from, format="%Y-%m-%d")),
        until=as.numeric(as.POSIXct(date_to, format="%Y-%m-%d"))
    ) 
    names(data_connect) = c('connect_count', 
                            'metric_series', 
                            'connect_procs', 
                            'timestamp')
    
    
    data <- data_connect %>%
        mutate( 
            # Clean variables
            connect_count = as.numeric(connect_count),
            connect_procs = as.numeric(connect_procs),
            timestamp = as.numeric(as.character(timestamp))
        ) %>%
        #    filter(connect_count == 1 & connect_procs == 1) %>% 
        mutate(
            # Additional variables
            date=as.Date(as.POSIXct(timestamp, origin="1970-01-01")),
            n_count=cumsum(connect_count),
            n_procs=cumsum(connect_procs),
            new_connect=case_when(
                connect_count>lag(connect_count, 1) ~ 
                    connect_count-lag(connect_count, 1),
                TRUE ~ 0),
            n_connect=cumsum(new_connect) # approximate
        ) %>% 
        filter(n_count>0)
    
    return(data)
}