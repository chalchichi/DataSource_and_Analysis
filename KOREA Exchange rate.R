dat=read.csv("date.csv")
dat=dat[1:232,]
as.POSIXct(dat$date, format = "%Y-%m-%d")
apply(dat[,2:7],2,as.numeric)
apply(dat,2,length)



##################변동차이###########################################
KID=c()
UID=c()
YD=c()
for(i in 1:length(dat$KORinterest)-1){
  KID[i]=dat$KORinterest[i+1]-dat$KORinterest[i]
}

for(i in 1:length(dat$KORinterest)-1){
  UID[i]=dat$USAinterest[i+1]-dat$USAinterest[i]
}

for(i in 1:length(dat$KORinterest)-1){
  YD[i]=dat$Y[i+1]-dat$Y[i]
}

#각 조건 판단후 입력
p=c()
for(i in 1:length(YD)){
  if(KID[i]==0){
    if(UID[i]>=0){p[i]="USA UP KOR 0"}
    else{p[i]="USA down KOR 0"}
  }
  else if(KID[i]>0){
    if(UID[i]>=0){p[i]="USA UP KOR UP"}
    else{p[i]="USA down KOR UP"}
  }
  else{
    if(UID[i]>=0){p[i]="USA UP KOR down"}
    else{p[i]="USA down KOR down"}
  }
}

dateD=dat$date[2:232]

dat2=data.frame(dateD,YD,p)
x11()
barplot(tapply(dat2$YD,dat2$p,mean))
ggplot(data=dat2,aes(YD,p))+geom_point(aes(YD))+ geom_text(data=dat2,aes(label = dateD), size = 4)
length(dat2$)
#그래프
plot(dat$KORinterest~dat$date,type="l")
par(new=TRUE)
plot(dat$USAinterest~dat$date,col="blue")
p <- ggplot() +
  geom_point(data=dat, aes(x=date, y=KORinterest)) + geom_point(data=dat, aes(x=date, y=USAinterest),col="red") 
x11()
p
