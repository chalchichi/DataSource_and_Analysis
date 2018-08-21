#data
orgin=read.csv("100.csv",head=F)
#weight
b=matrix(rnorm(100*784,0,10^-0.5),100,784)
c=matrix(rnorm(10*100,0,10^-0.5),10,100)
#input,output
input=orgin[,-1]*0.001

ans=matrix(rep(0.01,1000),10,100)
for(i in 1:100){
  ans[orgin[,1][i]+1,i]=0.99
}

#training
for (i in 1:10000){
    oj=1/(1+exp(-(b%*%t(input))))
    ok=1/(1+exp(-(c%*%oj)))
    e1=ans-ok
    e2=t(c)%*%e1
    cw=(0.01*(e1)*(ok)*(1-ok))%*%t(b%*%t(input))
    c=c+cw
    bw=(0.01*(e2)*(oj)*(1-oj))%*%as.matrix(input)
    b=b+bw
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

table(x)

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

