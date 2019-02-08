#package
install.packages("randomForest")
library(randomForest)

#data input
name=read.table("name.txt",header=F,stringsAsFactors = F)
for(i in 1:length(name[,1])){
path=paste0(name[i,1],"/",name[i,1],"_price.txt")
dat=read.table(path)
dat=dat[-1]
dat=dat[length(dat[,1]):1,]
l[[i]]=dat
}

#correlation
for(i in 1:(length(name$V1)-1)){
  l1=length(l[[i]]$OPEN)
  l2=length(l[[i+1]]$OPEN)
  n=min(l1,l2)
  print(cor(
    l[[i]]$CLOSE[l1:(l1-n+1)],
    l[[i+1]]$CLOSE[l2:(l2-n+1)]
  )
  )
}

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



rf=randomForest(SNT~.,data=close,mtry=6)
x11()
varImpPlot(rf)
