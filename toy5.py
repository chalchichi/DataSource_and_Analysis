import pygame as pg
from pygame.sprite import Sprite
from pygame.color import Color
import random
import sys
import pandas as pd
white=(255,255,255)
black=(0,0,0)
pg.init()
size=[512,512]
pg.display.set_mode(size)
screen=pg.display.set_mode(size)
done=False
clock=pg.time.Clock()
font=pg.font.SysFont("comicsansms",72)
class circle(Sprite):
	def __init__(self,color,dx,dy,row,high):
		self.x=dx
		self.y=dy
		self.color=(color)
		Sprite.__init__(self)	
		self.image = pg.Surface((8,8))
		self.image.fill(self.color)
		self.rect = self.image.get_rect()
		self.rect.center = (self.x,self.y)
		self.image.set_colorkey(Color(255,0,24))
		self.row=row
		self.high=high
	def draw(self, screen):
	  	 screen.blit(self.image, self.rect) 
	def move(self):
		a=random.randrange(self.row,self.high)
		b=random.randrange(self.row,self.high)
		if self.rect.x+a>=502: 
			self.rect.x-=20
		elif self.rect.x+a<20:
			self.rect.x+=30
		if self.rect.y+b>=502:
			self.rect.y-=20
		elif self.rect.y<20:
			self.rect.y+=30
		self.rect.x+=a
		self.rect.y+=b
g1=pg.sprite.Group()
g2=pg.sprite.Group()
i=0
dx1=100
dy1=100
dx2=400
dy2=400
bcolor=(0,100,255)
t=0
rcolor=(255,0,255)
def find(n):
	rl=[]
	rl2=[]
	for i1 in range(n):
		a=random.randrange(0,255)
		rl.append(a)
	for i1 in range((n+1)*2):
		a=random.randrange(-15,15)
		rl2.append(a)
	rl.sort(reverse=True)
	for i in range(n+1):
		if rl2[2*i]>rl2[2*i+1]:
			rl2[2*i],rl2[2*i+1]=rl2[2*i+1],rl2[2*i]
		elif rl2[2*i]==rl2[2*i+1]:
			rl2[2*i+1]+=1
	return rl,rl2
n=2
cri,randl=find(n)
num1=0
index=0
nn=["score"]
for i in range(n):
	nn.append("cri"+str(i))
colname=tuple(nn)
for i in range(n+1):
	rn="row"+str(i)
	hn="high"+str(i)
	colname+=(rn,hn)
df=pd.DataFrame(columns=colname)
num1=0
while not done:
	clock.tick(1000)
	for event in pg.event.get():
		if event.type == pg.QUIT:
			done=True
	screen.fill(white)
	pg.draw.ellipse(screen,(0,100,255),[dx1,dy1,65,65],1)
	pg.draw.ellipse(screen,(255,0,255),[dx2,dy2,65,65],1)
	if num1%30==0:
		br=random.randrange(-255,0)
		color=(bcolor[0],bcolor[1],bcolor[2]+br)
		rr=random.randrange(-255,0)
		color2=(255,0,rcolor[2]+rr)
		randcol=color[2]
		if randcol>=cri[0]:
			row=randl[0]
			high=randl[1]
		elif randcol<cri[n-1]:
			row=randl[2*n]
			high=randl[2*n+1]
		else:
			for j in range(1,n-1):
				if randcol<cri[j] and randcol>=cri[j+1]:
					row=randl[2*j]
					high=randl[2*j+1]
					break
		ci=circle(color,dx1,dy1,row,high)
		ci2=circle(color2,dx2,dy2,-8,9)
		g1.add(ci)
		g2.add(ci2)
	for c in g1:
		c.move()
	for c2 in g2:
		c2.move()
	a=pg.sprite.groupcollide(g1,g2,False,False) 	
	b=pg.sprite.groupcollide(g2,g1,False,False) 
	for c1,c2 in zip(a,b):
		if c1.color[2]<c2.color[2]:
			g2.remove(c2)
			newc1=circle(color,dx1,dy1,row,high)
			g1.add(newc1)
			c1.image=pg.Surface((c1.rect.size[0]+1,c1.rect.size[1]+1))
			
			c1.image.fill(c1.color)
			c1.rect.size=(c1.rect.size[0]+1,c1.rect.size[1]+1)
		elif c1.color[2]==c2.color[2]:
			g1.remove(c1)
			g2.remove(c2)
		else:
			c2.image=pg.Surface((c2.rect.size[0]+1,c2.rect.size[1]+1))
			newc2=circle(color2,dx2,dy2,-8,9)
			g2.add(newc2)
			c2.image.fill(c2.color)
			g1.remove(c1)
			c2.rect.size=(c2.rect.size[0]+1,c2.rect.size[1]+1)
	bscore=0
	for k in g1:
		bscore+=1
	text=font.render(str(bscore),True,(0,255,250))
	rscore=0
	for k in g2:
		rscore+=1
	text2=font.render(str(rscore),True,(255,0,100))
	g1.update()
	g2.update()
	g1.draw(screen)
	g2.draw(screen)
	screen.blit(text,(240,10))
	screen.blit(text2,(240,470))
	pg.display.flip()
	num1+=1
	print(num1)
	if num1==3000:
		num1=0
		g1.empty()
		g2.empty()
		df.loc[index]=[bscore]+cri+randl
		cri,randl=find(n)
		index+=1
	if index==50:
		dfname="gamedata"+str(n)+".csv"
		df.to_csv(dfname,header=True,index=False)
		n+=2
		cri,randl=find(n)
		nn=["score"]
		for i in range(n):
			nn.append("cri"+str(i))
		colname=tuple(nn)
		for i in range(n+1):
			rn="row"+str(i)
			hn="high"+str(i)
		colname+=(rn,hn)
		df=pd.DataFrame(columns=colname)
		index=0
pg.quit()

	
	
	
