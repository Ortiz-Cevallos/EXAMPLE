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
ORIGEN<-paste("https://www.secmca.org/chart/?parent=Balanza%20de%20pagos&scid=2&cid=7&scsid=0&son=Cuenta%20financiera&url=35/14-238/3-13-50-17-4-52-161/36/266-268/21/284-664-285-286-669-293-670-678-684-679-680-689-690-691/2018I-2018II-2018III-2018IV-2019I-2019II-2019III-2019IV-2020I-2020II-2020III-2020IV-2021I-2021II-2021III-2021IV-2022I-2022II-2022III-2022IV-&all_vars=1|Cuenta%20financiera*2|Inversi%C3%B3n%20directa%20neta*3|Inversi%C3%B3n%20directa:%20activos*4|Inversi%C3%B3n%20directa:%20pasivos*5|Inversi%C3%B3n%20de%20cartera%20neta*6|Derivados%20financieros:%20neto*7|Balance%20de%20otra%20inversi%C3%B3n*8|Cuenta%20financiera,%20acumulado*9|Inversi%C3%B3n%20directa%20neta,%20acumulado*10|Inversi%C3%B3n%20directa:%20activos,%20acumulado*11|Inversi%C3%B3n%20directa:%20pasivos,%20acumulado*12|Inversi%C3%B3n%20de%20cartera%20neta,%20acumulado*13|Derivados%20financieros:%20neto,%20acumulado*14|Balance%20de%20otra%20inversi%C3%B3n,%20acumulado#", sep="")
datahtml <- read_html(ORIGEN)
datahtml <- html_nodes(datahtml, "table")
datahtml <- html_table(datahtml, header = TRUE, fill = TRUE)[[1]]
write.csv(datahtml, "/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/CF.csv")



DATA<-read.csv("/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/CF.csv", sep = ",")
DATA<-filter(DATA, X>=6)
B<-c()
P<-c("CR", "SV", "GT", "HN","NI", "DO","PA") 
i<-3
for (L in 1:length(P)){
  for (k in 1:14){
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
write.csv(dfdata, "/Users/luiscevallos/0_I_B/CF_CA.csv")



