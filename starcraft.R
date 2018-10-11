#data

#1st=2,2nd=1

#총전적이 50%를 넘는 선수만

name=c("임요환","이윤열","최연성","이영호","서지훈","정명훈","변형태","이재호","염보성","신상문")

v=c("total","terran","protoss","zerg","star","msl","team","prize")

x1=c(55.1,52.1,46,64.5,62.9,55.6,44.7,10)

x2=c(60.3,59.0,58,63.4,59.2,57.1,53.8,16)

x3=c(62.3,58.3,63.0,67.4,59,61.8,64.8,10)

x4=c(71.3,72.2,69.2,72.3,64.8,67.6,74,14)

x5=c(55.6,56.8,52.4,56.6,56,47.8,53.4,3)

x6=c(62.7,63.9,65.9,58.9,67.3,47.2,61.8,6)

x7=c(53.7,56.4,52.1,52.9,54.7,48.1,52.8,1)

x8=c(55.5,52.8,44.1,68.1,42.6,50,56.2,0)

x9=c(58.9,61.2,56.5,59.2,48,41.3,61,0)

x10=c(58.8,61.5,50.5,62.6,48.6,46.2,61.2,0)

x=rbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10)

rownames(x)=name

colnames(x)=v

x

 

#PCA

scdata<-scale(x)

 

V<-cor(scdata)

 

PCres<-eigen(V)

 

PCres$vectors[,1:3]

 

PCres$values[1:8]

 

cumsum(PCres$values)[1:4]/sum(PCres$values)

#3번째 lamda까지 넣어주면 95%이상 설명

 

 

plot(PCres$values)

 

 

plot(cumsum(PCres$values)/sum(PCres$values))

 

#score

score1<-scdata%*%PCres$vectors[,1]

 

plot(score1)
