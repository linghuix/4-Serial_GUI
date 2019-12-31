# -- codin  g: utf-8 --

import sys                          # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np
import matplotlib.pyplot as plt

from sklearn import svm

from sklearn.model_selection import LeavePOut,ShuffleSplit
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import Pipeline

from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis


from sklearn.model_selection import train_test_split    # 用于划分数据集

from sklearn.metrics import classification_report   # 评价分类的好坏（精确度,召回率,F1）
from sklearn.metrics import confusion_matrix        # 评价分类的出错点

import scipy.io as sio                              # 读取数据包

import pickle                                       # pickle模块主要函数的应用举例 

import Algori_Compare as my


if __name__=="__main__":
    
    pcaNum     = 3  # 降维后的维度
    ldaNum    = 1   # 训练数据量
    cross_test = 0   # 是否需要十次交叉验证
    save       =  0
    cali       = 0
    
    """ 数据直接输入
    pcaNum     = int(sys.argv[1])   # 降维后的维度
    # tranNum    = int(sys.argv[2])   # 训练数据量
    cross_test = int(sys.argv[2])   # 是否需要十次交叉验证
    save       = int(sys.argv[3])
    cali       = int(sys.argv[4])
    """
    
    
    #data = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\2-ARM小体积\\static\\data\\sample.mat')
    if cali:
        data = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features_cali.mat')
    data = sio.loadmat('/mnt/Documents/1-embed/4-Serial_GUI/2-ARM小体积/static/data/sample.mat')
    
    D = data['sample']   # array object
    
    
    # as it creates all the possible training/test sets by removing p samples. from the complete set.
    SSlit = ShuffleSplit(n_splits=5, test_size=0.3)
    
    
    # clf = svm.SVC(C=1.0, kernel='poly',degree = 3, gamma = 'auto')      # SVR 分类模型
    
    # 分类模型
    clf_rbfsvm1 = svm.SVC(kernel = 'rbf',gamma = 'scale')
    clf_linsvm2 = svm.SVC(kernel = 'linear',gamma = 'scale')
    clf_lda  = LinearDiscriminantAnalysis(solver="svd", n_components=ldaNum, store_covariance=True,tol = 1.0e-4)
    
    # 降维模型
    transform_pca = PCA(n_components = pcaNum)                              # 预处理降维器
    transform_pca_lda = PCA(n_components = ldaNum)  
    transform_lda = LinearDiscriminantAnalysis(n_components=ldaNum)       # 预处理降维器
    
    # 管道模型   降维模型+分类模型
    
    # 论文表格 4.2 中的序号
    # N0.4
    pipe_svm1 = Pipeline([('lda', transform_lda), ('svc', clf_rbfsvm1)])# 有 colinear 问题
    # N0.3
    pipe_svm2 = Pipeline([('lda', transform_lda), ('svc', clf_linsvm2)])
    # N0.6
    pipe_svm3 = Pipeline([('pca', transform_pca), ('svc', clf_linsvm2)])
    # N0.5
    pipe_svm4 = Pipeline([('pca', transform_pca_lda), ('svc', clf_linsvm2)])
    # N0.7
    pipe_svm5 = Pipeline([('pca', transform_pca), ('svc', clf_rbfsvm1)])
    # N0.11
    pipe_lda = Pipeline([('lda', clf_lda)])
    print("模型初始化... ")
    
    # 类的初始化
    cop = my.Algorithms_result(0)
    
    algorithm = [ pipe_svm1, pipe_svm2, pipe_svm3, pipe_svm5, pipe_lda]
    for algorithmIndex in range(len(algorithm)):
        algori = algorithm[algorithmIndex]
        print("添加算法", algori)
        cop.addAlgorithm(algori) # array object
    
    target = D[:,-1]
    feature = D[:,0:-1]
    select= D[:,-1]==1
    Newfeature = feature[select]

    one = np.ones(len(Newfeature)-1000-800)
    zero = np.zeros(1000)
    two  = 2*np.ones(800)
    
    Newtarget = np.hstack((one,zero,two))
    Newdata = np.hstack((Newfeature,Newtarget.reshape(len(Newtarget),1)))
    #cop.compare(D)
    cop.compare(Newdata)

    # 计算和显示结果
    cop.showmessage()
    cop.showplt_precise_average()
    cop.showplt_precise_variance()
    cop.showplt_timecosts()
    cop.showplt_precise_view()
    
    
    
    """
    print('explained_variance_: ',pipe.named_steps['pca'].explained_variance_) 
    print('explained_variance_ratio_: ',pipe.named_steps['pca'].explained_variance_ratio_) 
    """
    
    
    if save:
        #使用dump()将数据序列化到文件中  
        fw = open('D:\\1-embed\\4-Serial_GUI\\2-ARM小体积\\static\\tmp\\ModelFile.txt','wb')
        
        if cali:
            fw = open('D:\\1-embed\\4-Serial_GUI\\2-ARM小体积\\static\\tmp\\ModelFile_cali.txt','wb')  
        
        # Pickle the list using the highest protocol available.  
        pickle.dump(pipe, fw, -1)  
        fw.close()
        print('保存成功！')
