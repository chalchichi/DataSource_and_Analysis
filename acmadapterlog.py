from tkinter import *
from tkinter import ttk
import pandas as pd
from IPython.display import display as dp
import numpy as np
import re
from tkinter import filedialog



reg = "[(]+[0-9]+\.[0-9]+s+[)]"


class logfilter:
    def __init__(self):
        self.time = []
        self.device = []
        self.msg = []
        self.cycle = []
        self.breakpoint = 0
        self.colorder = ["time", "device", "message", "second"]
        self.second = []
        self.cycle1 = [1, 2, 5, 8, 11]
        self.cycle2 = [3, 6, 9, 12]
        self.cycle3 = [4, 7, 10]
        self.check = 0
        self.tis = []  # sec가 존재하는 행
        window = Tk()
        window.title("Log Filter")
        window.geometry("640x400+100+100")
        window.resizable(False, False)
        button1 = Button(window, text="Select log", overrelief="solid", width=15, command=self.filesearch,
                                 repeatdelay=1000, repeatinterval=100)

        button2 = Button(window, text="Filtering log", overrelief="solid", width=15, command=self.run,
                                 repeatdelay=1000, repeatinterval=100)
        button3 = Button(window, text="Save log", overrelief="solid", width=15, command=self.makedataframe,
                                 repeatdelay=1000, repeatinterval=100)
        self.ch_var = StringVar()
        chk = Checkbutton(window, text='Save logs with seconds', variable=self.ch_var, onvalue='Y',
                          offvalue='N')
        chk.pack()
        button1.pack()
        button2.pack()
        window.mainloop()

    def filesearch(self):
        filename = filedialog.askdirectory()
        self.data = open(filename)
    def parsing(self):
        i = 0
        try:
            for line in self.data:
                self.time.append(line[:12])
                self.breakpoint = 1
                if (line[13] == "C"):
                    self.device.append("CmdServer")
                    self.breakpoint = 2
                    temp = line[23:]
                    sec = re.search(reg, temp)
                    if sec == None:
                        self.second.append(None)
                    else:
                        self.second.append(float(re.search(reg, temp).group()[1:-2]))
                        self.tis.append(i)
                    self.msg.append(temp[:-1])
                    self.breakpoint = 3
                else:
                    self.device.append("AcmAdapter")
                    self.breakpoint = 2
                    temp = line[24:]
                    sec = re.search(reg, temp)
                    if sec == None:
                        self.second.append(None)
                    else:
                        self.second.append(float(re.search(reg, temp).group()[1:-2]))
                        self.tis.append(i)
                    self.msg.append(temp[:-1])
                    self.breakpoint = 3
                self.cycle.append("NOT OK")
                i += 1
        except:
            if (self.breakpoint == 1):
                self.time = self.time[:-1]
            elif (self.breakpoint == 2):
                self.time = self.device.time[:-1]
                self.device = self.device[:-1]
        return

    def makedataframe(self):
        dic = {"time": self.time, "device": self.device, "message": self.msg, "cycle": self.cycle,
               "second": self.second}
        df = pd.DataFrame(dic, columns=self.colorder)
        df2 = df.iloc[self.tis,]
        c=self.ch_var.get()
        if c=="Y":
            df.to_csv("log.csv", index=None)
            df2.to_csv("log_sec_exist.csv", index=None)
        else:
            df.to_csv("log.csv", index=None)
    def checkstart(self):
        self.colorder.append("cycle")
        for i in range(len(self.msg) - 1):
            line = self.msg[i]
            if i < self.check:
                continue
            if line[len(line) - 14:len(line)] == "START_NEW_SCAN":
                self.checkcycle(1, i)

    def checkcycle(self, num, offset):
        if num == 13:
            for i in range(13):
                self.cycle[offset + i] = "cycle ok"
            self.check = offset + num
            return
        line = self.msg[offset + num]
        if num in self.cycle1:
            if line[:13] == 'SCAN complete':
                self.checkcycle(num + 1, offset)
        elif num in self.cycle2:
            if line[:21] == 'SCAN command complete':
                self.checkcycle(num + 1, offset)
        elif num in self.cycle3:
            if line[:21] == 'SCAN command received':
                self.checkcycle(num + 1, offset)
    def run(self):
        self.parsing()
        self.checkstart()


logfilter()

