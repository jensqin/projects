#SURVMETH 687 Project1: Mixed-effects Model
#Zhen Qin, Chen Chen
#Fall 2018

#---------------------------------------------------------------------

#load libraries and datasets
library(lme4)
library(ggplot2)
library(lmerTest)
library(mice)
library(dplyr)
orgnl_dat=read.csv(file.choose())
summary(orgnl_dat)

#classroom and teacher are one-to-one
partdat=orgnl_dat[,c(6,7,9,10,11)]
partdat%>%group_by(schoolid)%>%
  summarise(n_class=n_distinct(classid),
            n_teacher=n_distinct(mathprep,mathknow,yearstea))
any(partdat$n_class!=partdat$n_teacher)

#multiple imputation
im_dat=mice(orgnl_dat[c(6,7,9)])
dat=orgnl_dat
dat[c(6,7,9)]=complete(im_dat)
dim(dat)

#---------------------------------------------------------------------

#exploratory data analysis
dat$sex=factor(dat$sex)
dat$minority=factor(dat$minority)
dat$classid=factor(dat$classid)
dat$schoolid=factor(dat$schoolid)
dat$childid=factor(dat$childid)

#descriptive statistics
summary(dat)
length(unique(dat$classid))
length(unique(dat$schoolid))
datcor=cor(dat[,3:9])
max(datcor[datcor<1])

#visualization
plot(dat[c(3,4,5)],main='Scatter Plots For Students')
plot(dat[c(6,7,9)],main='Scatter Plots For Teachers')
g1=ggplot(dat,aes(mathkind,mathgain))+geom_smooth()+
  ggtitle('mathgain vs mathkind')
g2=ggplot(dat,aes(minority,mathgain))+geom_boxplot()+
  ggtitle('boxplot of mathgain by minority')
g3=ggplot(dat,aes(sex,mathgain))+geom_boxplot()+
  ggtitle('boxplot of mathgain by sex')

#---------------------------------------------------------------------

#modeling
#backward stepwise modeling
f1=lmer(mathgain~sex+minority+yearstea+mathknow+mathkind+mathprep+ses+
          (yearstea|classid:schoolid)+(housepov|schoolid),REML=T,
        data=dat)
step(f1)
#Model found: mathgain~minority+mathkind+ses+(1|classid:schoolid)
# + (1 | schoolid)
f2=lmer(mathgain~ minority + mathkind + ses + (1|classid:schoolid)
         + (1 | schoolid),REML=T,data=dat)
summary(f2)
anova(f2)
ranova(f2)
#AIC(f2)
#BIC(f2)

#visualization diagnostics
#residual plot
plot(f2)
#QQ plot
re=ranef(f2)
qqnorm(t(re$classid))
qqline(t(re$classid))
qqnorm(resid(f2))
qqline(resid(f2))

#---------------------------------------------------------------------

#advanced research
#degenerate model
