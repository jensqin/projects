
library(mgcv)
library(doParallel)

setwd("/home/qinzhen/R")
load('ps4_q4.RData')

xvalidate = function(folds, cores){
  load('ps4_q4.RData')
  ## Randomly shuffle the data
  n = nrow(sample_data)
  rands = sample_data[sample(n),]
  
  ## Create equally size folds
  kfolds = cut(seq(1, n),breaks=folds,labels=FALSE)
  
  # Perform k fold cross validation
  ymse = function(k){
    testIndexes <- which(kfolds==k,arr.ind=TRUE)
    testData <- sample_data[testIndexes, ]
    trainData <- sample_data[-testIndexes, ]
    
    ## fit the model
    fit=mgcv::gam(y~x,data=trainData,family=binomial(link=logit))
    ypred = predict(fit,newdata = testData)
    return(mean((ypred-testData$y)^2))
  }
  
  ## check if computing in parallel is needed
  if(cores%%1 == 0 & cores > 1){
    cl = makeCluster(cores)
    registerDoParallel(cl)
    
    #Perform k fold cross validation in parallel
    results = foreach(case = 1:folds) %dopar% {
      ## do with case #
      ymse(case)
    }
    stopCluster(cl)
  }else if(cores == 1){
    results = list()
    
    #Perform k fold cross validation locally
    for(case in 1:folds){
      results[case]=ymse(case)
    }
  }else{
    return(0)
  }
  return(results)
}

# test the function
mean(unlist(xvalidate(10000,8)))