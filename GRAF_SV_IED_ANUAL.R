rm(list=ls()) #borrando todo
dir<-"/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE"
setwd(dir)
library("xts")
library("TTR")
library("zoo")
library("ggplot2")
library("tidyr")
library("dplyr")
library("ggrepel")
library("RColorBrewer")
library("gridExtra")
library("data.table")
PIB    <-read.csv("PIB_CA.csv", sep = ",")
BP     <-read.csv("SV_BP.csv", sep = ";")
PIB1  <- filter(PIB, date>= "2012-03-01")
PIB1  <- select(PIB1, SV)
BASE <- cbind(BP, PIB1) 
BASE$SV <- as.numeric(BASE$SV)
BASE$date <- as.Date(BASE$date)
ANUAL4<- function(VARIABLE){
  res = VARIABLE
  for(i in 4:length(VARIABLE)){
    res[i] = mean(VARIABLE[(i-3):i])*4
  }
  res
}
BASE <- mutate(BASE, IED=ANUAL4(IDA-IDP)*-1)
BASE <- mutate(BASE, OTRAS=ANUAL4(OIA-OIP)*-1)
BASE <- filter(BASE, date== "2012-12-01"| date== "2013-12-01"|date== "2014-12-01"|
                     date== "2015-12-01"| date== "2016-12-01"|date== "2017-12-01"|
                     date== "2018-12-01"| date== "2019-12-01"|date== "2020-12-01"|
                     date== "2021-12-01"| date== "2022-12-01")

setnames(BASE, old=c("IED", "OTRAS"),
         new=c("Inversión Extranjera Directa", "Préstamos y otras inversiones")
)
DATOS_LONG <- gather(BASE, key="measure", value="value",
                     c("Inversión Extranjera Directa", "Préstamos y otras inversiones")
)
DATOS_LONG$measure <- factor(DATOS_LONG$measure,
                             levels = c("Inversión Extranjera Directa", "Préstamos y otras inversiones")
)
paleta<-c("green", "blue")
Z<-ggplot(DATOS_LONG, aes(x=date, y=value, fill=measure))+
  geom_bar(stat='identity', position=position_dodge())+labs(y="", x="")+
  scale_fill_manual(values = paleta)+
  geom_hline(yintercept=0, color="black",size = 1.0, linetype = "dashed")
Z<-Z+labs(y="Millones de US dólares",
          caption = "Fuente: https://www.secmca.org/ESEA.html")

Z<-Z+theme_bw()+theme(axis.line.x = element_line(colour = "black", size = 0.5),
                      axis.line.y.left  = element_line(colour = "black", size = 0.5),
                      axis.line.y.right = element_blank(),
                      axis.text.x  = element_text( color = "black", size = 12),
                      axis.text.y  = element_text( color = "black", size = 12),
                      axis.title.x = element_blank(),
                      axis.title.y = element_text( color = "black", size = 14),
                      plot.caption = element_text(size=14),
                      legend.title = element_blank(),
                      legend.text  = element_text(size=14),
                      legend.position="bottom")+
  guides(color = guide_legend(nrow = 1), fill=guide_legend(nrow = 1))
min <- as.Date("2012-06-01")
max <- NA
Z<-Z+scale_x_date(date_breaks = "12 month", date_labels = "%Y",
                  limits = c(min, max))
ggsave(filename="/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/posts/welcome/IED_ANUAL_SV.jpg",
       plot = Z,
       #device = cairo_pdf,
       width = 297,
       height = 210,
       units = "mm")


