library(shiny)
library(RODBC)
library(reshape2)
library(scales)
library(plyr)
library(ggplot2)

rm(list =ls(all=TRUE))
SQLdates.st <- paste("SELECT RefDate",
                     "FROM vw_AllPerfDataset", 
                     "GROUP BY RefDate", 
                     "ORDER BY RefDate DESC")

channel <- odbcConnect("SQLServerPerfRep")
AllDates<- sqlQuery(channel, SQLdates.st)
AllDates$RefDate <- as.Date(AllDates$RefDate)

close(channel)


runApp("SB_App1")
