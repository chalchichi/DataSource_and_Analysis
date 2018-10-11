#your wedding
summary(dat$Y)
summary(dat$screen)

dat=read.csv("spy.csv")
plot(dat$Y,main="spy",ylab="Y")


x=c()
for(i in 1:2){
  x[i]=cor(dat$Y,dat[,i+1])
}
x
max(x)

plot(dat[,2:4])
plot(dat$screen,ylab="screen")
plot(dat$seat,ylab="seat")
plot(dat$Y,ylab="Y")

y1=lm(dat$screen[17:23]~dat$date[17:23])
y2=lm(dat$seat[6:23]~dat$date[6:23])
plot(dat$screen)




#spy
plot(dat[,2:4])
dat=read.csv("spy.csv")
plot(dat$screen,ylab="screen")
plot(dat$seat,ylab="seat")
plot(dat$Y,ylab="Y")
k=c(mean(dat$screen[1:7]),mean(dat$screen[8:14]),mean(dat$screen[15:21]),mean(dat$screen[22:23]))
y=lm(k~c(1:4))
pred.screen=predict(y,data.frame(c(4:6)))
dat$screen
pred.screen
summary(dat$screen)
summary(dat$Y)

for(i in 1:2){
  x[i]=cor(dat$Y,dat[,i+1])
}
x
max(x)

#monster
plot(k)
l1=lm(k[1:10]~c(1:10))
l2=lm(k[11:18]~c(11:18))

result=c()
for(i in 1:10){
  result[i]=l1$coefficients[1]+l1$coefficients[2]*i+(78960-51034)
}
for(i in 11:19){
  result[i]=l2$coefficients[1]+l2$coefficients[2]*i+(78960-51034)
}
sum(result)

