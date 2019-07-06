import pandas as pd
from IPython.display import display as dp
import numpy as np
import csv
import re
reg="[(]+[0-9]+\.[0-9]+s+[)]"
data=open('AcmAdapter-2018-04-09.log')
class logfilter:
    def __init__(self,fd):
        self.data=fd
        self.time=[]
        self.device=[]
        self.msg=[]
        self.cycle=[]
        self.breakpoint=0;
        self.colorder=["time","device","message","second"]
        self.second=[]
        self.cycle1=[1,2,5,8,11]
        self.cycle2=[3,6,9,12]
        self.cycle3=[4,7,10]
        self.check=0
    def parsing(self):
        try:
            for line in self.data:
                self.time.append(line[:12])
                self.breakpoint=1
                if(line[13]=="C"):
                    self.device.append("CmdServer")
                    self.breakpoint=2
                    temp=line[23:]
                    sec=re.search(reg,temp)
                    if sec==None:
                        self.second.append(None)
                    else:
                        self.second.append(float(re.search(reg,temp).group()[1:-2]))
                    self.msg.append(temp[:-1])
                    self.breakpoint=3
                else:
                    self.device.append("AcmAdapter")
                    self.breakpoint=2
                    temp=line[24:]
                    sec=re.search(reg,temp)
                    if sec==None:
                        self.second.append(None)
                    else:
                        self.second.append(float(re.search(reg,temp).group()[1:-2]))
                    self.msg.append(temp[:-1])
                    self.breakpoint=3
                self.cycle.append("NOT OK")
        except:
            if(self.breakpoint==1):
                self.time=self.time[:-1]
            elif(self.breakpoint==2):
                self.time=self.device.time[:-1]
                self.device=self.device[:-1]
        return
    def makedataframe(self):
        dic={"time":self.time, "device":self.device,"message":self.msg,"cycle":self.cycle,"second":self.second}
        df = pd.DataFrame(dic,columns=self.colorder)
        dp(df)
        df.to_csv("log.csv")


        
    def checkstart(self):
        self.colorder.append("cycle")
        for i in range(len(self.msg)-1):
            line=self.msg[i]
            if i<self.check:
                continue
            if line[len(line)-14:len(line)]=="START_NEW_SCAN":
                self.checkcycle(1,i)
    def checkcycle(self,num,offset):
        if num==13:
            for i in range(13):
                self.cycle[offset+i]="cycle ok"
            self.check=offset+num
            return
        line=self.msg[offset+num]
        if num in self.cycle1:
            if line[:13]=='SCAN complete':
                self.checkcycle(num+1,offset)
        elif num in self.cycle2:
            if line[:21]=='SCAN command complete':
                self.checkcycle(num+1,offset)
        elif num in self.cycle3:
            if line[:21]=='SCAN command received':
                self.checkcycle(num+1,offset)

a=logfilter(data)
a.parsing()
a.checkstart()
a.makedataframe()
