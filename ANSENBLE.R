dat=read.csv("dat_hw (1).csv")

 

 

## partitioning dataset ]

 

set.seed(1)

 

idx <- sample(x = 1:nrow(dat), 

              

              size = floor(nrow(dat) * 0.1), 

              

              replace = F)

 

dat_tr <- dat[-idx,]

 

dat_te <- dat[+idx,]

 

#randomForest

 

set.seed(1)

 

 

 

f.bg <- randomForest(Y ~ .,

                     

                     data = dat_tr,

                     

                     mtry = 10,  # using all predictors = bagging

                     

                     ntree=300,

                     

                     importance =TRUE)

 

pred.bg <- predict(f.bg, newdata = dat_te)

sqrt(mean((dat_te$Y - pred.bg)^2))

#bagging

set.seed(1)

library(randomForest)

f.bg <- randomForest(Y ~ .,

                     data = dat_tr,

                     mtry = 22,  # using all predictors = bagging

                     ntree=500,

                     importance =TRUE)

pred.bg <- predict(f.bg, newdata = dat_te)

pred.bg

sqrt(mean((dat_te$Y - pred.bg)^2))

dat$date[699]

dat$date[730]

write.csv(pred.bg,"f.csv")

