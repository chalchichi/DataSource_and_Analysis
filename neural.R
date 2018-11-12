#data
orgin=read.csv("mnist_train.csv",head=F)
#weight
b=matrix(rnorm(100*784,0,10^-0.5),100,784)
c=matrix(rnorm(10*100,0,10^-0.5),10,100)
#input,output
input=orgin[,-1]*0.001
ans=matrix(rep(0.01,10*length(input[,1])),10,length(input[,1]))
for(i in 1:60000){
  ans[orgin[,1][i]+1,i]=0.99
}
input[1+10(i-1):10i,]

#training
for (i in 1:6000){
    oj=1/(1+exp(-(b%*%t(input[(10*(i)-9):(10*(i)),]))))
    ok=1/(1+exp(-(c%*%oj)))
    e1=ans[,(1+10*(i-1)):(10*(i))]-ok
    e2=t(c)%*%e1
    cw=(0.01*(e1)*(ok)*(1-ok))%*%t(b%*%t(input[(1+10*(i-1)):(10*(i)),]))
    c=c+cw
    bw=(0.01*(e2)*(oj)*(1-oj))%*%as.matrix(input[(1+10*(i-1)):(10*(i)),])
    b=b+bw
  print(i)
}

#query
x=c()
for(i in 1:100){
a=input[i,]
oj=1/(1+exp(-(b%*%t(a))))
ok=1/(1+exp(-(c%*%oj)))
if((which.max(ok)-1)==orgin[,1][i]){
  x[i]="yes"
  } else x[i]="no"
}
kk=function(i){
k1=as.numeric(orgin[i,-1])
k=matrix(k1,28,28)
k=as.matrix(k)
x <- 10*(1:nrow(k))
y <- 10*(1:ncol(k))
image(x,y,k,axes = FALSE)
legend(x=220,y=250,c(orgin[i,1]),cex=3)
}
kk(11)
kk(103)
kk(400)
kk(500)
kk(1004)
kk(102)
kk(108)

#test
y=c()

testdat=read.csv("mnist_test_10.csv",head=F)
test=testdat[,-1]
for(i in 1:10){
  a=test[i,]
  oj=1/(1+exp(-(b%*%t(a))))
  ok=1/(1+exp(-(c%*%oj)))
  if((which.max(ok)-1)==testdat[,1][i]){
    y[i]="yes"
  } else y[i]="no"
}

