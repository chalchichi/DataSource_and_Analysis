
Sys.setenv("JAVA_HOME"="/usr/")
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}
install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-wheeler/4/R")


########################################################################################################

library(randomForest)
library(cluster)
require(h2o)


h2o.init(nthreads = -1, max_mem_size = "8g")

h2o.removeAll()
options(scipen=1000000)


##data handling

dat=read.csv("last2.csv",na.strings = "tttt")
dat=dat[1:1460,-1]

a=function(i){
  length(unique(i))
  }
x=c()

for(i in 1:dim(dat)[2]){
  if(a(dat[,i])<=20){
    x[i]=i
  }
}

y=which(is.na(x))
y
c=x[-y]
for(i in 1:length(c)){
dat[,c[i]]=as.factor(dat[,c[i]])
}
n1=c()
n2=c()
n3=c()
for(i in 1:length(y)){
  n1[i]=y[i]
  n2[i]=class(dat[,y[i]])
  n3[i]=a(dat[,y[i]])
}
cbind(n1,n2,n3)



##clustering

#delect variable by randomForest
rf=randomForest(x=dat[,-dim(dat)[2]],ntree = 2000,proximity = T)

importance(rf)
x2=c()
for(i in 1:length(importance(rf))){
  if(importance(rf)[i]<=1){
    x2[i]=i
    y2=which(is.na(x2))
    c2=x2[-y2]
  }
}

dat=dat[,-c2]
dim(dat)

#clustertig

dissmat=sqrt(1-rf$proximity)
set.seed(123)
pamRF=pam(dissmat,k=7)
table(pamRF$clustering)
s=data.frame(dat$SalePrice,pamRF$clustering)
s$pamRF.clustering=as.factor(s$pamRF.clustering)
boxplot(s$dat.SalePrice~s$pamRF.clustering)
dat=data.frame(dat,pamRF$clustering)
colnames(dat)[which(names(dat) == "pamRF.clustering")] <- "cluster"
dat$cluster=as.factor(dat$cluster)




train_sdat_h2o <- as.h2o(dat, "train_dat1")

target <- "SalePrice"
features <- names(dat_tr)[!names(train_sdat_h2o) %in% target]


##########################################################################################
#XG

xg_model <- h2o.xgboost(x = features, y = target, training_frame = train_sdat_h2o,
                        nfolds = 5,
                        model_id = "gbm_model",eta=0.01,ntrees=1000,max_depth = 10,
                        booster = "gblinear",distribution = "gaussian",categorical_encoding="OneHotExplicit",reg_alpha = 1)
xg_model
?h2o.xgboost
hyper_params=list(
    eta=c(0.0001,0.0003,0.0005),
    max_depth=c(5,6,7,8),
    gamma=c(0.5,0.25),
    reg_alpha=c(0.5,0.1,1.5),
    subsample=0.5,
    ntrees=c(3000,4000,5000)
    )

search_criteria=list(
  strategy="RandomDiscrete",
  max_runtime_secs=420,
  stopping_tolerance=0.0001
  )

train_sdat_h2o <- as.h2o(dat_tr, "train_dat1")
?h2o.grid()
randomSearch=h2o.grid(
  algorithm ="xgboost",
  grid_id="randomSearch",
  training_frame=train_sdat_h2o,
  x=features,
  y=target,
  categorical_encoding = "OneHotInternal",
  hyper_params=hyper_params,
  search_criteria=search_criteria
)
options(digits=10)
grid=h2o.getGrid("randomSearch",sort_by = "RMSLE",decreasing = F)
grid



##########################################################################################
#Deep learning
hyper_params=list(
  hidden=list(c(500,500,500),c(100,100),c(1000,1000)),
  epochs=c(50,60)
  )

search_criteria=list(
  strategy="RandomDiscrete",
  max_runtime_secs=520,
  max_models=200,
  seed=123,
  stopping_metric="rmsle",
  stopping_rounds=10,
  stopping_tolerance=0.0001
)

randomSearch=h2o.grid(
  algorithm ="deeplearning",
  grid_id="randomSearch",
  training_frame=train_sdat_h2o,
  x=features,
  y=target,
  categorical_encoding = "OneHotInternal",
  hyper_params=hyper_params,
  search_criteria=search_criteria
  )

grid=h2o.getGrid("randomSearch",sort_by = "RMSLE",decreasing = F)
grid

deep <- h2o.deeplearning(x=features,
                          y=target, 
                          model_id = "deep",
                          loss = "Absolute",
                          hidden =c(1000,1000),
                          epochs=50,
                          training_frame=train_sdat_h2o,
                          input_dropout_ratio = 0.00,
                          rate=0.005,
                          activation = "Maxout",
                          categorical_encoding = "OneHotInternal",
                          mini_batch_size = 10,
                          nfolds = 5
                          )

deep


#######################################################################################
#total data modeling
  dat=read.csv("last2.csv",na.strings = "tttt")
  dat=dat[,-1]
  
  a=function(i){
    length(unique(i))
  }
  x=c()
  
  for(i in 1:dim(dat)[2]){
    if(a(dat[,i])<=20){
      x[i]=i
    }
  }
  
  y=which(is.na(x))
  y
  c=x[-y]
  for(i in 1:length(c)){
    dat[,c[i]]=as.factor(dat[,c[i]])
  }
  n1=c()
  n2=c()
  n3=c()
  for(i in 1:length(y)){
    n1[i]=y[i]
    n2[i]=class(dat[,y[i]])
    n3[i]=a(dat[,y[i]])
  }
  cbind(n1,n2,n3)
  dat=dat[,-c2]
  
  dat_tr <- dat[1:1460,]
  dat_te <- dat[1461:2919,]
  
  
  train_sdat_h2o <- as.h2o(dat_tr, "train_dat1")
  test_sdat_h2o <- as.h2o(dat_te, "test_dat2")
  
  
  target <- "SalePrice"
  features <- names(dat_tr)[!names(train_sdat_h2o) %in% target]
  
  deep <- h2o.deeplearning(x=features,
                           y=target, 
                           model_id = "deep",
                           input_dropout_ratio = 0.05,
                           adaptive_rate = T,
                           hidden =c(30,30,30),
                           epochs=50,
                           fold_assignment = "Stratified",
                           nfolds = 5,
                           training_frame=train_sdat_h2o,
                           activation = "Maxout",
                           categorical_encoding = "OneHotInternal",
                           mini_batch_size = 30
                          )
  deep
  
  
  best_model=h2o.getModel(grid@model_ids[[1]])
  pred.deep <- as.data.frame(h2o.predict(deep, newdata = test_sdat_h2o))
  
  
  a=cbind(1461:2919,pred.deep)
  a
  colnames(a)=c("ID","SalePrice")
  
  write.csv(a,"ans.csv",row.names = FALSE)
