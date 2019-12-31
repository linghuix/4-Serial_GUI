
1. serial_GUI.fig/serial_GUI.m

保存的数据 - data[i,j,Frame]

i,j 是传感器块的序号        Frame为一帧数据

2. static/Model_py.m

输入特征值，调用 python 文件 model.py 进行预测

3. 数据阅读器.m

用图像的形式显示数据曲线

4. static/ARM_50HZ.m

处理静态足底压力的原始数据。得到特征值样本集合

5. 

