#C:\Users\trina\Documents\Carli_Files\MODIS_Data

rm(list=ls())
gc()
dev.off()

library(MODISTools)
library(raster)
library(sp)
library(MODIS)
library(ggplot2)

# Terra: MOD13Q1 16 day 250m
bands <- mt_bands(product = "MOD13Q1")
head(bands)
str(bands)

dates <- mt_dates(product = "MOD13Q1", lat = 9.156440, lon = -79.848210)
head(dates)

ba.ndvi <- mt_subset(product = "MOD13Q1",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "250m_16_days_NDVI", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.NDVI",
                    internal = TRUE)

head(ba.ndvi)
str(ba.ndvi)

ba.qcd <- mt_subset(product = "MOD13Q1",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "250m_16_days_pixel_reliability",     #pixel reliability ranks data versus VI Quality uses Bit Field
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.NDVI",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)

#ba.ndvi <- read.csv(file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_NDVI.csv")

QCvalue <- ba.qcd$value
ba.ndvi$QCvalue <- QCvalue

#
#
ba.ndvi$qmvalue <- ba.ndvi$value#fill column with column "value"
ba.ndvi$qmvalue[ba.ndvi$QCvalue == -1 | ba.ndvi$QCvalue == 2 | ba.ndvi$QCvalue == 3 | ba.ndvi$QCvalue == 0] <- NA
ba.ndvi$svalue[ba.ndvi$svalue < 0] <- NA


svalue <- as.numeric(ba.ndvi$scale)*ba.ndvi$qmvalue
ba.ndvi$svalue <- svalue
ba.ndvi$svalue[ba.ndvi$svalue < 0] <- NA

write.csv(ba.ndvi, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_NDVI.csv")
#write.csv(ba.ndvi, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_NDVI_FullData.csv")
