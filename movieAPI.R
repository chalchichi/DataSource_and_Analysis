install.packages("XML")
library(XML)
URLencode(iconv("",to="UTF-8"))




name=c()
aud=c()
screen=c()
lst=list()

for(date in c(20160901:20160918)){
url=paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=6c419aee64b99161834e1438c878e091&targetDt=",date)
raw.data <- xmlTreeParse(url, useInternalNodes = TRUE, encoding = "utf-8")
rootNode <- xmlRoot(raw.data)

  for(i in 1:10){
  name[i]=xmlValue(rootNode[[3]][[i]][["movieNm"]])
  aud[i]=xmlValue(rootNode[[3]][[i]][["audiCnt"]])
  screen[i]=xmlValue(rootNode[[3]][[i]][["scrnCnt"]])
  }
lst[[date-20160900]]=data.frame(rep(date,10),name,aud,screen)
}
install.packages("data.table")
library(data.table)
dat=rbindlist(lst)
write.csv(dat,file="1month.csv")

#regression
k=c()
data=read.csv("1month.csv")
for(i in 1:18){
  k[i]=sum(data[10*i-9:10*i,4])
}

