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
ORIGEN<-paste("https://www.secmca.org/chart/?parent=Balanza%20de%20pagos&scid=0&cid=7&scsid=0&son=Cuenta%20corriente&url=31/14-238/3-13-50-17-4-52-161/36/266-268/21/268-665-666-667-668-672-685-686-687-688/2018I-2018II-2018III-2018IV-2019I-2019II-2019III-2019IV-2020I-2020II-2020III-2020IV-2021I-2021II-2021III-2021IV-2022I-2022II-2022III-2022IV-&all_vars=1|Cuenta%20Corriente*2|Balance%20de%20bienes*3|Balance%20de%20servicios*4|Balance%20ingreso%20primario*5|Balance%20ingreso%20secundario*6|Cuenta%20corriente,%20acumulada*7|Balance%20bienes,%20acumulado*8|Balance%20servicios,%20acumulado*9|Balance%20ingreso%20primario,%20acumulado*10|Balance%20ingreso%20secundario,%20acumulado#", sep="")
datahtml <- read_html(ORIGEN)
datahtml <- html_nodes(datahtml, "table")
datahtml <- html_table(datahtml, header = TRUE, fill = TRUE)[[1]]
write.csv(datahtml, "/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/CC.csv")
DATA<-read.csv("/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/CC.csv", sep = ",")
DATA<-filter(DATA, X>=6)
B<-c()
P<-c("CR", "SV", "GT", "HN","NI", "DO","PA") 
i<-3
for (L in 1:length(P)){
  for (k in 1:10){
    a<-paste0(P[L], k, sep = "")
    B[i]<-a
    i<-i+1
  }
}
colnames(DATA)<-B
dfdata <- data.frame(DATA)
date   <- seq(as.Date("2018-03-01"), as.Date("2022-09-01"), "quarter")
dfdata <- cbind(dfdata, date)
dfdata <- dfdata[ , -c(1,2)]
write.csv(dfdata, "/Users/luiscevallos/0_I_B/CC_CA.csv")
