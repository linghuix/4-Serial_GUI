# -- coding: utf-8 --

import sys                 # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np

import pickle              # pickle模块主要函数的应用举例 


"""
    model 输入特征，输出分类结果：标签值
    
    使用方法 python model.py "feature 0.00566178,0.00381959,0.00246555,..." "cali 0"
"""
if __name__=="__main__":
    
    ## 将字符串分离为数组
    feature = np.array(sys.argv[1].split(','))
    cali    = int(sys.argv[2])
    
    ## 将字符数组转化为浮点数数组
    data = list();
    # print(len(feature))
    for da in feature:
        data.append(float(da))
    # print(data)
    data = np.array(data)
    
    ## 打开训练好的模型
    # model = open('ModelFile.txt','rb')
    model = open('tmp\\ModelFile.txt','rb')
    
    if cali:
        model = open('tmp\\ModelFile_cali.txt','rb')
    
    clf = pickle.load(model)           # 分类模型
    
    ## 预测
    result = clf.predict(data.reshape(1,-1))
    print(result)
    