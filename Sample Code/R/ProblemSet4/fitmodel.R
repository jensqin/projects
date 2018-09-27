
library(mgcv)
library(doParallel)

setwd("./")
load('ps4_q4.RData')

fit=gam(y~x,data=sample_data)
pred=predict(fit)

ncores = 2
cl = makeCluster(ncores)
registerDoParallel(cl)
xvalidate=function(folds){
  id=sample(1:10000,10000/folds)
  te=sample_data[id,]
  boolid=rep(T,10000)
  boolid[id]=F
  tr=sample_data[boolid,]
  fit=mgcv::gam(y~x,data=tr)
  pred=predict(fit,newdata = te)
  mse=mean((pred-te$y)^2)
  return(mse)
}
results = foreach(case=3:10) %dopar% {
  ## what do do with case ? #
  xvalidate(case)
}

## Always shut the cluster down when done
stopCluster(cl)
results