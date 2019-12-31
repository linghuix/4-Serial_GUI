# -- codin  g: utf-8 --

import sys                              # tO READ ARGUMENTS FROM CMD/SHELL

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
    
    def __init__(self):
        self.Algorithms = []
        self.num = 0
        self.timecosts = []
        self.precise_average = []
        self.precise_variance = []
        self.precise_view = []
    
    """sample - list类型 横向为一个样本，最后一列为分类值"""
    def addAlgorithm(self,Algorithm):
        self.Algorithms.append(Algorithm)
        self.num += 1
    
    def compare(self,sampl):
        target_list = sampl.shape[1]-1       # target 为标签,Sample横向量为一个样本
        target = sampl[:,target_list]        # 目标分类值
        Sample = sampl[:,:target_list]
        # 划分训练集和测试集
        X_train, X_test, y_train, y_test = train_test_split(Sample, target, test_size=0.3, random_state = 42)
        
        for i in range(0, self.num):# 0 - modelnum-1
        
            Algori = self.Algorithms[i]
            Algori.fit(X_train,y_train)
            
            # 预测时间的测试
            time_start=time.time()
            for iter in range(0, 100):
                y_pred = Algori.predict(X_test)
            time_end=time.time()
            
            print("算法：", Algori)
            # 模型的评价指标测试
            this_scores = cross_val_score(Algori, Sample, target, cv = 10);
            
            self.timecosts.append((time_end-time_start)*1000/100) # ms
            self.precise_average.append(this_scores.mean())
            self.precise_variance.append(this_scores.std())
            self.precise_view.append(this_scores.view())
            #input('next?')
    
    def showmessage(self):
        print('timecosts : ',self.timecosts,'\n','precise_average : ',self.precise_average,'\n')
        print('precise view',self.precise_view)
        print('precise_variance',self.precise_variance,'\n')

        
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
    
    # 论文表格 4.2 中的序号
    # N0.4
    pipe_svm1 = Pipeline([('lda', transform_lda), ('svc', clf_rbfsvm1)])
    # N0.3
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
    
    
    # 类的初始化
    result = Algorithms_result()
    
    algorithm = [pipe_svm1, pipe_svm2, pipe_svm3, pipe_svm4, pipe_svm5, clf_rbfsvm1, clf_linsvm2, transform_lda]
    for algorithmIndex in range(len(algorithm)):
        algori = algorithm[algorithmIndex]
        result.addAlgorithm(algori) # array object
        
        
    dir = 'D:\\1-embed\\4-Serial_GUI\\分类模型训练\\tmp\\features-2.mat'
    data = sio.loadmat(dir)
    result.compare(data['group'])
        
    # 计算和显示结果
    result.showmessage()
    result.showplt_precise_average()
    result.showplt_precise_variance()
    result.showplt_timecosts()
    result.showplt_precise_view()

