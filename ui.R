#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Capstone Project: Predict the Next Word"),
  HTML("<br>"),
  
  # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          HTML("<h4><center>Instructions</center></h4>"),
          HTML("<br>"),
          HTML("<p>This app predicts the next word when you type in one or more words. </p>"),
          HTML("<p>Type in one or more words, select the number of predicted words by moving the sider, and then click the Predict button.</p>"),
          HTML("<p>Examples of words and phrases are: <i>I Don't, The United, Last.</i></p> "),
          HTML("<br>"),
          HTML("<p>The system will return a NA if it cannot predict the next word.</p>")

        ),
    
      # Show a plot of the generated distribution
        mainPanel(
          HTML("<br>"),
          h4("Enter a phrase of one or more words:"),
          tags$textarea("id"="in_text", rows=1, cols=80),
         
          HTML("<br>"),
          sliderInput("predictions", "Select upto 3 Predictions:",
                        value=1, min=1, max=3, step=1),
          
          actionButton("dopredict", "Predict"),
          HTML("<br>"),
          
          HTML("<p></p>"),
          br(),
          h4("The Next Predicted Word is:"),
          HTML('<div style="outline:#000 thin; display:table-cell; height:20px; width:100px; vertical-align:middle">'),
            verbatimTextOutput("out_text"),
          HTML("</div>"),
          HTML("<br><br>")
         
      )
    )
  )
)