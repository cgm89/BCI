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

ba.evi <- mt_subset(product = "MOD13Q1",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "250m_16_days_EVI", #if band not designated, all bands processed
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.EVI",
                    internal = TRUE)

head(ba.evi)
str(ba.evi)

ba.qcd <- mt_subset(product = "MOD13Q1",
                    lat = 9.156440,
                    lon = -79.848210,
                    band = "250m_16_days_pixel_reliability",     #pixel reliability ranks data versus VI Quality uses Bit Field
                    start = "2009-06-01",
                    end = "2019-06-01",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "BA.EVI",
                    internal = TRUE)
head(ba.qcd)
str(ba.qcd)



#ba.evi <- read.csv(file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_EVI.csv")

QCvalue <- ba.qcd$value
ba.evi$QCvalue <- QCvalue

#
#
ba.evi$qmvalue <- ba.evi$value#fill column with column "value"
ba.evi$qmvalue[ba.evi$QCvalue == -1 | ba.evi$QCvalue == 2 | ba.evi$QCvalue == 3] <- NA


svalue <- as.numeric(ba.evi$scale)*ba.evi$qmvalue
ba.evi$svalue <- svalue
ba.evi$svalue[ba.evi$svalue < 0] <- NA

write.csv(ba.evi, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_EVI.csv")
#write.csv(ba.evi, file = "C:/Users/cgmer/Documents/PROJECTS/BCI/CSVs/TERRA_EVI_FullData.csv")
