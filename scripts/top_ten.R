content <- read_html("http://gambiste.com/")
tables <- content %>% html_table(fill = TRUE)
df <- do.call(rbind.data.frame, tables)
# f <- file.choose()
# df <- read.csv(f)
top <- head(df, 10)
top_table <- top %>% select(Rank, Name, Score, `3 Months Perf`) %>%
  rename("Company Name" = Name, "3-Month Performance" = `3 Months Perf`)
symbols <- top[['Symbol']]