library(RODBC)

rm(list =ls(all=TRUE))

channel <- odbcConnect("SQLServerPerfRep")


PerfAll<- as.data.frame(sqlQuery(channel, "EXEC spS_GetCEOPerfAll '2015-04-30', null, 1"))
#PerfDesk<- as.data.frame(sqlQuery(channel, "EXEC spS_GetCEOPerfDesk '2015-04-30', null, 1"))

close(channel)

save(PerfAll, file = "PerfAll.Rda")
#save(PerfDesk, file = "PerfDesk.Rda")

