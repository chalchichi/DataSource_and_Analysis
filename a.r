name=read.table("name.txt",header=F,stringsAsFactors = F)
for(i in 1:length(name[,1])){
path=paste0(name[i,1],"/",name[i,1],"_price.txt")
dat=read.table(path)
dat=dat[-1]
dat=dat[length(dat[,1]):1,]
l[[i]]=dat
}
cor(l[[1]]$OPEN,l[[2]]$OPEN)


for(i in 1:(length(name$V1)-1)){
  l1=length(l[[i]]$OPEN)
  l2=length(l[[i+1]]$OPEN)
  n=min(l1,l2)
  print(cor(
    l[[i]]$OPEN[l1:(l1-n+1)],
    l[[i+1]]$OPEN[l2:(l2-n+1)]
  )
  )
}
length(name$V1)

l2
cor(l[[1]]$OPEN[(398:398-252+1)],l[[2]]$OPEN[252:1])
length(l[[3]]$OPEN)
length(l[[4]]$OPEN)

l[[3]]$OPEN[51:(51-51+1)]
l[[4]]$OPEN[63:(63-51+1)]
l[[4]]$OPEN
