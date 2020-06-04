#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np

from datetime import datetime


# In[3]:


def get_ms(st):
    
    dt_obj = datetime.strptime('1.1.1970 ' + st,
                               '%d.%m.%Y %H:%M:%S.%f')
    millisec = dt_obj.timestamp() * 1000

    return millisec


# In[4]:


n_mods = 20
with open('res.txt','r') as f:
    n = int(f.readline())
    dist = {}
    prev = ""
    for line in f:
        pos = line.rfind('unit')
        words = line.split(' ')
        if (pos != -1):
            diff = get_ms(line[:pos].strip()) - get_ms(prev)
            
            if dist.get(words[3]) is None:
                dist[words[3]] = diff
            else:    
                dist[words[3]] += diff
        prev = words[0]
for key in dist:
    dist[key] = dist[key] / n


# In[8]:


import matplotlib.pylab as plt

lists = sorted(dist.items(), key=lambda x: x[1]) # sorted by key, return a list of tuples

x, y = zip(*lists) # unpack a list of pairs into two tuples
plt.figure(figsize=(10,10))
plt.barh(x, y, color=(0.2, 0.4, 0.6, 0.6))
plt.xlabel('init time, ms')
plt.ylabel('module names')
plt.tight_layout()
plt.savefig('mod_dist.png')

