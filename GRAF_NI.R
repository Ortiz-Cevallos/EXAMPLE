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
PIB    <-read.csv("PIB_CA.csv", sep = ",")
BP     <-read.csv("NI_BP.csv", sep = ";")
PIB1  <- filter(PIB, date>= "2015-03-01")
PIB1  <- select(PIB1, NI)
BASE <- cbind(BP, PIB1) 
BASE$SV <- as.numeric(BASE$NI)
BASE$date <- as.Date(BASE$date)
ANUAL4<- function(VARIABLE){
  res = VARIABLE
  for(i in 4:length(VARIABLE)){
    res[i] = mean(VARIABLE[(i-3):i])*4
  }
  res
}
BASE <- mutate(BASE, COL=rep("Acumulación de reservas",nrow(BASE)))
BASE <- mutate(BASE, EO2=EO+CK)
BASE <- mutate(BASE, FDIXL2=((IDA-IDP)/ANUAL4(SV))*-100)
BASE <- mutate(BASE, RESERVES2=((ACR)/ANUAL4(SV))*100)
BASE <- mutate(BASE, OTRAL2=((OIA-OIP)/ANUAL4(SV))*-100)
BASE <- mutate(BASE, PORTAFOLIOL2=((ICA-ICP)/ANUAL4(SV))*-100)
BASE <- mutate(BASE, EO3L=((EO2)/ANUAL4(SV))*100)
BASE <- mutate(BASE, CC2=((CC)/ANUAL4(SV))*100)
BASE <- mutate(BASE,COMPROBAR=CC-(IDA-IDP)-(ICA-ICP)-(OIA-OIP)+EO2-ACR)
BASE <- filter(BASE, date>= "2018-03-01")

setnames(BASE, old=c("FDIXL2", "RESERVES2", "OTRAL2", "PORTAFOLIOL2",
                     "EO3L", "CC2"),
         new=c("Inversión Extranjera Directa", "Acumulación de Reservas", "Préstamos y otras inversiones","Inversión en Cartera","E y O y Cuenta de Capital", "Cuenta Corriente")
)
DATOS_LONG <- gather(BASE, key="measure", value="value",
                     c("Inversión Extranjera Directa", "Préstamos y otras inversiones",
                       "Inversión en Cartera","Cuenta Corriente",
                       "E y O y Cuenta de Capital")
)
DATOS_LONG$measure <- factor(DATOS_LONG$measure,
                             levels = c("Inversión Extranjera Directa",
                                        "Préstamos y otras inversiones",
                                        "Inversión en Cartera",
                                        "E y O y Cuenta de Capital",
                                        "Cuenta Corriente")
)
paleta<-brewer.pal(n = 5, name = "Pastel2")
Z<-ggplot(DATOS_LONG, aes(x=date, y=value, fill=measure))+
  geom_bar(stat='identity')+labs(y="", x="")+
  scale_fill_manual(values = paleta)+
  geom_line(aes(x=date,y=`Acumulación de Reservas`, colour=COL), size=1.5)+
  scale_color_manual(values="black", labels("Acumulación de reservas"))+
  geom_hline(yintercept=0, color="black",size = 1.0, linetype = "dashed")
Z<-Z+labs(y="Porcentaje del PIB",
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
  guides(color = guide_legend(nrow = 2), fill=guide_legend(nrow = 2))
min <- as.Date("2017-12-20")
max <- NA
Z<-Z+scale_x_date(date_breaks = "6 month", date_labels = "%b-%y",
                  limits = c(min, max))#+
#scale_y_continuous(breaks = round(seq(-6,
#                                     6, by = 3),0))
ggsave(filename="/Users/luiscevallos/Documents/BLOG_QUARTO/EXAMPLE/posts/welcome/CC_CF_NI.jpg",
       plot = Z,
       #device = cairo_pdf,
       width = 297,
       height = 210,
       units = "mm")


