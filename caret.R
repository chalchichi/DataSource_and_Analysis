install.packages("caret")
install.packages("ggcorrplot")
library(ggcorrplot)
library(caret)
install.packages("caretEnsemble")
library(caretEnsemble)
install.packages("randomForest")
library(randomForest)
dat2=read.csv("last2.csv")
dat1=read.csv("data2.csv")
corr=round(cor(dat_tr[,20:34]),2)
x11()

ggcorrplot(corr, hc.order = TRUE, type = "lower",
           lab = TRUE)
corr
dat2=dat2[,-1]
dim(dat1)

dat1=dat1[,-(37:293)]

dat1
x=c()

for(i in 1:dim(dat2)[2]){
  if(class(dat2[,i])=="factor"){
      x[i]=i
  }
}
y=which(is.na(x))

x=x[-y]
dat2=dat2[,x]
str(dat2)
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


dat2=data.frame(apply(dat2,2,function(x) ifelse(is.na(x), "0", x)))
dat=data.frame(dat1,dat2)

rf=randomForest(x=dat[,-37],ntree = 2000,proximity = T)

importance(rf)
x2=c()
for(i in 1:length(importance(rf))){
  if(importance(rf)[i]<=2){
    x2[i]=i
    y2=which(is.na(x2))
    c2=x2[-y2]
  }
}
?train
dat=dat[,-c2]


dmy <- dummyVars(" ~ .", data = dat[,35:71])
dmy2 <- data.frame(predict(dmy, newdata = dat[,35:71]))
dat3=data.frame(dat[,1:34],dmy2)

x = nearZeroVar(dat3, saveMetrics = TRUE)
x
k=c()
for(i in 1:length(x$nzv)){
  if(x$nzv[i]){
    k[i]=i
  }
}
k2=which(is.na(k))
k=k[-k2]

dat3=dat3[-k]
dat_tr=dat3[1:1460,]
dat_te=dat3[1461:2919,]
control=trainControl(method = "boot", number = 5, returnResamp = "all",verboseIter = T)

xgbtree=train(SalePrice~., data=dat_tr, method="xgbTree", preProcess="scale", trControl=control, tuneLength=5)

lasso
xgbtree




stack=caretList(SalePrice~.,data=dat,trControl = control,methodList=c("glm", "lm"))









