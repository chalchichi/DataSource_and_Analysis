dat=read.csv("project - data.csv")

dat1=read.csv("project - data1.csv")

## partitioning dataset ]

 

set.seed(1)

 

idx <- sample(x = 1:nrow(dat), 

              

              size = floor(nrow(dat) * 0.1), 

              

              replace = F)

 

dat_tr <- dat[-idx,]; str(dat_tr);

dat_tr1 <- dat1[-idx,]; str(dat_tr);

dat_te <- dat[+idx,]; str(dat_te);

dat_te1 <- dat1[+idx,]; str(dat_tr);

 

#logit.reg

f.lg <- glm(y ~., data =dat_tr1, family = "binomial")

f.lg

p=predict(f.lg, newdata = dat_te,type = "response")

round(p)

#tree

install.packages("tree")

library(tree) 

f.rt <- tree(y ~ ., 

             data = dat_tr)

pred.rt <- predict(f.rt, newdata = dat_te)

 

 

#bagging

install.packages("randomForest")

set.seed(1)

 

library(randomForest)

 

f.bg <- randomForest(y ~ .,

                     

                     data = dat_tr,

                     

                     mtry = 22, 

                     ntree=500,

                     

                     importance =TRUE)

 

pred.bg <- predict(f.bg, newdata = dat_te)

 

#randomforest

f.rf <- randomForest(y ~ .,

                     

                     data = dat_tr,

                     

                     mtry = 7, 

                     ntree=500,

                     

                     importance =TRUE)

 

pred.rf <- predict(f.rf, newdata = dat_te)

 

 

#predition

pred.rt <- predict(f.rt, newdata = dat_te, type = "class")

pred.bg <- predict(f.bg, newdata = dat_te, type = "response")

pred.rf <- predict(f.rf, newdata = dat_te, type = "response")

str(pred.rf)

str(pred.bg)

 

 

#table

lapply(list(rt = pred.rt, 

            bg = pred.bg, 

            rf = pred.rf), 

       function(pred) {

         table(dat_te$y, pred)

       })

table(round(p),dat_te1$y)

 

 

#number of right pred

lapply(list(rt = pred.rt, 

            bg = pred.bg, 

            rf = pred.rf), 

       function(pred) {

         table(dat_te$y, pred)[1,1]+ table(dat_te$y, pred)[2,2]

       })

table(round(p),dat_te1$y)[1,1]+table(round(p),dat_te1$y)[2,2]
