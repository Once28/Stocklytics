library(RedditExtractoR)
library(dplyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(png)

r <- reddit_urls(search_terms = 'GME', subreddit = 'investing', page_threshold = 20, sort_by = "new")%>%
  mutate(date = as.Date(date, "%d-%m-%y"))

min_date <- as.Date(Sys.time()) - 14
max_date <- as.Date(Sys.time())

reddit <- r %>% filter(date >=min_date  & date <=max_date)

reddit_df <-
reddit %>%
  group_by(date) %>%
  summarise(Total = sum(num_comments))

myplot <- ggplot(reddit_df, aes(x=date, y=Total)) + 
  geom_point(aes(size=3)) 

animateplot <- myplot + transition_time(date) +
  shadow_mark() + xlab("Date") + ylab("Occurences on Reddit")

animate(animateplot)

#######
source("top_ten.R")

for (x in symbols) {
  
  r <- reddit_urls(search_terms = x, subreddit = 'stocks', page_threshold = 20, sort_by = "new")%>%
    mutate(date = as.Date(date, "%d-%m-%y"))
  
  min_date <- as.Date(Sys.time()) - 14
  max_date <- as.Date(Sys.time())
  
  reddit <- r %>% filter(date >=min_date  & date <=max_date)
  
  reddit_df <-
    reddit %>%
    group_by(date) %>%
    summarise(Total = sum(num_comments))
  
  myplot <- ggplot(reddit_df, aes(x=date, y=Total)) + 
    geom_point(aes(size=3)) 
  
  animateplot <- myplot + transition_time(date) +
    shadow_mark() + xlab("Date") + ylab("Occurences on Reddit") +
    ggtitle('{closest_state}', subtitle='Frame {frame} of {nframes}')
  
  animate(animateplot)
  
  break

}


