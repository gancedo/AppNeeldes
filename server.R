load("wool.Rda")
load("woolU.Rda")

# Set transparency level for points
alpha <- 30

# build palette
mypalette <- function(alpha){
    palette(c(
        rgb( 123, 134, 194,alpha, max=255), # 7B86C2
        rgb( 123, 134, 194,alpha, max=255), # BED730
        rgb(  190, 215, 48,alpha, max=255), # F5E69D
        rgb( 245, 230, 157,alpha, max=255), # 588944
        rgb(  88, 137, 68,alpha, max=255), # 854337
        rgb(  154, 94, 166,alpha, max=255), #  9A5EA6
        rgb( 229, 196, 115,alpha, max=255), # E5C473
        rgb(  185, 139, 80,alpha, max=255), # B98B50
        rgb(  97, 39, 109,alpha, max=255), # 61276D
        rgb(  46, 54, 143,alpha, max=255), #2E368F
        rgb( 215, 139, 108,alpha, max=255), # D78B6C
        rgb(  110, 54, 74,alpha, max=255), # 6E364A
        rgb( 123, 134, 194,alpha, max=255), # FFE6B9
        rgb( 16, 154, 215,alpha, max=255), # 109AD7
        rgb(  114, 185, 168,alpha, max=255), # 72B9A8
        rgb( 123, 134, 194,alpha, max=255), #  B9CEF1
        rgb(  201, 101, 40,alpha, max=255) # C96528
    ))
}

# labels for the ticks of the x-axis
mmLabels <- c("2","3","4","5","6",   "7",  "8" ,"9","10","11","12","14","16")
usLabels <- c("0","2","6","8","10","10.5","11","13","15","-", "17","-","19" )

# the data for the main plot does not change
plotData <-  wool[, c("mm", "sts")]


shinyServer(function(input, output, session) {
    
    # labels for the x-axis in the plot
    plotLabels <- reactive({
        switch(input$inRadio,
               "mm" = mmLabels,
               "US" = usLabels)
    })
    
    # labels in the text
    sizeGauge <- reactive({
        switch(input$inRadio,
               "mm" = "10 cm",
               "US" = "4 inches")
    })
   
    datasetInput <- reactive({
       cols <- c(tolower(input$inRadio),"weight")
       woolUnique <- woolU[woolU$sts==as.numeric(input$slider1), cols]
       woolUnique[order(-woolUnique$weight),]
   })
    
    output$plot1 <- renderPlot({
        mypalette(30)
        par(mar = c(5.1, 4.1, 0, 1))
        plot(plotData,
             col=wool$mm,
             axes=FALSE,
             pch = 20, cex = 2,
             ylab= paste0("Stitches per ", sizeGauge()),
             xlab = paste0("Needle size (",input$inRadio, ")" )) 
        axis(1,at=c(2,3,4,5,6,7,8,9,10,11,12,14,16), 
             labels=plotLabels())
        axis(side = 2, las = 1)
        abline(h=input$slider1, col="red", lwd=2)
    })
    
    output$text1 <- renderUI({
        if (nrow(datasetInput()) > 0 ) {
        str1 <- paste("<h4>Most common needle sizes for 
                      <strong>", input$slider1,   "</strong> stitches are:")
        HTML(str1)
       
    } else {
        str1 <- paste("<hr>Sorry! There are no records for swatches with 
                      <strong>", input$slider1,   "</strong> stitches.")
         HTML(str1)
    }
        
    })
    
  output$view <- renderTable({
      mydat <- datasetInput()
      if (nrow(mydat)>0 ){
          if (input$inRadio == "mm") {
              mydat[,1] <- as.character(round(mydat[,1],2))
          }
          mydat$weight <- as.character(mydat$weight)
          colnames(mydat) <- c(paste0("Needle sizes (", input$inRadio,")"), "Nr of swatches")
          mydat
      }
  }, 
  include.rownames=FALSE)
  

  output$table <- renderDataTable({
      data <- wool
      if (input$brand != "All") {
          data <- wool[wool$brand == input$brand,]
      }
      data
  }, 
  options = list(searching = FALSE))
  
  })