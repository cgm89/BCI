#C:\Users\trina\Documents\Carli_Files\MODIS_Data

rm(list=ls())
gc()
dev.off()

library(MODISTools)
library(raster)
library(sp)
library(MODIS)
library(ggplot2)

# Terra: MOD15A2H 16 day 500m
bands <- mt_bands(product = "MOD15A2H")
head(bands)
str(bands)

dates <- mt_dates(product = "MOD15A2H", lat = 9.156440, lon = -79.848210)
head(dates)

ba.fpar <- mt_subset(product = "MOD15A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "Fpar_500m", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.FPAR",
                    internal = TRUE)

head(ba.fpar)
str(ba.fpar)

ba.qcd <- mt_subset(product = "MOD15A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "FparLai_QC", 
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.FPAR",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)

#ba.fpar <- read.csv(file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_FPAR.csv")

QCvalue <- ba.qcd$value
ba.fpar$QCvalue <- QCvalue

#
#
ba.fpar$qmvalue <- ba.fpar$value  #fill column with column "value"
ba.fpar$qmvalue[ba.fpar$QCvalue >= 32 &
                 ba.fpar$QCvalue <= 63] <- NA

#newdata <- mydata[ which(mydata$gender=='F' 
#                         & mydata$age > 65), ]

svalue <- as.numeric(ba.fpar$scale)*ba.fpar$qmvalue
ba.fpar$svalue <- svalue

write.csv(ba.fpar, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_FPAR.csv")
#write.csv(ba.fpar, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_FPAR_FullData.csv")
