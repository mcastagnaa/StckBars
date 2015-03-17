library(ggplot2)
library(scales)
library(plyr)
RawData <- read.csv("RawData.csv", header = TRUE)

RawData$Period_order <- factor(RawData$Period, levels= c("1m", "3m", "YtD", "1y", "2y", "3y", "5y"))
RawData <- ddply(RawData, .(Period, Quarter), 
                 transform, Ypos = cumsum(Percentage) - 0.5*(Percentage))
RawData$BarWidth <- with(RawData, ifelse(Quarter == "Last", 1, 0.85))

head(RawData)

ggplot()+
  geom_bar(data=RawData,
            aes(y=Percentage, x = Quarter, fill = Quartile), #, width = BarWidth
           stat= "identity",
            position = 'stack') +
            facet_grid(. ~ Period_order) + 
            scale_fill_brewer(palette="Greens") +
            scale_y_continuous(labels =percent) #+ 
#             geom_text(data=RawData, 
#                       aes(x = Quarter, y = Ypos, 
#                           label = percent(round(Percentage, digits=2)), 
#                           size = 2))

#            scale_fill_manual(values = c("blue","green", "yellow", "red"))
