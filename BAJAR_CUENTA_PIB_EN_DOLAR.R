rm(list=ls()) #borrando todo
dir<-"/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE"
setwd(dir)
library(zoo)
library(xts)
library(readxl)
library(dplyr)
library(data.table)
library(rvest)
tmp <- tempfile(fileext = ".xls")
ORIGEN<-paste("https://www.secmca.org/chart/?parent=Producci%C3%B3n&scid=1&cid=1&scsid=1&son=Producto%20Interno%20Bruto%20%20%20trimestral&url=9/14/3-13-50-17-4-52-161/36/24/20-21-258/359/2015I-2015II-2015III-2015IV-2016I-2016II-2016III-2016IV-2017I-2017II-2017III-2017IV-2018I-2018II-2018III-2018IV-2019I-2019II-2019III-2019IV-2020I-2020II-2020III-2020IV-2021I-2021II-2021III-2021IV-2022I-2022II-2022III-2022IV-&all_vars=2|PIB%20trimestral%20a%20precios%20corrientes-ME#", sep="")
datahtml <- read_html(ORIGEN)
datahtml <- html_nodes(datahtml, "table")
datahtml <- html_table(datahtml, header = TRUE, fill = TRUE)[[1]]
write.csv(datahtml, "/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/PIB.csv")

DATA<-read.csv("/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/PIB.csv", sep = ",")
DATA<-filter(DATA, X>=6)
colnames(DATA)<-c("X","FECHA","CR", "SV", "GT", "HN","NI", "DO","PA") 
dfdata <- data.frame(DATA)
date   <- seq(as.Date("2015-03-01"), as.Date("2022-12-01"), "quarter")
dfdata <- cbind(dfdata, date)
dfdata <- dfdata[ , -c(1)]
write.csv(dfdata, "/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/PIB_CA.csv")


