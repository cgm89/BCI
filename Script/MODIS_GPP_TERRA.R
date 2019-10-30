#C:\Users\trina\Documents\Carli_Files\MODIS_Data

rm(list=ls())
gc()
dev.off()

library(MODISTools)
library(raster)
library(sp)
library(MODIS)
library(ggplot2)

# Terra: MOD17A2H 8 day GPP 500m
bands <- mt_bands(product = "MOD17A2H")
head(bands)
str(bands)

dates <- mt_dates(product = "MOD17A2H", lat = 9.156440, lon = -79.848210)
head(dates)

ba.gpp <- mt_subset(product = "MOD17A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "Gpp_500m", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.GPP",
                    internal = TRUE)

head(ba.gpp)
str(ba.gpp)

ba.qcd <- mt_subset(product = "MOD17A2H",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "Psn_QC_500m", 
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.GPP",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)


#ba.gpp <- read.csv (file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_GPP.csv", header=TRUE, sep=",")

QCvalue <- ba.qcd$value
ba.gpp$QCvalue <- QCvalue

#
#
ba.gpp$qmvalue <- ba.gpp$value#fill column with column "value"
ba.gpp$qmvalue[ba.gpp$qmvalue >= 32761 & ba.gpp$qmvalue <= 32767] <- NA
ba.gpp$qmvalue[ba.gpp$QCvalue >= 64 & ba.gpp$QCvalue <= 95 | ba.gpp$QCvalue >= 192 & ba.gpp$QCvalue <= 223] <- NA

svalue <- ba.gpp$qmvalue/8
ba.gpp$svalue <- svalue

#write.csv(ba.gpp, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_GPP_FullData.csv")

write.csv(ba.gpp, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_GPP.csv")
