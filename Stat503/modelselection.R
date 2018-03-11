# load data and remove rows with missing value
train=read.csv('train.csv', header = T)
train=na.omit(train)
test=read.csv('test.csv',header = T)

train.num=train[,-c(2:6,11:16)]
train.cat=train[,c(2:6,11:16)]
train.cat=train.cat[,c(4,7)]
train.cat$Hand=droplevels(train.cat$Hand)
train.cat$Cntry = mapvalues(train.cat$Cntry,from=levels
                            (train.cat$Cntry)[-c(2,18)],to=rep('OTH',16))

# lasso: 66
cvlmod=cv.lars(as.matrix(train.num)[,-1], as.matrix(train.num)[,1])
cvlmod$index[which.min(cvlmod$cv)]
predlars=predict(lmod,s=0.01010101,type="coef",mode="fraction")$coef
predlars=predlars[predlars!=0]
# BIC selection: 18
linreg=lm(Salary~.,train.num)
linBIC=step(linreg,k=log(nrow(train.num)))
train.num=linBIC$model

