install.packages('rvest')

 

library(rvest)

 

basic_url <- "https://www.ygosu.com/reports/?m2=person&m3=stats_star&page=1&idx="

 

url<-NULL

data=matrix(,94,8)

j

for(j in 1:8 ){

for(i in 5:98){

  

  url[i-4]=paste0(basic_url,i)

  

  stats <- read_html(url[i-4])

  

  infos <- html_nodes(stats, css='.det')

  

  head(infos)

  

  per=infos %>% html_text()

  

  data[i-4,j]=per[j]

}

#이르

names=c()

}

for(i in 5:98){

  

  url[i-4]=paste0(basic_url,i)

  

  stats <- read_html(url[i-4])

  

  name= html_nodes(stats, css='.info')

  if(length(substr(name %>% html_text(),5,7))==0){

    names[i]=0

  }else{

  names[i-4]=substr(name %>% html_text(),5,7)

  }

}

dim(data)

rownames(data)=names

data  

per

sub=c("all","terran","protoss","zerg","2011","star","msl","pro")

colnames(data)=sub



