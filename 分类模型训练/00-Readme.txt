
同一人的简单预测
1. Prehandle_Data.m 从采样的数据中特征提取，生成 tmp/group.mat。并且可以调用train_model.py和model.py进行初步的训练和预测。

2. train_model.py 利用 /tmp/group.mat 建立模型，并训练，训练模型数据存储于 tmp/ModelFile.txt

3. model.py 利用 ModelFile.txt 进行分类预测

4. multi_training_model.py 调用*.mat，建立大量的分类模型进行评估，选择最优的训练模型，生成*.txt


不同人的预测
5. train_model_group.m/train_model_group.py 将同一个人的步态数据看成是一组，去预测另一组的数据，事实证明，该算法在这种情况下效果很烂。


数据样本生成
5. Prehandle_CaliData.m 从标定的数据中(fig\calibration\)特征提取，生成 *.mat。并且可以调用train_model和model进行初步的训练和预测

CALI的数据由./fig/100-处理数据/calibration.m 生成
arduino_data 30Hz 由 plantar pressure prehandle ARDUINO 30HZ - 副本.m 生成

