library(randomForest)
library(dplyr)
library(rpart)
library(rpart.plot)
dat=read.csv("gamedata.csv")
tree <- rpart(score~., data=dat, cp=0.03)
# Visualize the decision tree with rpart.plot
rpart.plot(tree, box.palette="RdBu", shadow.col="gray", nn=TRUE)
r3hr=c()
for(i in 1:length(dat$score)){
  if(dat$r3[i]<3){
    r3hr[i]="high"
  }
  else{
    r3hr[i]="row"
  }
}
dat$hr=r3hr
sps <- ggplot(dat, aes(x = r2, y = score,color=hr)) + 
  geom_smooth()+geom_point()
sps
rf= randomForest(score~.
                      , data=dat, mtry = 4, ntree = 500, importance = T)

library(xgboost)

name=c("con1","con2","r1","h1","r2","h2","r3","h3")
ggplot(dat2, aes(x = IncNodePurity, y = reorder(name,IncNodePurity))) + geom_point(size = 3) + theme_bw() + 
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "grey60", linetype = "dashed"))
dat=read.csv("gamedata.csv")
xg=xgboost(data=as.matrix(dat[2:9]),label = dat$score,booster="gbtree",object="reg:linear",eval_metric="rmse",nround=500,eta=0.3)
w=which(dat$score==max(dat$score))
index=w[1]
ansmat=matrix(c(0,0,0,0,0,0,0,0,0),1,9)
for(i in c(-15:15)){
  ans=dat[index,][-1]
  m=as.matrix(ans)
  m[1,index2]=i
  for(j in c(-15:15)){
    m[1,index3]=j
    for(k in c(-15:15)){
      m[1,index4]=k
      pred.xg=predict(xg,m)
      temp=cbind(pred.xg,m)
      print(temp)
      ansmat=rbind(temp,ansmat)
    }
  }
}
split=tree$splits[1:3,]
t(split)
name2=names(as.data.frame(t(split)))
dic=data.frame(name)
dic$index=1:8
dic
index2=as.integer(dic[name==name2[1],][2])
index3=as.integer(dic[name==name2[2],][2])
index4=as.integer(dic[name==name2[3],][2])

which.max(ansmat[,1])                  
ansmat[19243,]
