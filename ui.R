# Reactive
library(shiny)

shinyUI(fluidPage(
      titlePanel("When road accidents took a place in Finland 2015"),
      
      sidebarLayout(

            sidebarPanel(

                  h4("Select the information you like to look and click the Submit button."),
                  selectInput("period", "Period:",
                              c("Monthly" = "y2015m",
                                "Daily" = "y2015d",
                                "Hourly" = "y2015h")
#                              selected = "Month"
),
                  submitButton("Submit")                   
            ),
            mainPanel(
                  tabsetPanel(type = "tabs", 
                              tabPanel("Application", br(),
                                          plotOutput("plot")),
                  tabPanel("Documentation", br(), 
                                       h1("Finnish Road Accidents App"),
                                       p("This app is for presentation of the Road Accidents in Finland in 2015. Graphs present accidents on a monthly, daily and hourly basis. This is also my Course project for Coursera Developing Data Product course by Johns Hopkins University."),
                                       h2("How to use"),
                                       p("Select from the drop down menu how you like to look the accident data and click the Submit button. Monthly graph is selected as a default. In the main panel, under the Application tab you can see results."),
                                          h2("Descriptions"),
                                          p("Monthly data describe how many traffic accidents happend in Finland each month in 2015."),
                                          p("Daily data shows number of accidents in each day of the year and linear model smoothed mean."),
                                          p("Hourly data describe sums of accidents in each hour of the day."),
                                       h2("Source code"),
                                       p("Source code of this app has published in the GitHub and with the MIT licence."),
                                       h2("About the data"),
                                          list(
                                          tags$p("Finnish Transport Agency collects annual road trafic accident data It is based on information received from the law enforcement officials and Statistics Finland. Data has licenced with the Creative Commons 4.0 BY."),
                                          tags$p("Links:"),
                                          tags$a(href="http://tinyurl.com/zk2fshn", "Source of the data in the Avoindata.fi website."),
                                          tags$br(),
                                          tags$a(href="https://creativecommons.org/licenses/by/4.0/", "Licence of the Data: CC 4.0 BY"),
                                          tags$br(),
                                          tags$a(href="http://github.com", "Source code of this app")
                                          )
                                    )
                              )
                        )
                  )
            )
     )