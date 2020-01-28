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
from sklearn.model_selection import StratifiedKFold

from sklearn.metrics import classification_report   # 评价分类的好坏（精确度,召回率,F1）
from sklearn.metrics import confusion_matrix        # 评价分类的好坏

import time                                         # 计算程序运行时间

import scipy.io as sio                              # 读取数据包

import pickle                                       # pickle模块主要函数的应用举例 

sys.path.append(r'D:\1-embed\4-Serial_GUI\分类模型训练\module')
import Algori_Compare as my

# 阈值预测函数
# 通过阈值得到不同的分类结果函数
def thresMethod(sample, list) :
    
    # label 0
    # if( (sample[4+(2-1)*8] > 17 or 14<sample[4+(2-1)*8]<14.8) and (14.3 < sample[5+(2-1)*8] < 14.8 or 17.9 < sample[5+(2-1)*8] < 18.6) and 19.7<sample[2+(5-1)*8]<21.3 and 17.8<sample[6+(6-1)*8]<19.2 and (18.5<sample[2+(4-1)*8]<19.5 or 14.51<sample[2+(4-1)*8]<14.84 or 15.47<sample[2+(4-1)*8]<15.55) and (17<sample[2+5*8]<18.5 or 19.1<sample[2+5*8]<20) ) :
        # list.append(0)
        # return
    
    # label 1
    # if ( (13.37<sample[3+1*8]<14.78 or 14.32<sample[3+1*8]<14.525) and 13.35<sample[5+1*8]<15 and (13.2<sample[2+3*8]<17.69) and (19.46<sample[2+4*8]<22.28) and(18.79<sample[3+5*8]<21.6) and (18.62<sample[6+5*8]<21.2) ) :
        # list.append(1)
        # return
    
    # label 0
    if( (sample[12] > 17 or 14<sample[12]<14.8) and (14.3 < sample[13] < 14.8 or 17.9 < sample[13] < 18.6) and 19.7<sample[34]<21.3 and 17.8<sample[46]<19.2 and (18.5<sample[26]<19.5 or 14.51<sample[26]<14.84 or 15.47<sample[26]<15.55) and (17<sample[42]<18.5 or 19.1<sample[42]<20) ) :
        list.append(0)
        return
    
    # label 1
    if ( (13.37<sample[11]<14.78 or 14.32<sample[11]<14.525) and 13.35<sample[13]<15 and (13.2<sample[26]<17.69) and (19.46<sample[34]<22.28) and(18.79<sample[43]<21.6) and (18.62<sample[46]<21.2) ) :
        list.append(1)
        return
        
    return list.append(2)
    
    
"""
人体站立下的足外翻、足内翻、正常的分类
相同样本，不同的算法之间的分类精度比较。
"""

if __name__=="__main__":
    
    pcaNum     = 7   # 降维后的维度
    ldaNum     = 4   # 训练数据量
    cross_test = 0   # 是否需要十次交叉验证
    save       = 0
    
    
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
    result = my.Multithreshold_result(0)
    
    
    # 数据载入
    dir  = r'D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\sample5.mat'
    data = sio.loadmat(dir)
    data = data['sample']
    
    # 划分方法
    skf  = StratifiedKFold(n_splits=10)
    
    # 添加阈值预测方法
    result.addThresMethod(thresMethod)
    
    # 肉眼观察 get threshold 
    index = [5+(5-1)*8, 6+(6-1)*8, 3+(2-1)*8, 4+(2-1)*8, 5+(2-1)*8,2+(4-1)*8, 2+(5-1)*8, 2+(6-1)*8, 3+(6-1)*8]
    train_data = result.getthreshold(data, skf, index)
    result.threshold_evaluate(train_data)
    
    # 预测
    good = result.compare(data, skf, 0)
    
    # 结果
    result.showplt_precise_view()
    result.showplt_timecosts()
    result.showmessage()
