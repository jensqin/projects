load('threedata.RData')
load('3dat2clas.RData')

library(ggplot2)
library(reshape2)
library(e1071)
library(dmm)
library(class) 
library(caret)
library(plyr)
library(RSSL)

rf_data_test$salary=as.factor(rf_data_test$salary)

knnerr = function(tr,te){
  trControl <- trainControl(method  = "cv",
                            number  = 5)
  cknn <- caret::train(salary ~ .,
                method     = "knn",
                tuneGrid   = expand.grid(k = 15:25),
                trControl  = trControl,
                metric     = "Accuracy",
                data       = tr)
  bk = cknn$results$k[which.max(cknn$results$Accuracy)]
  cverr = cknn$results[,1:2]
  trcl = knn(train = tr, cl = tr$salary, 
              test = tr, k = bk)
  trerr=mean(trcl!=tr$salary)
  tecl = knn(train = tr, cl = tr$salary, 
             test = te, k = bk)
  teerr=mean(tecl!=te$salary)
  return(list(cverr,trerr,teerr))
}

svmerr=function(tr,te){
  trControl <- trainControl(method  = "cv",
                            number  = 5)
  cvsvm <- caret::train(salary ~ .,
                 method     = "svmRadialCost",
                 tuneGrid   = expand.grid(C = seq(1,20,2)/10),
                 trControl  = trControl,
                 metric     = "Accuracy",
                 data       = tr)
  csvm=tune.svm(salary~.,data=tr,kernel='radial',cost=seq(1,20,2)/10)
  tsvm=svm(salary~.,data=tr,kernel='radial',cost=csvm$best.parameters$cost)
  trerr = mean(predict(tsvm,tr)!=tr$salary)
  teerr=mean(predict(tsvm,te)!=te$salary)
  cverr=cvsvm$results[,1:2]
  return(list(cverr,trerr,teerr))
}

nnerr=function(tr,te){
  trControl <- trainControl(method  = "cv",
                            number  = 5)
  cvnn <- caret::train(salary ~ .,
                 method     = "mlpML",
                 tuneGrid   = expand.grid(layer1=3:7,layer2=3:7,layer3=3:7),
                 trControl  = trControl,
                 metric     = "Accuracy",
                 data       = tr)
  cverr=cvnn$results[,1:4]
  trerr=mean(predict(cvnn,tr)!=tr$salary)
  teerr=mean(predict(cvnn,te)!=te$salary)
  return(list(cverr,trerr,teerr))
}

bsterr=function(tr,te){
  trControl <- trainControl(method  = "cv",
                            number  = 5)
  cvbst <- caret::train(salary ~ .,
                method     = "AdaBoost.M1",
                tuneGrid   = expand.grid(mfinal = (1:3)*3, maxdepth = 1:3,
                                         coeflearn = c("Breiman", "Freund", "Zhu")),
                trControl  = trControl,
                metric     = "Accuracy",
                data       = tr)
  cverr=cvbst$results[,1:2]
  trerr=mean(predict(cvbst,tr)!=tr$salary)
  teerr=mean(predict(cvbst,te)!=te$salary)
  return(list(cverr,trerr,teerr))
}

tr=list(pca_data_train,bic_data_train,rf_data_train)
te=list(pca_data_test,bic_data_test,rf_data_test)
err=list()
for(i in 1:3){
  err[[i]]=list(knnerr(tr[[i]],te[[i]]),svmerr(tr[[i]],te[[i]]),nnerr(tr[[i]],te[[i]]))
}

load('3dat2clas.RData')
tr=list(pca_data_train,bic_data_train,rf_data_train)
te=list(pca_data_test,bic_data_test,rf_data_test)
err2clas=list()
for(i in 1:3){
  err2clas[[i]]=list(knnerr(tr[[i]],te[[i]]),svmerr(tr[[i]],te[[i]]),nnerr(tr[[i]],te[[i]]))
}

# reg
load('3datareg.RData')

tr_Sa=list(pca_train,bic_train,rf_train)
te_Sa=list(pca_test,bic_test,rf_test)
lr = list()
library(xgboost)
tr_Sa_bst=lapply(tr_Sa,function(x){xgb.DMatrix(data=as.matrix(x[,-ncol(x)]),label=log(x$Salary))})
te_Sa_bst=lapply(te_Sa,function(x){xgb.DMatrix(data=as.matrix(x[,-ncol(x)]),label=log(x$Salary))})

xgbst=list()

lr = lapply(tr_Sa,function(x){lm(log(Salary)~.,data = x)})

for(i in 1:3){
  xgbst[[i]] = xgb.train(data=tr_Sa_bst[[i]],max.depth = 3:7, eta = (1:3)/10, 
                         nthread = 8, nround = 1000,
                         watchlist = list(tr=tr_Sa_bst[[i]],te=te_Sa_bst[[i]]), objective = "reg:linear", 
                         early_stopping_rounds = 50)
}

lrrmse=data.frame(tr.rmse=rep(NA,3),te.rmse=rep(NA,3))
xgbrmse=data.frame(tr.rmse=rep(NA,3),te.rmse=rep(NA,3))
for(i in 1:3){
  lrrmse[i,1]=sqrt(mean(lr[[i]]$residuals^2))
  lrrmse[i,2]=sqrt(mean((predict(lr[[i]],te_Sa[[i]])-log(te_Sa[[i]]$Salary))^2))
  xgbrmse[i,]=xgbst[[i]]$evaluation_log[xgbst[[i]]$best_iteration,2:3]
}
lrrmse
xgbrmse

grf=GRFClassifier(X=as.matrix(pca_data_train[,-18]),pca_data_train$salary,as.matrix(pca_data_test[,-18]))
mean(predict(grf)!=pca_data_test$salary)
grf=GRFClassifier(X=as.matrix(bic_data_train[,-18]),bic_data_train$salary,as.matrix(bic_data_test[,-18]))
mean(predict(grf)!=bic_data_test$salary)
grf=GRFClassifier(X=as.matrix(rf_data_train[,-18]),rf_data_train$salary,as.matrix(rf_data_test[,-18]))
mean(predict(grf)!=rf_data_test$salary)

x <- lr[[1]]$model$Comp.1
y <- lr[[1]]$model$Comp.2
z <- lr[[1]]$model$`log(Salary)`
# Compute the linear regression (z = ax + by + d)
fit <- lm(z ~ x + y)
# predict values on regular xy grid
grid.lines = 26
x.pred <- seq(min(x), max(x), length.out = grid.lines)
y.pred <- seq(min(y), max(y), length.out = grid.lines)
xy <- expand.grid( x = x.pred, y = y.pred)
z.pred <- matrix(predict(fit, newdata = xy), 
                 nrow = grid.lines, ncol = grid.lines)
# fitted points for droplines to surface
fitpoints <- predict(fit)
# scatter plot with regression plane
scatter3D(x, y, z, pch = 18, cex = 1, 
          theta = 20, phi = 20, ticktype = "detailed",
          xlab = "PC1", ylab = "PC2", zlab = "log(Salary)",  
          surf = list(x = x.pred, y = y.pred, z = z.pred,  
                      facets = NA, fit = fitpoints), main = "Regression Plane")

data.frame(name=testname$Last.Name[c(1:6,206)],true=log(rf_test$Salary)[c(1:6,206)],fit=predint[c(1:6,206),1],
           lwr=predint[c(1:6,206),2],upr=predint[c(1:6,206),3])%>%
  ggplot(aes(name,fit,ymin=lwr,ymax=upr))+geom_errorbar()+geom_point(aes(name,true))+ylab("condifence interval")
