library(MCMCpack)
ratio=c(728,584,138)
ratio=ratio/sum(ratio)
votes=rdirichlet(1000,ratio)
mean(votes[,1]>votes[,2])
mean(votes[,1]-votes[,2])
