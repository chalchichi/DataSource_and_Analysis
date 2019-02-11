#package
install.packages("randomForest")
library(randomForest)
install.packages("ggplot2")
library(ggplot2)

#data input
l=list()
name=read.table("name.txt",header=F,stringsAsFactors = F)
for(i in 1:length(name[,1])){
  path=paste0(name[i,1],"/",name[i,1],"_price.txt")
  dat=read.table(path,header=TRUE)
  dat=dat[-1]
  dat=dat[length(dat[,1]):1,]
  l[[i]]=dat
}
#mean,var,range
for(i in 1:length(name$V1)){
  print(mean(l[[i]]$CLOSE))
}
#time series
time=data.frame()
exep=c()
for(i in 1:length(name$V1)){
  m=max(l[[i]]$CLOSE)
  if(m>=15||m<1.5){
    exep=c(exep,i)
  }}
exepted=setdiff((1:length(name$V1)),exep)

for(i in exepted){
  coin=rep(name$V1[i],length(l[[i]]$CLOSE))
  index=1:length(l[[i]]$CLOSE)
  close=l[[i]]$CLOSE
  time2=data.frame(coin,index,close)
  time=rbind(time,time2)
  }
ggplot(data = time, aes(x =index , y = close, group = coin, colour = coin)) +
  geom_line() +
  facet_wrap(~ coin)


#length
len=c()
for(i in 1:length(name[,1])){
  len=c(len,length(l[[i]]$CLOSE))
}

len2=data.frame(name$V1,len)


ggplot(len2, aes(name.V1, len,fill = name.V1))+geom_bar(stat="identity")

#correlation
corr=c()
for(i in 1:(length(name$V1)-1)){
  l1=length(l[[1]]$OPEN)
  l2=length(l[[i+1]]$OPEN)
  n=min(l1,l2)
  corr=c(corr,cor(
    l[[1]]$CLOSE[l1:(l1-n+1)],
    l[[i+1]]$CLOSE[l2:(l2-n+1)]
  )
  )
}
coin=name$V1[2:length(name$V1)]
corr=data.frame(corr,coin)
ggplot(corr, aes(coin, corr,fill = coin))+geom_bar(stat="identity")

#make close price dataFrame by minimum length
len=c()
for(i in (1:length(name$V1))){
  len=c(len,length(l[[i]]$CLOSE))
}
minimum_length=min(len)
minimum_length
close=rep(0,minimum_length)
for(i in (1:length(name$V1))){
  l3=length(l[[i]]$CLOSE)
  a=l[[i]]$OPEN[l3:(l3-minimum_length+1)]
  close=cbind(close,a)
}
close=close[,-1]
close=as.data.frame(close)
colnames(close)=name$V1

#randomForset
#mtry=sqrt(28)
rf=randomForest(AE~.,data=close,mtry=6)
varImpPlot(rf)

#a=The name of the bit coin
#a는 문자열로 입력""
#most폴더에 가장 관련도 높은 10개의 데이터와 대상 비트코인를 most폴더에저장

setwd("C:/Users/inha/Desktop/most")
findcol=function(a){
  a_index=which(name$V1==a)
  im=rf$importance  
  im=append(im,0,after=a_index-1)
  most_index=head(order(im,decreasing=TRUE),10)
  nn=c()
  for(i in 1:10){
    write.csv(l[[most_index[i]]],paste0(name$V1[most_index[i]],".csv"))
    write.csv(l[[a_index]],paste0(a,".csv"))
    nn=c(nn,name$V1[most_index[i]])
    write.csv(nn,"most_name.csv")
  }
}


#example 
findcol("AE")


#vs corelation
rf$importance
cl=c()
for(i in 2:29){
  cl=c(cl,cor(close[,1],close[,i]))
}

c1=head(order(cl,decreasing=TRUE),10)
c2=head(order(rf$importance,decreasing=TRUE),10)
for(i in c2){
  print(name$V1[i+1])
}
l[[1]]$CLOSE[length(l[[1]]$CLOSE)]
