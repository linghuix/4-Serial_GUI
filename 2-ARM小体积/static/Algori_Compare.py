import numpy as np
np.random.RandomState(42)

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

"""
相同样本，不同的算法之间的分类精度比较。
"""
class Algorithms_result:
    
    def __init__(self,stepbystep=0):
        self.classname = 'Algorithms_result'
        self.Algorithms = []        # 算法对象存储
        self.num = 0                # 算法数量
        self.index = 0              # 结果条数记录
        self.timecosts = []         # 算法耗时
        self.precise_average = []   # 平均精度
        self.precise_variance = []  # 平均方差
        self.precise_view = []      # 十次交叉验证的精度数值
        self.precise_view = []      # 十次交叉验证的精度数值
        self.pred = []              # 算法的预测分类结果
        self.truth = []             # 真实值
        self.stepbystep = stepbystep             # 单步运行
        
    """sample - list类型 横向为一个样本，最后一列为分类值"""
    def addAlgorithm(self,Algorithm):
        self.Algorithms.append(Algorithm)
        self.num += 1
        
    def compare(self,sampl):
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        command = 'y'
        
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        
        self.truth = y_test
        
        for i in range(0, self.num):# 0 - modelnum-1
        
            Algori = self.Algorithms[i]
            Algori.fit(X_train,y_train)
            
            # 预测时间的测试
            time_start=time.time()
            for iter in range(0, 5):
                y_pred = Algori.predict(X_test)
            time_end=time.time()
            self.pred.append(y_pred)
            
            print(self.classname,'-compare-',"算法：", Algori)
            
            if self.stepbystep:
                command = input(self.classname+'-compare-'+'stepbystep, continue?  y or n')
                
            self.index+=1;
            
            if command == 'N' or command == 'n':
                break;
            
            # 模型的评价指标测试
            this_scores = cross_val_score(Algori, Sample, target, cv = 10);
            
            self.timecosts.append((time_end-time_start)*1000/5) # ms
            self.precise_average.append(this_scores.mean())
            self.precise_variance.append(this_scores.std())
            self.precise_view.append(this_scores.view())
            #input('next?')
    
    def showmessage(self):
        print(self.classname,'-compare-','timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print(self.classname,'-compare-','precise view',self.precise_view)
        print(self.classname,'-compare-','precise_variance',self.precise_variance,'\n')

        
    def showplt_precise_average(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.precise_average,fc='r')
        plt.ylabel('precise_average')
        plt.show()
    
    def showplt_precise_variance(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.precise_variance,fc='r')
        plt.ylabel('precise_variance')
        plt.show()
        
    def showplt_timecosts(self):
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.timecosts,fc='r')
        plt.ylabel('timecosts')
        plt.show()
        
    def showplt_precise_view(self):
        import matplotlib.pyplot as plt
        plt.boxplot(self.precise_view)
        plt.show()
        
    # agorithm_index 序号从零开始
    def showplt_prediction(self, agorithm_index):
        predict = self.pred[agorithm_index]
        plt.plot(prediciton ,c='r')
        plt.plot(self.truth,c='b')
        plt.show()
        
"""
相同算法，同样对象，不同的样本下的分类精度比较。
"""
class Samlpes_result:
    
    def __init__(self):
        self.classname = 'Samlpes_result'
        self.samples = []
        self.num = 0
        self.timecosts = []
        self.precise_average = []
        self.precise_variance = []
        self.predicit = []
        self.test = []
        self.prediciton = []
        
    
    def sampleSplit(self, sample, target, split, group = 0, index = 0):
        if len(group)>2 : # 存在group序列
            for train, test in split.split(sample, target, groups=group):
                if(index==0):
                    return sample[train],target[train],group[train],sample[test],target[test],group[test]
                index -=1
    
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
        # self.predict_n_supp = []
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
            group = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\group.mat')
            group = group['group_individual']
            group = group.reshape(-1)
            
            
            X_train,y_train,group_train,X_test,y_test,group_test = self.sampleSplit(Sample, target, splitMethod, group,index = 11-1) # index = 1, leave 1
            print(self.classname,'-compare-','训练样本 : \n', X_train,set(y_train),'\n',set(group_train))
            #input("pause")
            
            algorithm.fit(X_train,y_train)
            
            
            # 预测时间评价
            time_start=time.time()
            for iter in range(0, 5):
                y_pred1 = algorithm.predict(X_test);
            time_end=time.time()
            
            # 本次预测的评价
            print(self.classname,'-compare-',"sample",i, "特征向量长度：", target_list)
            print(self.classname,'-compare-','classification_report : \n',classification_report(y_test,y_pred1))
            print(self.classname,'-compare-','confusion_matrix : \n',confusion_matrix(y_test, y_pred1))
            
            # 模型整体性能的评价指标测试
            this_scores = cross_val_score(algorithm, Sample, target,groups = group, cv = splitMethod);
            # this_scores = cross_val_score(algorithm, Sample, target, cv = 10);
            
            # 关键数据存储
            self.timecosts.append((time_end-time_start)*1000/5) # ms"""
            self.precise_average.append(this_scores.mean())
            self.precise_variance.append(this_scores.std())
            
            # self.predict_n_supp.append(sum(algorithm[1].n_support_))
            self.predict.append(y_pred1)
            self.test.append(y_test)
            self.predict_result.append(sum(y_test==y_pred1)/len(y_pred1))
            
    def showmessage(self):
        print(self.classname,'-showmessage-','timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print(self.classname,'-showmessage-','precise_variance : ',self.precise_variance,'\n','predict_result',self.predict_result,'\n')
        
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
        
