
# coding: utf-8

# In[2]:


from selenium import webdriver
import requests
from datetime import datetime
from bs4 import BeautifulSoup
driver = webdriver.Chrome('/home/oh/chromedriver')
driver.implicitly_wait(3)
# url에 접근한다.
driver.get('https://www.swexpertacademy.com/main/sst/common/userTestList.do?')
driver.find_element_by_name('id').send_keys('dhdbsgn111@naver.com')
driver.find_element_by_name('pwd').send_keys('y@7625714')
driver.find_element_by_xpath('//*[@id="LoginForm"]/div/div/div[2]/div/div/fieldset/div/div[4]/button').click()
driver.implicitly_wait(20)
driver.find_element_by_xpath('/html/body/div[4]/div[3]/div/div/section/div[4]/div/a').click()
driver.implicitly_wait(20)
html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')
now=soup.find ( 'td' , {'class':'no_data'})
#문자보내기
time = datetime.now()
url='https://maker.ifttt.com/trigger/check/with/key/7P6bqu7Z2TTEOtxdujadk'
if now.get_text()=='현재 신청 가능한 시험 일정이 없습니다.':
        r=requests.post(url,data={'value1':time})

