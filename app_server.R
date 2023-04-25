# Define server
source("scripts/analysis.R")
source("apikey.R")

server <- function(input, output) {
  dataInput <- reactive({
    getSymbols(
      input$symb,
      src = "yahoo",
      from = input$dates[1],
      to = input$dates[2],
      auto.assign = FALSE
    )
  })
  
  finalInput <- reactive({
    return(dataInput())
  })
  
  output$plot <- renderPlot({
    candleChart(
      dataInput(),
      up.col = "darkgreen",
      dn.col = "red",
      theme = "white",
      name = input$symb
    )
  })
  
  output$news <- renderDataTable({
    news_results <- get_everything(query = input$chooseQuery, source = input$chooseSource, api_key = NEWS_API_KEY)
    articles <- news_results$results_df %>%
      select(title, author, published_at, url) %>%
      rename("Title" = title, "Author" = author, "Date" = published_at, "Link" = url)
    articles$Date <- substr(articles$Date, 1, 10)
    articles <- datatable(articles, rownames = FALSE,
                          options = list(searching = FALSE,
                                         ordering = FALSE,
                                         initComplete = JS(
                                           "function(settings, json) {",
                                           "$(this.api().table().header()).css({'background-color': '#333333', 'color': '#fff'});",
                                           "}")
                          ))

    return(articles)
  })
  

  output$scatter <- renderDataTable({
    fig <- ggplot(data = df, aes(x = X3.Months.Perf, y = Score, color = Rating)) +
      geom_point()+
      labs(
        title = "Complete Dataset",
        x = "3 Month Performance",
        y = "Score"
      )
    
    scatter_plot <- ggplotly(fig)
    # scatter_plot <- scatter_plot %>%
    #   animation_opts(
    #     1000, easing = "elastic", redraw = FALSE
    #   )
    return(scatter_plot)
  })

  output[["r_graph"]] <- renderImage({
    outfile <- tempfile(fileext='.gif')
    r <- reddit_urls(search_terms = input[["reddit1"]], subreddit = input[["reddit2"]], page_threshold = 20, sort_by = "new")%>%
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
    
    anim_save("outfile.gif", animate(animateplot))
    
    list(src = "outfile.gif",
         contentType = 'image/gif'
         
    )}, deleteFile = TRUE)
}
