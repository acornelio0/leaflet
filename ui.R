#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("united"),
  titlePanel(
    title = h2("Predict the Price of a Diamond by Carat", align = "center")
  ),
  br(),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "carat", label = strong("Carat:"),
          min = 0.02,
          max = 5.01,
          value = 2.0,
          step = 0.01
        ),
        HTML("Higher carat costs more.")
    ),
    mainPanel(
      helpText(
        "Select the Carat by the slider. The predicted price in US dollars will be shown on the chart and below the chart. The data is a random sampled subset of the diamonds dataset in R."
      ),
      hr(),
      
      plotOutput("plot"),
      h4("The predicted price of a Diamond in US dollars is: "),
      textOutput("pred"),
      textOutput("deg"),
      textOutput("deg1")
    )
  )
))
