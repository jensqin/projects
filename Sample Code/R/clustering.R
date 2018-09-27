load('all_data_num_train.RData')
library('mclust')
library(ggplot2)
library(gridExtra)
library(cluster)
library(dplyr)

idfull = which(rowSums(is.na(tromit))==0)

train = all_data.train
train[,-18]=scale(train[,-18])

scat1 = ggplot(train,aes(log(Salary)))+geom_freqpoly(aes(y=..density..))
scat2 = ggplot(train,aes(Salary))+geom_freqpoly(aes(y=..density..))
grid.arrange(scat1,scat2)

fmmcl = Mclust(train[,-18])
pairwise.t.test(log(train$Salary),fmmcl$classification,pool.sd = F)

library(ClusterR)
kmcl = KMeans_rcpp(train[,-18], 3, initializer = 'kmeans++')
pairwise.t.test(log(train$Salary),kmcl$clusters,pool.sd = T)

slr1 = train$Salary[kmcl$clusters==1]
slr2 = train$Salary[kmcl$clusters==2]
slr3 = train$Salary[kmcl$clusters==3]

fmmsil = silhouette(fmmcl$classification,dist(train[,-18]))
plot(fmmsil)
kmsil = silhouette(kmcl$clusters,dist(train[,-18]))
plot(kmsil)


clusplot(train[,-18], fmmcl$classification, color=TRUE, shade=TRUE, lines=0,main="")
clusplot(train[,-18], kmcl$clusters, color=TRUE, shade=TRUE,lines=0,main="")

library(fpc)
plotcluster(train[,-18], fmmcl$classification)
plotcluster(train[,-18], kmcl$clusters)

cluster.stats(dist(train[,-18]), fmmcl$classification,kmcl$clusters)

cluster.stats(dist(train[,-18]), fmmcl$classification)

data.frame(x=log(train$Salary),z=as.factor(kmcl$clusters))%>%
  ggplot(aes(x=x,color=z))+geom_density()

data.frame(x=log(train$Salary),z=as.factor(fmmcl$classification))%>%
  ggplot(aes(x=x,color=z))+geom_density(kernel='gaussian')

train = read.csv('train.csv',header = T)

library(RCurl)
library(rjson)
url<-'https://raw.githubusercontent.com/nhlscorebot/arenas/master/teams.json'
rawjson<-getURL(url)
locations<-fromJSON(rawjson)
arenas<-data.frame('team'=names(locations))
uloc<-unlist(locations)
arenas$name<-uloc[seq(1, length(uloc), by=3)]
arenas$lat<-uloc[seq(2, length(uloc), by=3)]
arenas$lng<-uloc[seq(3, length(uloc), by=3)]
arenas$lat<-as.numeric(arenas$lat)
arenas$lng<-as.numeric(arenas$lng)
arenas$label<-paste0(arenas$team, ' - ', arenas$name)

library(ggplot2)
library(maps)
#load us map data
all_states <- map_data("state")
#plot all states with ggplot
p <- ggplot() + 
  geom_polygon( data=all_states, aes(x=long, y=lat, group = group),colour="white", fill="grey10" )

p+ geom_point( data=arenas, aes(x=lng, y=lat, size = salary,color=G))+ 
  scale_size(name="Average Salary")+scale_color_discrete(name="Total Goal")+
  geom_text( data=arenas, hjust=0.5, vjust=-0.5, aes(x=lng, y=lat, label=team), colour="coral1", size=4 )

load("all_data.RData")

p = all_data%>%
  plot_ly(type="violin")%>%add_trace(x=~Cntry[all_data$Hand=='L'],
                                     y=~Salary[all_data$Hand=='L'],
                                     legendgroup='L',scalegroup='L',
                                     name='L',box = list(
                                       visible = T
                                     ),
                                     meanline = list(
                                       visible = T
                                     ),
                                     line = list(
                                       color = 'blue'
                                     ))%>%
  add_trace(x=~Cntry[all_data$Hand=='R'],
            y=~Salary[all_data$Hand=='R'],
            legendgroup='L',scalegroup='R',
            name='L',box = list(
              visible = T
            ),
            meanline = list(
              visible = T
            ),
            line = list(
              color = 'pink'
            ))%>%layout(yaxis = list(
              zeroline = F
            ),
            violinmode = 'group')

lfit1 = lm(log(Salary)~iFF+PS,data = all_data)
ptsgrid = seq(min(all_data$iFF),max(all_data$iFF),length.out =50)
toixgrid = seq(min(all_data$PS),max(all_data$PS),length.out = 50)
newdat = expand.grid(ptsgrid,toixgrid)
colnames(newdat)=c('iFF','PS')
pred1 = predict(lfit1,newdata=newdat,se.fit=T)

plot_ly(x=ptsgrid,y=toixgrid)%>%
  add_surface(z=matrix(pred1$fit,length(ptsgrid)),
              colorscale=list(c(0,1),c("red","blue")))

plot_ly(all_data,x=~iFF,y=~PS,z=~log(Salary))%>%add_markers()%>%
  add_surface(x=ptsgrid,y=toixgrid,z=matrix(pred1$fit,length(ptsgrid)),
              colorscale=list(c(0,1),c("red","blue")))

