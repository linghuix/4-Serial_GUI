# -- codin  g: utf-8 --

import sys                              # tO READ ARGUMENTS FROM CMD/SHELL

import numpy as np
np.random.RandomState(42)

import matplotlib.pyplot as plt

from sklearn import svm                 # 支持向量机算法
from sklearn import tree                # 决策树算法
from sklearn import neighbors           # 最近邻算法
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import LeaveOneOut, LeavePOut, ShuffleSplit, StratifiedKFold,RepeatedStratifiedKFold, GroupKFold, LeaveOneGroupOut
from sklearn.pipeline import Pipeline

from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

from sklearn.model_selection import train_test_split                        # 用于划分数据集

from sklearn.metrics import classification_report   # 评价分类的好坏（精确度,召回率,F1）
from sklearn.metrics import confusion_matrix        # 评价分类的好坏

import time                         # 计算程序运行时间

import scipy.io as sio              # 读取数据包

import pickle                       # pickle模块主要函数的应用举例 

"""
相同算法，同样对象，不同的样本下的分类精度比较。
"""
class Samlpes_result:
    
    def __init__(self):
        self.samples = []
        self.num = 0
        self.timecosts = []
        self.precise_average = []
        self.precise_variance = []
        self.predicit = []
        self.test = []
        self.prediciton = []
        self.precise_view = []
        
    
    def sampleSplit(self, sample, target, split, group = 0, index = 0):
        if len(group)>2 : # 存在group序列
            for train, test in split.split(sample, target, groups=group):
                if(index==0):
                    return sample[train],target[train],group[train],sample[test],target[test],group[test]
                index -=1
        else:
             X_train, X_test, y_train, y_test = train_test_split(sample, target, test_size=0.3, random_state = 42)
             return X_train, y_train, [], X_test, y_test, []
    
    """sample - list类型 横向为一个样本，最后一列为分类值"""
    def addSample(self,sample):
        self.samples.append(sample)
        self.num += 1
    
    """
    algorithm       算法
    splitMethod     样本划分方法
    """
    def compare(self, algorithm, splitMethod):
        self.timecosts = []
        self.precise_average = []
        self.precise_variance = []
        
        self.predict = []
        self.predict_n_supp = []
        self.predict_result = []
        self.test = []
        
        
        self.algori = algorithm
        for i in range(0, self.num):# 0 - modelnum-1
        
            D = self.samples[i]
            target_list = D.shape[1]-1       # target 为标签,Sample横向量为一个样本
            target = D[:,target_list]
            # print(target)                  # 目标分类值
            Sample = D[:,:target_list]
            # 划分训练集和测试集
            #group = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\group.mat')
            group = sio.loadmat('./tmp/group.mat')
            
            group = group['group_individual']
            group = group.reshape(-1)
            
            
            X_train,y_train,group_train,X_test,y_test,group_test = self.sampleSplit(Sample, target, splitMethod, [],index = 11-1) # index = 1, leave 1
            print('训练样本 : \n', X_train,set(y_train),'\n',set(group_train))
            #input("pause")
            
            algorithm.fit(X_train,y_train)
            
            
            N = 500
            # 预测时间评价
            time_start=time.time()
            for iter in range(0, 5):
                y_pred1 = algorithm.predict(X_test[0:N, :]);
            time_end=time.time()
            
            # 本次预测的评价
            print("sample",i, "特征向量长度：", target_list)
            print('classification_report : \n',classification_report(y_test[0:N],y_pred1))
            print('confusion_matrix : \n',confusion_matrix(y_test[0:N], y_pred1), '\n\n\n')
            
            # 模型整体性能的评价指标测试
            if len(group_train)>2 :
                print("group")
                this_scores = cross_val_score(algorithm, Sample, target,groups = group, cv = splitMethod)
            else : 
                print("cv=10")
                this_scores = cross_val_score(algorithm, Sample, target, cv = 10);
            
            # 关键数据存储
            self.timecosts.append((time_end-time_start)*1000/5) # ms"""
            self.precise_average.append(this_scores.mean())
            self.precise_variance.append(this_scores.std())
            self.precise_view.append(this_scores.view())
            
            self.predict_n_supp.append(sum(algorithm[1].n_support_))
            self.predict.append(y_pred1)
            self.test.append(y_test[0:N])
            self.predict_result.append(sum(y_test[0:N]==y_pred1)/len(y_pred1))

            
    def showmessage(self):
        print('timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print('precise_variance : ',self.precise_variance,'\n','predict_result',self.predict_result,'\n')
        
    def showplt_precise_average(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.num+1), self.precise_average,fc='r')
        plt.ylabel('precise_average')
        plt.show()
    
    def showplt_precise_variance(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.num+1), self.precise_variance,fc='r')
        plt.ylabel('precise_variance')
        plt.show()
        
    def showplt_timecosts(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.num+1), self.timecosts,fc='r')
        plt.ylabel('timecosts')
        plt.show()
        
    def showplt_other(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.num+1), self.predict_result, fc='r')
        plt.ylabel('One test precise')
        plt.show() 
        
    def showplt_precise_view(self):
        import matplotlib.pyplot as plt
        plt.boxplot(self.precise_view)
        plt.show()


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
    
    # 类的初始化
    result = Samlpes_result()
    # dir = 'D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features-'
    dir = './tmp/features-'
    type = '.mat'
    num = [1,2,3,4,5,7,9,11,13,15,17,20,30]
    for numindex in range(len(num)):
        S = dir+str(num[numindex])+type
        print(S)
        data = sio.loadmat(S)
        result.addSample(data['group']) # array object
    
    
    # 分类模型
    clf_rbfsvm1 = svm.SVC(kernel = 'rbf',gamma = 'scale')
    clf_linsvm2 = svm.SVC(kernel = 'linear',gamma = 'scale')
    clf_tree = tree.DecisionTreeClassifier(criterion="gini")
    clf_lda  = LinearDiscriminantAnalysis(solver="svd", n_components=ldaNum, store_covariance=True,tol = 1.0e-4)
    clf_knn  =neighbors.KNeighborsClassifier(n_neighbors=5, weights='uniform', algorithm='auto', leaf_size=1, p=2 ,metric='minkowski', metric_params=None)
    clf_NN = MLPClassifier(hidden_layer_sizes=(10,), activation='logistic', solver='lbfgs', alpha=0.0001, batch_size='auto', learning_rate='adaptive', max_iter=200,tol=0.0001, verbose=True, warm_start=False, nesterovs_momentum=True)
    
    # 降维模型
    transform_pca = PCA(n_components = pcaNum)                              # 预处理降维器
    transform_pca_lda = PCA(n_components = ldaNum)  
    transform_lda = LinearDiscriminantAnalysis(n_components=ldaNum)       # 预处理降维器


    # 管道模型   降维模型+分类模型
    modelnum = 11;
    
    # 论文中的序号
    # N0.3
    pipe_svm1 = Pipeline([('lda', transform_lda), ('svc', clf_rbfsvm1)])
    # N0.4
    pipe_svm2 = Pipeline([('lda', transform_lda), ('svc', clf_linsvm2)])
    # N0.6
    pipe_svm3 = Pipeline([('pca', transform_pca), ('svc', clf_linsvm2)])
    # N0.5
    pipe_svm4 = Pipeline([('pca', transform_pca_lda), ('svc', clf_linsvm2)])
    # N0.7
    pipe_svm5 = Pipeline([('pca', transform_pca), ('svc', clf_rbfsvm1)])
    # No.2
    pipe_tree1 = Pipeline([('pca', transform_pca), ('svc', clf_tree)])
    # No.1
    pipe_tree2 = Pipeline([('lda', transform_lda), ('svc', clf_tree)])
    # N0.11
    pipe_lda = Pipeline([('lda', clf_lda)])
    # N0.8
    pipe_knn1 = Pipeline([('pca', transform_pca), ('knn', clf_knn)])
    # N0.9
    pipe_knn2 = Pipeline([('lda' ,transform_lda),  ('knn', clf_knn)])
    # N0.10
    pipe_NN2 = Pipeline([('lda' , transform_lda),  ('NN', clf_NN)])
    
    # 计算和显示结果
    gkf = GroupKFold(n_splits = 2)
    logo = LeaveOneGroupOut()
    
    result.compare(pipe_svm2, logo)
    result.showmessage()
    result.showplt_precise_average()
    result.showplt_precise_variance()
    result.showplt_timecosts()
    result.showplt_other()
    result.showplt_precise_view()
    
    
