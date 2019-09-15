
1. 4-Serial.GUI/分类模型训练/Prehandle_Data.m 从采样的数据中特征提取，生成 *.mat

2. train_model.py 利用*.mat 建立模型，并训练，训练数据存储于 *.txt

3. model.py 利用*.txt 进行分类预测

4. Model_py.m 可以使用model.py进行数据预测，也可以使用MATLAB自己的模型进行预测，此时的预测时间较短。

5.模型的数据存放在分类模型文件夹中

6.serial_GUI 是调用这些文件的一个GUI平台
