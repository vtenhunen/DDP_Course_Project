# Libraries
library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)


      # make sure that we have right locale here
      Sys.setlocale("LC_TIME","en_US.UTF-8")
      
      # Let's have the Finnish road accident 2015 data
      DataURL2015="https://www.avoindata.fi/dataset/35f439f6-4512-444f-afd1-444356cb9524/resource/df40544f-7967-4224-8f02-6e0543f2e623/download/Tieliikenneonnettomuudet2015.zip"
      DataFile2015="./RoadTrafficAccidentsIn2015.zip"
      
      if(!file.exists(DataFile2015)){
            # Get the data for the assignment
            download.file(DataURL2015, DataFile2015)
      }
      
      # It is a zip packet, so we unzip it
      unzip(DataFile2015)
      
      # Next we read the data to the data frame 
      alldata2015 = read.csv("./Tieliikenneonnettomuudet_2015/tieliikenneonnettomuudet_2015_onnettomuus.csv", na.strings="NA", sep = ";", header = TRUE, fileEncoding = "latin1")
      
      # let's take only some columns:
      acd2015 <- select(alldata2015, Onnett_id, Vuosi, Kk, Päivä, Tunti, Vakavuusko, X, Y, Kuolleet, Loukkaant)
      
      # Rename columns, Finnish ones are not so informative
      colnames(acd2015)[1] <- "Accident_id" # Onnett_id
      colnames(acd2015)[2] <- "Year" # Vuosi
      colnames(acd2015)[3] <- "Month" # Kk
      colnames(acd2015)[4] <- "Date" # Päivä
      colnames(acd2015)[5] <- "Hour" # Tunti
      colnames(acd2015)[6] <- "Seriousness" # Vakavuusko
      colnames(acd2015)[7] <- "X" # X
      colnames(acd2015)[8] <- "Y" # Y
      colnames(acd2015)[9] <- "Deaths" # Kuolleet
      colnames(acd2015)[10] <- "Injuries" # Loukkaant
      
      # Remove NA-information
      acd2015 <- acd2015[complete.cases(acd2015),]
      
      # Now we convert the day format to the standard format 
      acd2015$Date <- as.Date(parse_date_time(acd2015$Date,"dmy"))

      ## Here we calculate accident frequenses, deads and injured by month
      accbymonth <- acd2015 %>%
            group_by(Month) %>%
            summarise(freq = n(), dead = sum(Deaths), injured = sum(Injuries)) 
      
      ## Here we calculate accident frequenses, deads and injured by day
      accbyday <- acd2015 %>%
            group_by(Date) %>%
            summarise(freq = n(), dead = sum(Deaths), injured = sum(Injuries)) 
      
      ## Now we calculate accident per hour of the day
      accbyhour <- acd2015 %>%
            group_by(Hour) %>%
            summarise(freq = n(), dead = sum(Deaths), injured = sum(Injuries)) 
      # clean -1 hour away, don't know why it is in the data
      accbyhour<-accbyhour[!(accbyhour$Hour=="-1"),]

## Shiny server function starts here      
shinyServer(function(input, output) {
            
      #### Plots. renderPlot creates reactive context
      #####################################
      output$plot <- renderPlot({

            # if user select in ui.R Monthly, this will create the plot            
            if (input$period == "y2015m"){
      
                  # Here we do histogram ggplot 
                  p <- ggplot(acd2015, aes(x=Month)) +
                        geom_histogram(aes(fill=..count..), binwidth = .5) +
                        scale_x_continuous(name = "Month",
                                          # layout need this 0 and 13
                                          breaks = seq(0, 13, 1),
                                          limits=c(0, 13),
                                          # Now we change numbers to more descriptive month labels
                                          labels=c("0" = "", 
                                                   "1" = "Jan", 
                                                   "2" = "Feb", 
                                                   "3" = "Mar", 
                                                   "4" = "Apr", 
                                                   "5" = "May", 
                                                   "6" = "Jun", 
                                                   "7" = "Jul", 
                                                   "8" = "Aug", 
                                                   "9" = "Sep", 
                                                   "10" = "Oct", 
                                                   "11" = "Nov", 
                                                   "12" = "Dec", 
                                                   "13" = ""))+
                  scale_fill_gradient("Count", low = "blue", high = "red") +
                  ggtitle("Accidents monthly") +      
                  labs(x="Month", y="")
                  p

            }
            
            # if user select in ui.R "Daily", this will create the plot      
            else if (input$period == "y2015d"){
            
                  #Here we do ggplot
                  p <- ggplot(accbyday, aes(x=Date, y=freq)) +
                        geom_point(shape=1, color="blue") + 
                        # here we do lm
                        geom_smooth(method=lm) + 
                        ggtitle("Accidents daily") +      
                        labs(x="Day", y="")
                  p
}

            # if user select in ui.R "Hourly", this will create the plot      
            else if (input$period == "y2015h") {
                  #Here we do ggplot
                  p <- ggplot(accbyhour, aes(x=Hour, y=freq)) +
                        geom_line(aes(colour = freq)) + 
                        geom_point(shape=1) + 
                        scale_colour_gradient(low="blue",high="red") +
                        scale_x_continuous(name = "Hour of the day",
                                           # layout need this 0 and 13
                                           breaks = seq(1, 24, 1),
                                           limits=c(1, 24))+
                        ggtitle("Accidents hourly") +
                        labs(x="Hour", y="")
                  p
            
      }      
      
      })
})