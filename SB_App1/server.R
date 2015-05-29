shinyServer(function(input, output) {
  output$quartPerc <- renderPlot({
    rm(list =ls(all=TRUE))
    
    setDate <- as.character(input$Date1)
    
    channel <- odbcConnect("SQLServerPerfRep")
    PerfAll<- as.data.frame(sqlQuery(channel, paste0("EXEC spS_GetCEOPerfAll '",
                                                     setDate,"', null, 1")))
    close(channel)
    
    ##############################################
    
    colnames(PerfAll) <- gsub("AuMw", "AuMW",colnames(PerfAll))
    row.names(PerfAll) <- PerfAll$Qualifier
    
    LastDate = as.Date(as.character(PerfAll$RefDate))
    PrevDate = as.Date(as.character(PerfAll$PrevDate))
    
    RawData2 = subset(PerfAll, substr(PerfAll$Qualifier,5,5) == "Q", 
                      select = (grepl("^AuMW", names(PerfAll)) |
                                  grepl("^PAuMW", names(PerfAll))))
    
    colnames(RawData2) <- gsub("AuMW", "L",colnames(RawData2))
    colnames(RawData2) <- gsub("PL", "P",colnames(RawData2))
    
    RawData2$Quartile <- row.names(RawData2)
    
    RawData <- melt(RawData2, 
                    id.vars="Quartile", 
                    value.name = "Percentage",
                    variable.name = "Period")
    
    rm(list =c("RawData2", "PerfAll"))
    
    RawData$Month <- substr(RawData$Period, 1, 1)
    RawData$Month <- gsub("L", "Last",RawData$Month)
    RawData$Month <- gsub("P", "Previous",RawData$Month)
    
    RawData$Period <- substr(RawData$Period, 2,
                             nchar(as.character(RawData$Period)))
    
    RawData$Period_order <- factor(RawData$Period, 
                                   levels= c("1m", "3m", "YtD", "1y", "2y", "3y", "5y"))
    RawData <- ddply(RawData, .(Period, Month), 
                     transform, Ypos = cumsum(Percentage) - 0.5*(Percentage))
    RawData$BarWidth <- with(RawData, ifelse(Month == "Last", 1, 0.85))
    
    ######################################################
    
    ggplot()+
      ggtitle(paste(as.character(LastDate, "%b-%Y"),
                    "vs.", 
                    as.character(PrevDate, "%b-%Y"))) + 
      geom_bar(data=RawData,
               aes(y=Percentage, x = Month, fill = Quartile), 
               #width = RawData$BarWidth,
               stat= "identity",
               position = 'stack') +
      facet_grid(. ~ Period_order) + 
      scale_y_continuous(labels =percent) +
      geom_text(data=RawData,
                aes(x = Month, y = Ypos,
                    label = percent(round(Percentage, digits=2))),
                size = 3, color = "grey") +
      scale_fill_manual(values = c("blue","green", "yellow", "red"))
    
  })
})