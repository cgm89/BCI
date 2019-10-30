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
bands <- mt_bands(product = "MOD15A2H")
head(bands)
str(bands)

dates <- mt_dates(product = "MOD15A2H", lat = 9.156440, lon = -79.848210)
head(dates)

ba.lai <- mt_subset(product = "MOD15A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "Lai_500m", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.LAI",
                    internal = TRUE)

head(ba.lai)
str(ba.lai)

ba.qcd <- mt_subset(product = "MOD15A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "FparLai_QC", 
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.LAI",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)

#ba.lai <- read.csv(file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LAI.csv")

QCvalue <- ba.qcd$value
ba.lai$QCvalue <- QCvalue

#
#
ba.lai$qmvalue <- ba.lai$value  #fill column with column "value"
ba.lai$qmvalue[ba.lai$QCvalue >= 32 &
                 ba.lai$QCvalue <= 63] <- NA

#newdata <- mydata[ which(mydata$gender=='F' 
#                         & mydata$age > 65), ]

svalue <- as.numeric(ba.lai$scale)*ba.lai$qmvalue
ba.lai$svalue <- svalue

write.csv(ba.lai, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LAI.csv")
#write.csv(ba.lai, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_LAI_FullData.csv")
