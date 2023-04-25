# Load libraries
library(shiny)
library(shinybusy)
library(shinythemes)
library(tidyverse)
library(rvest)
library(quantmod)
library(DT)
library(newsanchor)
library(jsonlite)
library(httr)
library(RedditExtractoR)
library(gganimate)
library(gifski)
library(png)
library(plotly)
library(shinycssloaders)

# Source UI and server
source("app_ui.R")
source("app_server.R")

# Run shiny app
shinyApp(ui = ui, server = server)