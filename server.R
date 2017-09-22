#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
data(diamonds)

shinyServer(function(input, output) {
  myData <- diamonds[sample(1:nrow(diamonds), 500, replace=FALSE),]

  model <- lm(price ~ carat, data = myData)
  
  modelpred <- reactive( {
    caratinput <- input$carat
    predict(model, newdata = data.frame(carat = caratinput))
  } ) 

  output$plot <- renderPlot({
    caratinput <- input$carat
    plot(myData$price, myData$carat, xlab = "Price", ylab = "Carat", pch=16, col="blue")
    points(modelpred(), caratinput, col="red", pch=23, bg="green", cex=2)
  })
  output$pred <- renderText({ modelpred() })
})