#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(ngram)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #load the N-Gram models
  load("./ng2_blogs_dictionary.RData")
  load("./ng3_blogs_dictionary.RData")
  
  #code for Stupid Backoff Prediction Algorithm
  dropC = function (c) gsub("[^a-z ]", "", c) #drop everything except a-z and space
  #takes user input text and predicts the next topN words
  library(stringr)
  predict = function(intext, topN) {
    
    s = Corpus(VectorSource(intext))
    
    s = tm_map(s, tolower)
    s = tm_map(s, dropC)
    #s = tm_map(s, removeWords, stopwords("english"))
    
    str = concatenate(lapply(s, "[", 1))
    splitlist = unlist(strsplit(str, split = "\\s+"))
    n = length(splitlist)
    
    prediction = ""
    
    #search the Tri-Gram dictionary
    if (n >= 2) {
      s = n-1
      lasttwo = splitlist[s:n]    #get last two words
      lasttwo = str_c(lasttwo,collapse=' ')
      #r = subset(ng3_dictionary, head==lasttwo, select=c(tail,freq, freq1, freq2))
      r = subset(ng3_dictionary, head==lasttwo, select=c(tail,freq))
      if (nrow(r)!=0) {
        r[order(r$freq, decreasing=TRUE),]
        #allpredictions = paste(r[[1]], collapse=" ")
        #prediction = allpredictions
        topNpredictions = r[1:topN,1]
        prediction = topNpredictions       
      } else {
        n = 1
      }
    }
    #Back-off to the Bi-Gram dictionary
    if ( n == 1 ) {
      lastone = tail(splitlist, n=1)     #get last word
      r = subset(ng2_dictionary, head==lastone, select=c(tail, freq))
      if (nrow(r)!=0) {
        r[order(r$freq, decreasing=TRUE),]
        #allpredictions = paste(r[[1]], collapse=" ")
        #prediction = allpredictions
        topNpredictions = r[1:topN,1]
        prediction = topNpredictions
      }
    } 
    
    return(prediction)
  }  
  
  #get the user input: the words and the number of predictions
  observeEvent(input$dopredict, {
    input_text = as.character(input$in_text)
    number_predictions = input$predictions
  
    #predict the next word as output
    output_text = NULL
    if (grepl("^\\s*$", input_text)) {
      output$out_text=renderPrint(cat(""))
    } else {
      output_text = predict(input_text, number_predictions)
      output$out_text = renderPrint(cat(output_text, sep="\n"))
    }
  })
  
})
