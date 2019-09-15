# -- codin  g: utf-8 --

import sys                          # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np
import matplotlib.pyplot as plt

from sklearn import svm

from sklearn.model_selection import LeaveOneOut, LeavePOut, ShuffleSplit, StratifiedKFold,RepeatedStratifiedKFold, GroupKFold

from sklearn.model_selection import cross_val_score
from sklearn.pipeline import Pipeline

from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

from sklearn.model_selection import train_test_split                        # 用于划分数据集

from sklearn.metrics import classification_report   # 评价分类的好坏（精确度,召回率,F1）
from sklearn.metrics import confusion_matrix        #

import scipy.io as sio              # 读取数据包

import pickle                       # pickle模块主要函数的应用举例 

if __name__=="__main__":

    pcaNum     = int(sys.argv[1])   # 降维后的维度
    # tranNum    = int(sys.argv[2])   # 训练数据量
    cross_test = int(sys.argv[2])   # 是否需要十次交叉验证
    save       = int(sys.argv[3])
    cali       = int(sys.argv[4])

    # print(int(pcaNum))
    
    # data = sio.loadmat('D:\\1-embed\\7-MATLAB\\调用外部程序调试\\matlab+python\\group.mat')
    data = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features.mat')
    
    if cali:
        data = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features_cali.mat')
    
    D = data['group']   # array object
    print(D.shape)
    
    target_list = D.shape[1]-1       # target 为标签,Sample横向量为一个样本
    target = D[:,target_list]
    # print(target)                  # 目标分类值
    
    Sample = D[:,:target_list]

    # as it creates all the possible training/test sets by removing p samples. from the complete set.
    SSlit = ShuffleSplit(n_splits=5, test_size=0.3)

    # clf = svm.SVC(C=1.0, kernel='poly',degree = 3, gamma = 'auto')      # SVR 分类模型
    clf = svm.SVC(kernel = 'linear',gamma = 'scale')
    # transform = PCA(n_components = pcaNum)                              # 预处理降维器
    transform = LinearDiscriminantAnalysis(n_components=pcaNum)       # 预处理降维器
    pipe = Pipeline([('pca', transform), ('svc', clf)])                 # 管道        


    # 划分训练集和测试集
    X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)

    """for train_index, test_index in SSlit.split(target):
        pipe.fit(Sample[train_index],target[train_index])
        break
    """
    pipe.fit(X_train, y_train);
    
    """
    print('explained_variance_: ',pipe.named_steps['pca'].explained_variance_) 
    print('explained_variance_ratio_: ',pipe.named_steps['pca'].explained_variance_ratio_) 
    """
    
    y_pred = pipe.predict(X_test);
    
    # 预测的分类数据
   # plt.subplot(211)
    plt.plot(y_pred ,c='r')
    
    # 实际的分类数据
   # plt.subplot(212)
    plt.plot(y_test ,c='b')
    
    plt.show()
    

    print(classification_report(y_test,y_pred))
    print(confusion_matrix(y_test, y_pred))

    
    if cross_test:
        this_scores = cross_val_score(pipe, Sample, target, cv = 10)
        print('10次交叉验证：\n')
        print('10次交叉验证的精确度',this_scores.view())
        print('10次交叉验证的精确度平均值',this_scores.mean())
        print('10次交叉验证的精确度方差',this_scores.std())
        print('-----------------------------------------------')
        

        group = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\group.mat')
        group = group['group_individual']
        group = group.reshape(-1)
        print(group)
        # gkf.split(X, y, groups=group)
        gkf = GroupKFold(n_splits=11)
        for train, test in gkf.split(Sample, target, groups=group):
            print("%s %s" % (train, test))
        this_scores = cross_val_score(pipe, Sample, target,groups = group, cv = gkf)
        print('5随机划分训练集：\n')
        print('随机交叉验证的精确度',this_scores.view())              
        print('随机交叉验证的精确度平均值',this_scores.mean())
        print('随机交叉验证的精确度方差',this_scores.std())

    if save:
        #使用dump()将数据序列化到文件中  
        fw = open('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\ModelFile.txt','wb')
        
        if cali:
            fw = open('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\ModelFile_cali.txt','wb')  
        
        # Pickle the list using the highest protocol available.  
        pickle.dump(pipe, fw, -1)  
        fw.close()
        print('保存成功！')
