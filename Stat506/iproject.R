# Individual Project Code
# Datasets are from https://catalog.data.gov/dataset?organization_type=City+Government&page=1.
# This file uses R, dplyr and spatstat package.
# Author: Zhen Qin
# Date: 12/12/2017
#-----------------------------------------------------------------------------------------------------

# 1
# For each traffic beacon category, generate a plot including traffic beacons and traffic cameras. 
# Which type of beacons have similar pattern with cameras?

#setwd("E:/UM academy/stat 506/project")

# load packages
library(readr)
library(dplyr)
library(spatstat)
library(ggplot2)

# load data
camera=read_delim('./Seattle_Traffic_Cameras.csv', delim=',',col_names=TRUE)
beacon=read_delim('./Traffic_Beacons__arcgis_rest_services_SDOT_EXT_DSG_datasharing_MapServer_33_.csv',
                  delim=',',col_names=TRUE)

# filter the beacons data
beacon=select(beacon,CATEGORY,SHAPE_LNG,SHAPE_LAT) %>%
  filter(CATEGORY!=" ",SHAPE_LNG>-125)

# generate contour plot
ggplot(data=beacon,aes(x=SHAPE_LNG,y=SHAPE_LAT))+geom_point()+stat_density2d()+facet_wrap(~CATEGORY)+
  ggtitle("Scatter Plots")

# compute k-means centers
ctg=unique(beacon$CATEGORY)
be_kms=list()
set.seed(100)
for(i in ctg[1:4]){
  ki=filter(beacon,CATEGORY==i) %>%
    select(SHAPE_LNG,SHAPE_LAT)
  be_kms[[i]]=kmeans(ki,4)$centers
}
ca_kms=kmeans(cbind(camera$XPOS,camera$YPOS),4)

# generate 3d density plot
myp=ppp(beacon$SHAPE_LNG,beacon$SHAPE_LAT,range(beacon$SHAPE_LNG),range(beacon$SHAPE_LAT))
summary(myp)
beacon_density=density(myp)
persp(beacon_density)

# generate plot of centers
kms=do.call(rbind,be_kms)
kms=rbind(kms,ca_kms$centers)
ctg[5]="Camera"
cate=rep(ctg,each=4)
kms=cbind(kms,Category=cate)
kms=as.data.frame(kms)
kms$SHAPE_LNG=as.numeric(kms$SHAPE_LNG)
kms$SHAPE_LAT=as.numeric(kms$SHAPE_LAT)
ggplot(data=as.data.frame(kms),aes(x=SHAPE_LNG,y=SHAPE_LAT))+geom_point()+facet_wrap(~Category)

# 2.1
# Question: Repeat question 1 using spatial analysis. Which area has average yearly largest increasing 
# of flow counts? You can use cluster to get areas.

# load the packages
library(readr)
library(dplyr)
library(spatstat)
library(ggplot2)

# repeat question 1 using spatstat
camera=cbind(CATEGORY=rep("Camera",length(camera$XPOS)),SHAPE_LNG=camera$XPOS,SHAPE_LAT=camera$YPOS)
beca=rbind(beacon,camera)
beca=as.data.frame(beca)
beca$SHAPE_LNG=as.numeric(beca$SHAPE_LNG)
beca$SHAPE_LAT=as.numeric(beca$SHAPE_LAT)
Be_Ca=ppp(beca$SHAPE_LNG,beca$SHAPE_LAT,range(beca$SHAPE_LNG),range(beca$SHAPE_LAT))
marks(Be_Ca)=factor(beca$CATEGORY)
par(mfrow=c(2,2))
plot(Kcross(Be_Ca,i="Camera",j="BCN-REG"))
plot(Kcross(Be_Ca,i="Camera",j="BCN-SCHL"))
plot(Kcross(Be_Ca,i="Camera",j="BCN-WARNG"))
plot(Kcross(Be_Ca,i="Camera",j="BCN-XWK"))

# load tables from 2008-2011
t08=read_delim('./2008_Traffic_Flow_Counts__arcgis_rest_services_SDOT_EXT_DSG_datasharing_MapServer_75_.csv',
               delim=',',col_names=TRUE)
t09=read_delim('./2009_Traffic_Flow_Counts__arcgis_rest_services_SDOT_EXT_DSG_datasharing_MapServer_74_.csv', 
               delim=',',col_names=TRUE)
t10=read_delim('./2010_Traffic_Flow_Counts__arcgis_rest_services_SDOT_EXT_DSG_datasharing_MapServer_73_.csv', 
               delim=',',col_names=TRUE)
t11=read_delim('./2011_Traffic_Flow_Counts__arcgis_rest_services_SDOT_EXT_DSG_datasharing_MapServer_72_.csv', 
               delim=',',col_names=TRUE)

# combine all keys
key08=t08$COMPKEY
key09=t09$COMPKEY
key10=t10$COMPKEY
key11=t11$COMPKEY
key=intersect(key08,key09) %>%
  intersect(key10) %>%
  intersect(key11)
t08=filter(t08,COMPKEY %in% key) %>%
  group_by(COMPKEY) %>%
  filter(row_number()==1) %>%
  arrange(COMPKEY)
t09=filter(t09,COMPKEY %in% key) %>%
  group_by(COMPKEY) %>%
  filter(row_number()==1) %>%
  arrange(COMPKEY)
t10=filter(t10,COMPKEY %in% key) %>%
  group_by(COMPKEY) %>%
  filter(row_number()==1) %>%
  arrange(COMPKEY)
t11=filter(t11,COMPKEY %in% key) %>%
  group_by(COMPKEY) %>%
  filter(row_number()==1) %>%
  arrange(COMPKEY)

# change the format
LAT=c()
LNG=c()
for(i in 1:length(t08$Shape)){
  shape = unlist(strsplit(t08$Shape[i],split = "[,() ]"))
  LAT[i] = as.double(shape[2])
  LNG[i] = as.double(shape[4])
}
LAT = as.numeric(LAT)
LNG = as.numeric(LNG)

# compute average yearly increasing rate
t.all=data.frame(LNG,LAT,keys=t08$COMPKEY,t08$AAWDT,t09$AAWDT,t10$AAWDT,t11$AAWDT)
t.all=mutate(t.all,r1=t09.AAWDT/t08.AAWDT,r2=t10.AAWDT/t09.AAWDT,r3=t11.AAWDT/t10.AAWDT) %>%
  mutate(avg=(r1+r2+r3)/3) %>%
  select(LNG,LAT,keys,avg)

# compute distance between centers and flow count points
centers=ca_kms$centers
t.all=mutate(t.all, dist1=(LNG-centers[1,1])^2+(LAT-centers[1,2])^2) %>%
  mutate(dist2=(LNG-centers[2,1])^2+(LAT-centers[2,2])^2) %>%
  mutate(dist3=(LNG-centers[3,1])^2+(LAT-centers[3,2])^2) %>%
  mutate(dist4=(LNG-centers[4,1])^2+(LAT-centers[4,2])^2) %>%
  group_by(keys) %>%
  mutate(dmin=min(dist1,dist2,dist3,dist4))

# compute average yearly increasing rate for each group
avg.all=mutate(t.all,group = case_when(dist1 == dmin~ 1,dmin==dist2~ 2,dmin==dist3~ 3,dmin==dist4~ 4)) %>%
  group_by(group) %>%
  summarise(mean_avg=mean(avg)) %>%
  arrange(mean_avg)

#-----------------------------------------------------------------------------------------------------