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

class Best:
    def __init__(self):
        self.classname = ''
        self.Algorithms = []        # 算法对象存储
        self.prediction = []        # 算法训练集预测
        self.truth = []             # 算法训练集真值
        self.precise_view = []      # 十次交叉验证的精度数值
        self.precise_average = 0   # 平均精度
        self.timecosts = 0         # 算法耗时
        self.para = []         # 算法耗时


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
        self.pred = []              # 算法的预测分类结果
        self.truth = []             # 真实值
        self.stepbystep = stepbystep             # 单步运行
        
    """sample - list类型 横向为一个样本，最后一列为分类值"""
    def addAlgorithm(self, Algorithm):
        self.Algorithms.append(Algorithm)
        self.num += 1
        
        
    def sampleSplit(self, sample, target, split, group = 0, index = 0):
        if len(group)>2 : # 存在group序列
            for train, test in split.split(sample, target, groups=group):
                if(index==0):
                    return sample[train],target[train],group[train],sample[test],target[test],group[test]
                index -=1
        else:
             X_train, X_test, y_train, y_test = train_test_split(sample, target, test_size=0.3, random_state = 42)
             return X_train, y_train, [], X_test, y_test, []
    
    """
    testTime - 测试算法预测时间时，重复测试取平均的次数
    all      - 是否循环预测所有的splitMethod划分结果，如果是1，testTime设置循环预测的次数
    splitMethod - 数据集划分方法
    sampl - 样本数据
    """
    def compare(self, sampl, splitMethod, all = 0, testTime = 5):
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        command = 'y'
        
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        print("训练特征", len(X_train[0]))
        self.truth = y_test
        
        for i in range(0, self.num):# 0 - modelnum-1
        
            Algori = self.Algorithms[i]
            Algori.fit(X_train,y_train)
            
            
            # 预测时间的测试
            print("sample",i, "特征向量长度：", target_list)
            if all == 0 : 
                time_start=time.time()
                for iter in range(0, testTime):
                    y_pred = Algori.predict(X_test)
                time_end=time.time()
                self.pred.append(y_pred)
                # 本次预测的评价
                print('classification_report : \n',classification_report(y_test, y_pred))
                print('confusion_matrix : \n',confusion_matrix(y_test, y_pred, labels = [0,1,2,3,6]), '\n\n\n')
            else :
                testTime=0
                time_start=time.time()
                for train, test in splitMethod.split(Sample, target):
                    Algori.fit(Sample[train],target[train])
                    testTime = testTime+1
                    y_pred = Algori.predict(Sample[test])
                    # 本次预测的评价
                    print('classification_report : \n',classification_report(target[test], y_pred))
                    print('confusion_matrix : \n',confusion_matrix(target[test], y_pred), '\n\n\n')
                time_end=time.time()
            
            print(self.classname,'-compare-',"算法：", Algori)
            if self.stepbystep:
                command = input(self.classname+'-compare-'+'stepbystep, continue?  y or n')
                
            self.index+=1;
            
            if command == 'N' or command == 'n':
                break;
            
            ## 模型的评价指标测试
            ## this_scores = cross_val_score(Algori, Sample, target, cv = 10);
            this_scores = cross_val_score(Algori, Sample, target, cv = splitMethod);
            
            self.timecosts.append((time_end-time_start)*1000/testTime) # ms
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
        
    # 选择最优的一个模型进行保存
    def save(self, index, path):
        import pickle
        
        
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        
        Algori = self.Algorithms[i]
        Algori.fit(X_train,y_train)
        
        fw = open(path,'wb')  
        pickle.dump(self.Algorithms[index], fw, -1)
        fw.close()
        print('保存成功！')


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
        self.precise_view = []
        
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
            group = sio.loadmat('D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\group.mat')
            group = group['group_individual']
            group = group.reshape(-1)
            
            
            X_train,y_train,group_train,X_test,y_test,group_test = self.sampleSplit(Sample, target, splitMethod, group,index = 11-1) # index = 1, leave 1
            print(self.classname,'-compare-','训练样本 : \n', X_train,set(y_train),'\n',set(group_train))
            #input("pause")
            
            algorithm.fit(X_train,y_train)
            
            
            # 对预测 N 个数据的时间评价
            N = len(target)# 500
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
        
    def showplt_precise_view(self):
        import matplotlib.pyplot as plt
        plt.boxplot(self.precise_view)
        plt.show()


""" 
    二分类分类器
    实现 0,1 的分类，选定特征 5 ，阈值为 1.758
"""
class Static_result:
    
    def __init__(self,threshold, stepbystep=0):
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
        self.threshold = threshold
        
    def predict(self, test, length, threshold = 0):
        
        list = []
        for i in range(length):
            sample = test[i,:]
            # if( sample[5] > 11.04 or sample[5]<6.69 or sample[10]<8 or sample[25]<8  ):
            
            if( sample[5] > threshold):
                list.append(0)
            else :
                list.append(1)
        # plt.plot(test[:,5])
        # plt.show()
        return list;
        
        
    """
    testTime - 测试算法预测时间时，重复测试取平均的次数
    all      - 是否循环预测所有的splitMethod划分结果，如果是1，testTime设置循环预测的次数
    splitMethod - 数据集划分方法
    sampl - 样本数据
    """
    def compare(self, sampl, splitMethod, all = 0, featureIndex = 0, testTime = 5):
    
        BestOne = Best()
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        command = 'y'
        
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        
        self.truth = y_test
        
        # 预测时间的测试
        print("特征向量长度：", target_list)
        if all==0 : 
            
            time_start=time.time()
            for iter in range(0, testTime):
                y_pred = self.predict(X_test, len(y_test), 1.758)
            time_end=time.time()
            
            self.pred.append(y_pred)
            # 本次预测的评价
            print('classification_report : \n',classification_report(y_test, y_pred))
            print('confusion_matrix : \n',confusion_matrix(y_test, y_pred, labels = [0,1,2,3,6]), '\n\n\n')
            self.timecosts.append((time_end-time_start)*1000/testTime) # ms
            
        else :
            testTime=0
            time_start=time.time()
            for threshold in np.linspace(0,3,100):
                for train, test in splitMethod.split(Sample, target):
                    sam = Sample[train]
                    tar = target[train]
                    testTime = testTime+1
                    
                    truth = tar
                    
                    y_pred = self.predict(Sample[train], len(train), threshold)
                    # print(y_pred)
                    # 存储数据
                    self.pred = np.append(self.pred, y_pred)
                    self.truth = np.append(self.truth, truth)
                    # print(sam[:,0],tar)
                    # 本次预测的评价
                    # print('classification_report : \n',classification_report(truth, y_pred))
                    # print('confusion_matrix : \n',confusion_matrix(truth, y_pred), '\n\n\n')
                    self.precise_view.append(sum(y_pred==truth)/len(truth))
                    
                time_end=time.time()
                
                if BestOne.precise_average < sum(self.precise_view)/len(self.precise_view):
                    print(threshold)
                    print('classification_report : \n',classification_report(truth, y_pred))
                    print('confusion_matrix : \n',confusion_matrix(truth, y_pred), '\n\n\n')
                    
                    BestOne.para=[]
                    
                    BestOne.precise_average = sum(self.precise_view)/len(self.precise_view)
                    BestOne.timecosts = time_end-time_start
                    BestOne.para.append(threshold)
                    BestOne.precise_view = self.precise_view
                    self.precise_view = []
        return BestOne
        
        
    def showmessage(self):
        print(self.classname,'-compare-','timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print(self.classname,'-compare-','precise view',self.precise_view)
        print(self.classname,'-compare-','precise_variance',self.precise_variance,'\n')
    
    """人眼观察不同标签的特征值 ，提取阈值"""
    def getthreshold(self, sampl, splitMethod, featureIndex = 0):
    
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        
        testTime = 0
        for train, test in splitMethod.split(Sample, target):
            sam = Sample[train]
            tar = target[train]
            testTime = testTime+1
            threshold = 0
            y_pred = self.predict(Sample[test],threshold)
            # print(sam[:,0],tar)
            for featureIndex in [40,45,50,55,60,65,70,75,5,10,15,20,25,30,35]:
                plt.plot(sam[:,featureIndex])
                plt.plot(tar)
                plt.title("split "+str(testTime)+" feature "+str(featureIndex))
                plt.show()
                command = input("continue featureIndex++ ?  y or n")
                if command == 'N' or command == 'n':
                    break;
            command = input("continue split++?  y or n")
            if command == 'N' or command == 'n':
                break;
            
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


"""threshold_evaluate
    阈值多类 分类器
    实现 0, 1, 2, 3
"""
class Multithreshold_result:


    def __init__(self,threshold, stepbystep=0):
        self.classname = 'Algorithms_result'
        self.Algorithms = []        # 算法对象存储
        self.num = 0                # 算法数量
        self.index = 1              # 结果条数记录
        self.timecosts = []         # 算法耗时
        self.precise_average = []   # 平均精度
        self.precise_variance = []  # 平均方差
        self.precise_view = []      # 十次交叉验证的精度数值
        self.precise_view = []      # 十次交叉验证的精度数值
        self.pred = []              # 算法的预测分类结果
        self.truth = []             # 真实值
        self.stepbystep = stepbystep             # 单步运行
        self.threshold = threshold


    # 阈值分类算法
    def predict(self, test, length, method = 0):
        
        
        list = []
        # print(length,test.shape)
        for i in range(length):
            sample = test[i,:]
            
            self.thresMethod(sample, list)
            
        # plt.plot(test[:,5])
        # plt.show()
        # print("list",len(list))
        return list;


    """
    testTime - 测试算法预测时间时，重复测试取平均的次数
    all      - 是否循环预测所有的splitMethod划分结果，如果是1，testTime设置循环预测的次数
    splitMethod - 数据集划分方法
    sampl - 样本数据
    """
    def compare(self, sampl, splitMethod, all = 0, featureIndex = 0, testTime = 5):
        print("------------------------compare---------------------------\n")
        BestOne = Best()
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        command = 'y'
        
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        
        self.truth = y_test
        
        # 预测时间的测试
        print("compare : 特征向量长度：", target_list)
        
        if all == 0 :   # 用于计算耗时，以及获取混淆矩阵
            print("compare : all is 0")
            time_start=time.time()
            for iter in range(0, testTime):
                y_pred = self.predict(X_test, len(y_test))
            time_end=time.time()
            
            self.pred.append(y_pred)
            # 本次预测的评价
            print("true",y_test,len(y_test),len(X_test))
            print("pred",y_pred,len(y_pred))
            
            print('classification_report : \n',classification_report(y_test, y_pred))
            print('confusion_matrix : \n',confusion_matrix(y_test, y_pred, labels = [0,1,2,3]), '\n\n\n')
            self.timecosts.append((time_end-time_start)*1000/testTime) # ms
            
        else :          # 用于计算以每组作为训练集的精度
            print("compare : all is 1")
            testTime=0
            for train, test in splitMethod.split(Sample, target):
                sam = Sample[test]
                tar = target[test]
                
                truth = tar
                
                y_pred = self.predict(sam, len(test))
                # print(y_pred)
                # 存储数据
                self.pred = np.append(self.pred, y_pred)
                self.truth = np.append(self.truth, truth)
                # print(sam[:,0],tar)
                # 本次预测的评价
                # print('classification_report : \n',classification_report(truth, y_pred))
                # print('confusion_matrix : \n',confusion_matrix(truth, y_pred), '\n\n\n')
                self.precise_view.append(sum(y_pred==truth)/len(truth))
                    
        return BestOne


    """
    人眼观察不同标签的特征值，提取阈值
        splitMethod - 划分训练集和测试集的方式
        sampl - 所有样本
        featIndex - 需要提取阈值的特征list
        绘制在某次划分结果的train中的某个特征值，进行阈值提取，从而编写 thresMethod ，调用 addThresMethod 传入类中使用
    
    返回：获取阈值的训练集和测试集
    """
    def getthreshold(self, sampl, splitMethod, featIndex = [1,2]):
        
        print("------------------------getthreshold and train/test samples-------------------------\n")
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        print("样本特征维度：",len(Sample[0]))
        
        testTime = 0
        for train, test in splitMethod.split(Sample, target) :
        
            print("train",len(train),'   ',"test",len(test))
            
            sam = Sample[train]
            tar = target[train]
            testTime = testTime+1
            
            # 绘制特征图 + 分类结果
            for featureIndex in featIndex :
            
                plt.plot(sam[:,featureIndex])
                plt.plot(tar)
                plt.title("split "+str(testTime)+" feature "+str(featureIndex))
                plt.show()
                
                # 找到阈值后可中断执行
                command = input("continue featureIndex++ ?  y or n")
                if command == 'N' or command == 'n':
                    return sam, tar, Sample[test], target[test];
                    
            command = input("continue split ++?  y or n")
            if command == 'N' or command == 'n':
                break;


    """
    添加外部自定义的 <<阈值预测函数>>.
        Method - 阈值预测函数指针
    被调用：predict
    """
    def addThresMethod(self, Method):
        self.thresMethod = Method


    """
    评价阈值函数。
        输出两个方面评价： 人工获取的训练集上的precision，预测集上的precision
        Sampl_ToGetThres - 注意必须是训练获得评价阈值函数的样本
    调用：predict
    """
    def threshold_evaluate(self, Sampl_ToGetThres):
        print("------------------------threshold_evaluate---------------------------")
        print("Sampl_ToGetThres : ",Sampl_ToGetThres[0].shape)
        
        pred = self.predict(Sampl_ToGetThres[0],len(Sampl_ToGetThres[1]))
        feature = Sampl_ToGetThres[0]
        plt.plot(feature[:,5+(2-1)*8])
        plt.plot(Sampl_ToGetThres[1])
        plt.plot(pred)
        plt.show()
        print("threshold 对训练集的精度：", sum(pred==Sampl_ToGetThres[1])/len(Sampl_ToGetThres[1]))
        
        pred = self.predict(Sampl_ToGetThres[2],len(Sampl_ToGetThres[3]))
        print("threshold 对测试集的精度：", sum(pred==Sampl_ToGetThres[3])/len(Sampl_ToGetThres[3]))


    def showplt_precise_average(self):
        print("------------------------showplt_precise_average---------------------------")
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.precise_average,fc='r')
        plt.ylabel('precise_average')
        plt.show()


    def showplt_precise_variance(self):
        print("------------------------showplt_precise_variance---------------------------")
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.precise_variance,fc='r')
        plt.ylabel('precise_variance')
        plt.show()


    def showplt_timecosts(self):
        print("------------------------showplt_timecosts---------------------------")
        print("plot timecost bar diagram ... ")
        import matplotlib.pyplot as plt
        plt.bar(range(1,self.index+1), self.timecosts,fc='r')
        plt.ylabel('timecosts')
        plt.show()


    def showplt_precise_view(self):
        print("------------------------showplt_precise_view---------------------------")
        print("plot boxplot diagram ... ")
        import matplotlib.pyplot as plt
        plt.boxplot(self.precise_view)
        plt.show()


    """agorithm_index 序号从零开始"""
    def showplt_prediction(self, agorithm_index):
        print("------------------------showplt_prediction---------------------------")
        predict = self.pred[agorithm_index]
        plt.plot(prediciton ,c='r')
        plt.plot(self.truth,c='b')
        plt.show()

    """
    打印所有的类信息
    """
    def showmessage(self):
        print("------------------------showmessage---------------------------")
        print(self.classname,'-compare-','timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print(self.classname,'-compare-','precise view',self.precise_view)
        print(self.classname,'-compare-','precise_variance',self.precise_variance,'\n')



