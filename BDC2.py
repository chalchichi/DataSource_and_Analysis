from google.colab import drive
drive.mount('/gdrive')
import tensorflow as tf
from tensorflow.contrib import rnn
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from scipy.stats import boxcox

##data cleansing
output=[]
data_frame = pd.read_csv("/gdrive/My Drive/AE.csv")
data_frame["Unnamed: 0"]=list(range(1,len(data_frame["Unnamed: 0"])+1))
del data_frame["Volume"]
del data_frame["MarketCap"]
if max(data_frame["CLOSE"])>=1000:
  mn=1000
  data_frame=data_frame/mn
elif max(data_frame["CLOSE"])>=100:
  mn=100
  data_frame=data_frame/mn
elif max(data_frame["CLOSE"])>=10:
  mn=10
  data_frame=data_frame/mn
else:
  mn=1
  
##hyper parameter
timesteps = seq_length = 1
data_dim = 5
hidden_dim = 3
output_dim = 1
learing_rate = 0.0005
iterations = 50000

##preapair for tensorflow
x = data_frame.values
y = data_frame["CLOSE"].values
dataX = []
dataY = []
for i in range(0, len(y) - seq_length):
    _x = np.copy(x[i:i + seq_length + 1])
    _x[timesteps-2][data_dim-1] = 0
    _x[timesteps-1][data_dim-1] = 0
    _x[timesteps][data_dim-1] = 0
    _y = [y[i + seq_length]]
    dataX.append(_x)
    dataY.append(_y)
train_size = int(len(dataY) -10)
test_size = len(dataY) - train_size 

trainX = np.array(dataX[:train_size])
testX = np.array(dataX[train_size : ])

trainY = np.array(dataY[:train_size])
testY = np.array(dataY[train_size : ])

## LSTM tensorflow
tf.reset_default_graph()

X = tf.placeholder(tf.float32, [None, seq_length+1, data_dim])
Y = tf.placeholder(tf.float32, [None, 1])
def lstm_cell(): 
    cell = rnn.BasicLSTMCell(hidden_dim, state_is_tuple=True) 
    return cell 


cell = rnn.BasicLSTMCell(num_units=hidden_dim, state_is_tuple=True)
multi_cells = rnn.MultiRNNCell([lstm_cell() for _ in range(5)], state_is_tuple=True)


outputs, _states = tf.nn.dynamic_rnn(multi_cells, X, dtype=tf.float32)

Y_pred = tf.contrib.layers.fully_connected(outputs[:, -1], output_dim, activation_fn=None)

loss = tf.reduce_sum(tf.square(Y_pred - Y))  
train = tf.train.RMSPropOptimizer(learing_rate).minimize(loss)

sess = tf.Session()
init = tf.global_variables_initializer()
sess.run(init)

for i in range(iterations):
    _  , cost = sess.run([train ,loss], feed_dict={X: trainX, Y: trainY})
    if (i+1) % (iterations/10) == 0:
        print("[step: {}] loss: {}".format(i+1, cost))
        
# make predict
test_predict = sess.run(Y_pred, feed_dict={X: testX})
output.append(list(test_predict*mn))
 
