# -- coding: utf-8 --

import sys                              # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np
# np.random.RandomState(42)

import matplotlib.pyplot as plt

from sklearn import svm                 # 支持向量机算法
from sklearn import tree                # 决策树算法
from sklearn import neighbors           # 最近邻算法
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import LeavePOut,ShuffleSplit
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import Pipeline

from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

from sklearn.model_selection import train_test_split                        # 用于划分数据集

from sklearn.metrics import classification_report   # 评价分类的好坏（精确度,召回率,F1）
from sklearn.metrics import confusion_matrix        # 评价分类的好坏

import time                         # 计算程序运行时间

import scipy.io as sio              # 读取数据包

import pickle                       # pickle模块主要函数的应用举例 

if __name__=="__main__":

    pcaNum     = 7  # 降维后的维度
    ldaNum    = 4   # 训练数据量
    cross_test = 0   # 是否需要十次交叉验证
    save       =  0

    """
    pcaNum     = int(sys.argv[1])   # 降维后的维度
    tranNum    = int(sys.argv[2])   # 训练数据量
    cross_test = int(sys.argv[3])   # 是否需要十次交叉验证
    save       = int(sys.argv[4])
    """
    
    print(int(pcaNum))

    # data = sio.loadmat('F:\\1-embed\\7-MATLAB\\调用外部程序调试\\matlab+python\\group.mat')
    # data = sio.loadmat('F:\\1-embed\\7-MATLAB\\调用外部程序调试\\matlab+python\\adult_group.mat')
    data = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features_cali.mat')
    
    
    D = data['group']   # array object
    print(D.shape)

    target_list = D.shape[1]-1       # target 为标签,Sample横向量为一个样本
    target = D[:,target_list]
    print(target)                  # 目标分类值
    
    Sample = D[:,:target_list]
    
    # as it creates all the possible training/test sets by removing p samples. from the complete set.
    SSlit = ShuffleSplit(n_splits=5, test_size=0.3)
    
    # clf = svm.SVC(C=1.0, kernel='poly',degree = 3, gamma = 'auto')      # SVR 分类模型
      
    # 分类模型
    clf_svm1 = svm.SVC(kernel = 'rbf',gamma = 'scale')
    clf_svm2 = svm.SVC(kernel = 'linear',gamma = 'scale')
    clf_tree = tree.DecisionTreeClassifier(criterion="gini")
    clf_lda = LinearDiscriminantAnalysis(solver="svd", n_components=ldaNum, store_covariance=True,tol = 1.0e-4)
    clf_knn  =neighbors.KNeighborsClassifier(n_neighbors=5, weights='uniform', algorithm='auto', leaf_size=1, p=2 ,metric='minkowski', metric_params=None)
    clf_NN = MLPClassifier(hidden_layer_sizes=(10,), activation='logistic', solver='lbfgs', alpha=0.0001, batch_size='auto', learning_rate='adaptive', max_iter=200,tol=0.0001, verbose=True, warm_start=False, nesterovs_momentum=True)
    
    # 降维模型
    transform_pca = PCA(n_components = pcaNum)                              # 预处理降维器
    transform_pca_lda = PCA(n_components = ldaNum)  
    transform_lda = LinearDiscriminantAnalysis(n_components=ldaNum)       # 预处理降维器


    # 管道模型   降维模型+分类模型
    modelnum = 11;
    
    pipe_svm1 = Pipeline([('lda', transform_lda), ('svc', clf_svm1)])
    pipe_svm2 = Pipeline([('lda', transform_lda), ('svc', clf_svm2)])#***
    pipe_svm3 = Pipeline([('pca', transform_pca), ('svc', clf_svm2)])
    pipe_svm4 = Pipeline([('pca', transform_pca_lda), ('svc', clf_svm2)])
    pipe_svm5 = Pipeline([('pca', transform_pca), ('svc', clf_svm1)])

    pipe_tree1 = Pipeline([('pca', transform_pca), ('svc', clf_tree)])
    pipe_tree2 = Pipeline([('lda', transform_lda), ('svc', clf_tree)])#**

    pipe_lda = Pipeline([('lda', clf_lda)])
    
    pipe_knn1 = Pipeline([('pca', transform_pca), ('knn', clf_knn)])
    pipe_knn2 = Pipeline([('lda' ,transform_lda),  ('knn', clf_knn)])
    
    pipe_NN2 = Pipeline([('lda' , transform_lda),  ('NN', clf_NN)])
    
    
    a  = (pipe_svm1,pipe_svm2,pipe_svm3,pipe_svm4,pipe_svm5,pipe_tree1,pipe_tree2,pipe_lda,pipe_knn1,pipe_knn1,pipe_NN2);
    name = ('pipe_svm1','pipe_svm2','pipe_svm3','pipe_svm4','pipe_svm5','pipe_tree1','pipe_tree2','pipe_lda','pipe_knn1','pipe_knn2','pipe_NN2')
   
    # 划分训练集和测试集
    X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
    
    
    #for train_index, test_index in SSlit.split(target):
    #pipe.fit(Sample[train_index],target[train_index])
    #  break
    for i in range(0, modelnum):
    
        # 表明正在测试的模型
        print(name[i],':')
        a[i].fit(X_train,y_train)
        
        # 预测时间的测试
        time_start=time.time()
        y_pred1 = a[i].predict(X_test);
        time_end=time.time()
        print('time cost : ',(time_end-time_start)*1000,'ms')
        
        # 模型的评价指标测试
        this_scores = cross_val_score(a[i], Sample, target, cv = 10);
        print('十次交叉结果：',this_scores.view())
        print('十次交叉结果均值：',this_scores.mean())
        print('十次交叉方差值：',this_scores.std())
        print(classification_report(y_test,y_pred1))
        print(confusion_matrix(y_test, y_pred1))
        

    # print('explained_variance_: ',pipe.named_steps['pca'].explained_variance_) 
    # print('explained_variance_ratio_: ',pipe.named_steps['pca'].explained_variance_ratio_) 

    x = a[1][0].transform(Sample)
    plt.plot(x, label=("LDA feature"), linewidth=1.0 )
    plt.plot(target, label=("class"), linewidth=2.0,C=[0,0,0])
    
    font = {'family': 'Times New Roman', 'weight': 'normal', 'size': 20}
    legend = plt.legend(prop=font)
    plt.tick_params(labelsize=20)
    plt.xlabel("round", font)
    plt.ylabel("round", font)
    
    plt.show()

    if save:
        #使用dump()将数据序列化到文件中  
        # fw = open('F:\\1-embed\\7-MATLAB\\调用外部程序调试\\matlab+python\\MultiModelFile.txt','wb')
        fw = open('D:\\1-embed\\4-Serial_GUI\\MultiModelFile.txt','wb')
        
        for i in range(0, modelnum):
            # Pickle the list using the highest protocol available.
            pickle.dump(a[i], fw, -1)
            
        fw.close()
        print('所有模型保存成功！')
