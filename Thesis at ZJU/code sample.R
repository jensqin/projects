library(Rcpp)
library(RSNNS)
daf<-read.table(file.choose(),header=T)
dat<-data.frame(daf)
gene<-dat[,1]
dat<-dat[,-1]
rownames(dat)<-gene
cancer<-read.table(file.choose(),header=T)
cf<-cancer==0
tt<-rowttests(dat,factor(cf))
dat<-dat[tt<0.005,]
dfv<-t(dat)
dft<-decodeClassLabels(cancer$status)
df<-splitForTrainingAndTest(dfv, dft, ratio=0.15)
df<-normTrainingAndTestSet(df)
model<-mlp(df$inputsTrain,df$targetsTrain,size=5,learnFunc="Quickprop",learnFuncParams=c(0.1, 0.1, 0.1, 0.1),maxit=500,inputsTest=df$inputsTest,targetsTest=df$targetsTest)
summary(model)
predictions<-predict(model,df$inputsTest)
confusionMatrix(df$targetsTest,predictions)
