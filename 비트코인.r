#package
install.packages("randomForest")
library(randomForest)

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
close

#randomForset
#mtry=sqrt(28)
rf=randomForest(AE~.,data=close,mtry=6)


#a=The name of the bit coin
#a는 문자열로 입력""
#most폴더에 가장 관련도 높은 10개의 데이터와 대상 비트코인를 most폴더에저장

setwd("C:/Users/inha/Desktop/most")
findcol=function(a){
          a_index=which(name$V1==a)
          im=rf$importance  
          im=append(im,0,after=a_index-1)
          most_index=head(order(im,decreasing=TRUE),10)
          for(i in 1:10){
            write.csv(l[[most_index[i]]],paste0(name$V1[most_index[i]],".csv"))
            write.csv(l[[a_index]],paste0(a,".csv"))
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
head(order(cl,decreasing=TRUE),10)
head(order(rf$importance,decreasing=TRUE),10)
