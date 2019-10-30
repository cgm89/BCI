#C:\Users\trina\Documents\Carli_Files\MODIS_Data

rm(list=ls())
gc()
dev.off()

library(MODISTools)
library(raster)
library(sp)
library(MODIS)
library(ggplot2)

# Terra: MOD15A2H 16 day 250m
bands <- mt_bands(product = "MOD11A2")
head(bands)
str(bands)

dates <- mt_dates(product = "MOD11A2", lat = 9.156440, lon = -79.848210)
head(dates)

ba.lst <- mt_subset(product = "MOD11A2",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "LST_Day_1km", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.LST",
                    internal = TRUE)

head(ba.lst)
str(ba.lst)

ba.qcd <- mt_subset(product = "MOD11A2",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "QC_Day", 
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.LST",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)

#ba.lst <- read.csv(file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LST.csv")

QCvalue <- ba.qcd$value
ba.lst$QCvalue <- QCvalue

#For BCI: QC integer 2 means No Pixel/Clouds; QC integer 65 means LST error < 3 Kelvin
#LST QM value 0 means missing data
ba.lst$qmvalue <- ba.lst$value#fill column with column "value"
ba.lst$qmvalue[ba.lst$qmvalue == 0] <- NA
ba.lst$qmvalue[ba.lst$QCvalue == 2] <- NA
                                       
                                       # ba.lst$QCvalue != 5 |
                                       # ba.lst$QCvalue != 17 |
                                       # ba.lst$QCvalue != 21]<- NA

#ba.gpp$svalue[ba.gpp$svalue == 0]<- NA

#newdata <- mydata[ which(mydata$gender=='F' 
#                         & mydata$age > 65), ]

svalue <- as.numeric(ba.lst$scale)*ba.lst$qmvalue
ba.lst$svalue <- svalue

write.csv(ba.lst, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LST.csv")
#write.csv(ba.lst, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LST_FullData.csv")
