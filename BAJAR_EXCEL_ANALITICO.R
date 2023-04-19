rm(list=ls()) #borrando todo
dir<-"/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE" 
setwd(dir)
library(zoo)
library(xts)
library(readxl)
library(dplyr)
library(data.table)
tmp <- tempfile(fileext = ".xlsx")
list<-"https://www.secmca.org/ESTADISTICAS/EstadisticasSectorExterno/CR_ESEA.xlsx"
download.file(url = list, destfile = tmp, mode="wb")
exceldata <-  read_excel(tmp, sheet = "BPAnalitica", range = "B9:DQ49")
dfdata <- data.frame(exceldata)
dfdata_T<- transpose(dfdata)
colnames(dfdata_T) <- rownames(dfdata)
date<-seq(as.Date("1993-03-01"), as.Date("2022-12-01"), "quarters")
dfdata_T<-cbind(date, dfdata_T)
DATA <- select(dfdata_T, date, 2, 14, 18, 19, 20, 21, 24, 30, 33,37, 38)
DATA <- filter(DATA, date>= "2015-03-01")
colnames(DATA) <- c("date", "CC", "CK", "CF", "IDA", "IDP", "ICA", "ICP", "OIA", "OIP", "EO", "ACR")
write.zoo(DATA, sep = ";", file = 'CR_BP.csv')


