Sys.setenv("JAVA_HOME"="/usr/")
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}
install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-wheeler/4/R")
require(h2o)
h2o.init(nthreads = -1, max_mem_size = "8g")

h2o.removeAll()


dat=read.csv("last2.csv",na.strings = "tttt")
dat=dat[1:1460,-1]
dat$MSSubClass=as.factor(dat$MSSubClass)
dat$TotalBsmtSF=as.numeric(dat$TotalBsmtSF)
dat$GarageArea=as.numeric(dat$GarageArea)
dat$MasVnrArea=as.numeric(dat$MasVnrArea)
dat$BsmtFinSF1=as.numeric(dat$BsmtFinSF1)
dat$BsmtFinSF2=as.numeric(dat$BsmtFinSF2)
dat$BsmtUnfSF=as.numeric(dat$BsmtUnfSF)
dat$YrSold=as.factor(dat$YrSold)
dat$MoSold=as.factor(dat$MoSold)
dat$GarageYrBlt=as.factor(dat$GarageYrBlt)

idx <- sample(x = 1:nrow(dat), 
              size = floor(nrow(dat) * 0.1), 
              replace = F)

dat_tr <- dat[-idx,]
dat_te <- dat[+idx,]


train_sdat_h2o <- as.h2o(dat_tr, "train_dat1")
test_sdat_h2o <- as.h2o(dat_te, "test_dat2")

target <- "SalePrice"
features <- names(dat_tr)[!names(train_sdat_h2o) %in% target]


##########################################################################################
#XG
x=c(rep(0,80))
y=matrix(x,20,4)
for(i in 1:20){
idx <- sample(x = 1:nrow(dat), 
              size = floor(nrow(dat) * 0.1), 
              replace = F)
dat_tr <- dat[-idx,]
dat_te <- dat[+idx,]

train_sdat_h2o <- as.h2o(dat_tr, "train_dat1")
test_sdat_h2o <- as.h2o(dat_te, "test_dat2")

xg_model <- h2o.xgboost(x = features, y = target, training_frame = train_sdat_h2o, 
                        model_id = "gbm_model",learn_rate = 0.02,eta=0.02,ntrees=1500,
                        booster = "gblinear",distribution = "gaussian",categorical_encoding="OneHotExplicit",reg_alpha = 250000)

pred.xg <- as.data.frame(h2o.predict(xg_model, newdata = test_sdat_h2o))
sqrt(mean((log(dat_te$SalePrice+1)-log(pred.xg+1))^2))
}

y
y=cbind(y,abs(y[,2]-y[,3]))
plot(y[,1]~y[,6])
x11()
y
plot(dat_te$SalePrice,ylim=c(0,800000),type="l")
par(new=T)
plot(pred.xg$predict,ylim=c(0,800000),col="red",type="l")
max(dat_te$SalePrice)

##########################################################################################
#Deep learning

deep <- h2o.deeplearning(x=features,
                          y=target, 
                          model_id = "deep",
                          loss = "Absolute",
                          hidden = c(1459,500,500,1459),
                          training_frame=train_sdat_h2o,
                          activation = "MaxoutWithDropout",
                          categorical_encoding = "OneHotInternal"
                          )

pred.xg <- as.data.frame(h2o.predict(deep, newdata = test_sdat_h2o))

write.csv(pred.deep,"ans11.csv")


sqrt(mean((log(dat_te$SalePrice+1)-log(pred.deep+1))^2))

dat=read.csv("ans11.csv")
dat$predict
write.csv(2.7182818284^dat$predict,"ans13.csv")

#######################################################################################
#total data modeling
dat=read.csv("last2.csv",na.strings = "tttt")
dat=dat[,-1]
dat$MSSubClass=as.factor(dat$MSSubClass)
dat$TotalBsmtSF=as.numeric(dat$TotalBsmtSF)
dat$GarageArea=as.numeric(dat$GarageArea)
dat$MasVnrArea=as.numeric(dat$MasVnrArea)
dat$BsmtFinSF1=as.numeric(dat$BsmtFinSF1)
dat$BsmtFinSF2=as.numeric(dat$BsmtFinSF2)
dat$BsmtUnfSF=as.numeric(dat$BsmtUnfSF)
dat$YrSold=as.factor(dat$YrSold)
dat$MoSold=as.factor(dat$MoSold)
dat_tr <- dat[1:1460,]
dat_te <- dat[1461:2919,]


train_sdat_h2o <- as.h2o(dat_tr, "train_dat1")
test_sdat_h2o <- as.h2o(dat_te, "test_dat2")


target <- "SalePrice"
features <- names(dat_tr)[!names(train_sdat_h2o) %in% target]

xg_model <- h2o.xgboost(x = features, y = target, training_frame = train_sdat_h2o, 
                        model_id = "gbm_model",learn_rate = 0.02,eta=0.02,ntrees=3000,
                        booster = "gblinear",distribution = "gaussian",categorical_encoding="OneHotInternal",reg_alpha = 1,max_depth = 10)
pred.xg <- as.data.frame(h2o.predict(xg_model, newdata = test_sdat_h2o))
pred.xg
a=cbind(1461:2919,pred.xg)
a
colnames(a)=c("ID","SalePrice")

write.csv(a,"ans.csv",row.names = FALSE)
