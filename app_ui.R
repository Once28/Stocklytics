source("scripts/top_ten.R")

home_page <- tabPanel(
  "Twitter Analytics",
  titlePanel("Stock Visualizations"),
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        helpText(
          "Select a date range and a stock to examine.
          Information collected from Yahoo Finance."
        ),
        dateRangeInput(
          "dates",
          "Date range",
          start = "2013-01-01",
          end = as.character(Sys.Date())
        ),
        selectInput("symb", "Top Stocks:",
                    c(symbols))
      ),
      mainPanel(
        plotOutput(
          "plot"
        ),
        br(),
        br()
      )
    ),
    datatable(top_table, 
              rownames = FALSE,
              options = list(searching = FALSE,
                             lengthChange = FALSE,
                             paging = FALSE,
                             initComplete = JS(
                               "function(settings, json) {",
                               "$(this.api().table().header()).css({'background-color': '#333333', 'color': '#fff'});",
                               "}")
              )
    )
  )
)




mission <- tabPanel("Mission Statement",
                    sidebarLayout(sidebarPanel(
                      h1("ABOUT US"),
                      p(
                        "We are Augene Pak, Dhruv Karia, Justin Zeng, and
                         Max Bennett. We are Informatics majors in the
                         University of Washington and are each a member of the
                         Information School's class of 2024."
                      ),
                      tags$img(src = "https://ischool.uw.edu/sites/default/files/2020-03/iSchool_og.png", width = "325px")
                      # https://pbs.twimg.com/profile_images/1113979497261359107/jl4sZWA8_400x400.png
                    ),
                    mainPanel(
                      h1("OUR MISSION"),
                      p("Our mission is to enable retail traders with the tools and knowledge needed to invest like a pro.
                         We aim to be the most effective, comprehensive, and intuitive online trading information platform providing our
                         customers with professional education and successful trading ideas on the best stocks. We can help you to trade
                         successfully with our best stocks, amazing trading tools and straightforward analysis, all in an easy-to-use manner."
                      ),
                      h1("ABOUT STOCKLYTICS"),
                      p("Our app provides an integrated stock trends platform for reading past events, focusing on providing research,
                         trading, and analytics tools to traders. The platform provides a suite of tools that simplify stock trading analysis.
                         Our app uses both twitter and reddit pages to figure out which stocks were talked about the most. Then, through
                         organzing this data, we empower our traders with the knowledge and tools to trade profitably in the stock market.")
                    ),
                    position = "right"))

news_page <- tabPanel("Trending Stock News",
                      sidebarLayout(
                        sidebarPanel(
                          h1("Choose a Company"),
                          selectInput("chooseQuery", "Options", c(symbols)),
                          h1("Choose a Source"),
                          selectInput("chooseSource", "Options", terms_sources$sources)
                        ),
                        mainPanel(
                          h1("News"),
                          dataTableOutput("news")
                        )
                      ),
)

reddit <- tabPanel("Reddit Analytics",
                   sidebarLayout(
                     sidebarPanel(
                       h1("Choose a Company"),
                       selectInput("reddit1", "Options", c(symbols)),
                       h1("Choose a Subreddit"),
                       selectInput("reddit2", "Options", c("stocks", "wallstreetbets", "investing"))
                     ),
                     mainPanel(h1("Reddit Engagement for Each Stock"),
                               withSpinner(imageOutput("r_graph"))),
                   ))

# Define UI
ui <- fluidPage(
  theme = shinytheme("yeti"),
  navbarPage("Stocklytics",
             home_page,
             news_page,
             reddit,
             mission),
  # Loading icon
  add_busy_spinner(
    spin = "fingerprint",
    color = "#333333",
    margins = c(40, 20),
    height = "5%",
    width = "5%",
    position = "bottom-right",
    timeout = 5
  )
)