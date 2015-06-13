load("wool.Rda")
load("woolU.Rda")



shinyUI(navbarPage("Gauge that gauge!",
                   tabPanel("Check",
                            fluidRow(
                               
                                column(7, offset = 1,
                                       
                                       sliderInput("slider1", label = h4("1. Select gauge"), min = min(wool$sts, na.rm=TRUE), 
                                                   max = max(wool$sts, na.rm=TRUE), 
                                                   value = 15),
                                       # value = round(mean(wool$sts, na.rm=TRUE),0)),
                                       p("How many stitches are there in your swatch (10 cm/4 inches)?")
                                ),
                                column(4, 
                                       radioButtons("inRadio", h4("2. Select needle sizes"),
                                                    c("Metric (mm)" = "mm",
                                                      "US" = "US"))
                                )
                                
                            ),
                            fluidRow(
                                hr(),
                                
                                column(7, offset = 1,
                                       h4("3. Check the results"),
                                       plotOutput('plot1')
                                ),
                                column(4,
                                       h4("\n"),
                                       htmlOutput("text1"),
                                       tableOutput("view")
                                )
                            )
                   ),
                   tabPanel("Data",
                            fluidRow(
                            column( 3,
                                selectInput('brand', 'Brand', 
                                            c('All', unique(wool$brand))
                                            ),
                                h4("Metadata"),
                                HTML("<p>This table contains the recommendend needle sizes for 
                                    a 10 x 10 mm (4\") gauge swatch knit in <strong>jersey (stockinette) 
                                    stitch</strong>. They should only be compared to jersey (stockinette) swatches.</p>
                                   <p>Data were collected in June 2015 from the sites of several
                                  manufacturers of knitting yarns.</p><p>Not all needle sizes are equally
                                     represented in the dataset:"),
                                
                                 img(src="histPlot.png", width = 275),

                                  HTML("<p>For more information about gauge and tension in knitting, see
                                    <em>Understanding Knitting Gauge</em> by Mary Smith at the 
                                     <a href='http://www.earthguild.com/products/knitcroc/marypat/gauge.htm'>
                                     Earth Guild</a>.")
                                ),
                            column( 8, offset = 1,
                                dataTableOutput('table')
                            )
                            )
                ),
                   
                   
                   tabPanel("Help",
                            HTML("<h5>This Shiny application lets you check the recommended needle size
                                     of a knititng pattern against the standard gauge swatches provided by  
                                 several yarn manufacturers.</h5>"),
                            fluidRow(
                                
                                column (4, 
                                        h3("1. Find your pattern's gauge"),
                                        img(src="gauge.png", width = 275)
                                ),
                                column (4, 
                                        h3("2. Select nr of stitches"),
                                        img(src="slider.png", width = 275),
                                        HTML("<p><br />Move the slider until it shows 
                                             the number you want.</p>")
                                ),
                                column (4, 
                                        h3("3. Select needle sizes"),
                                        img(src="radio.png", width = 250),
                                        p("Choose which system you prefer for 
                                          the needle sizes: metric (mm) or US numbers.")
                                ),
                                column (4, 
                                        h3("4. Check the plot"),
                                        img(src="plot.png", width = 275),
                                        HTML("<p><br />The red line moves with the slider and 
                                          shows which needles correspond to the chosen number
                                           of stitches.</p>
                                             <p>Light circles mean few data points.</p>")
                                ),
                                column (4, 
                                        h3("5. Compare with results"),
                                        img(src="table.png", width = 250),
                                        p("The 5.5 mm needles happen to be the least 
                                          usual choice for 15 sts swatches.")
                                ),
                                column (4, 
                                        h3("6. Explore the data"),
                                        img(src="data.png", width = 350),
                                        HTML("<p>Click on the <b>Data</b> tab to have a look 
                                             at the complete data set.</p>")
                                )
                               
                            ))
                        

))
