# -- coding: utf-8 --

import sys                 # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np

import pickle              # pickle模块主要函数的应用举例 

if __name__=="__main__":
    
    ## 将字符串分离为数组
    feature = np.array(sys.argv[1].split(','))
    
    ## 将字符数组转化为浮点数数组
    data = list();
    # print(len(feature))
    for da in feature:
        data.append(float(da))
    # print(data)
    data = np.array(data)
    
    ## 打开训练好的模型
    # model = open('ModelFile.txt','rb')
    model = open('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\tmp\ModelFile_adult.txt','rb')
    clf = pickle.load(model)           # 分类模型
    print(clf)
    ## 预测
    result = clf.predict(data.reshape(1,-1))
    print(result)
