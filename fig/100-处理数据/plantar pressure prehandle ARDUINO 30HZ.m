%{
分析：
1. 前脚掌的压力波动较小，后脚跟受力较大，波动剧烈
2. 选择比较完整的足底压力曲线 index 段，将normal保存到本地，该结构体包括 采集时曲线显示数据y，滤波数据after，原始数据data，index数据
%}

A = load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat')
Fs = 30                         % Hz

%%选择传感器块
a = [1 1];
row = a(1);
col = a(2);

% row = 5;
% col = 4;

% % index = 1300:1800;
index = 200:500
%%数据加载
normal = load('D:\1-embed\4-Serial_GUI\fig\2-subject1\girl_扁平足，内八字 20190418T104147.mat');
% index = 1400:2500; normal = load('C:\Users\xlh\Desktop\fig\subject2\girl_扁平足_20190507T093304.mat');


figure(1);
subplot 211
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%数据全景图
subplot 212
plot(reshape(normal.after(row,col,:),1,size(normal.after,3)))
title('数据全景图')


figure(3)
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%数据index选择图
hold on
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%滤波数据index选择图
legend('原始数据','滤波后的数据')
title('数据index选择图')

% normal.index = index;
% % normal.fft = abs(fft(reshape(normal.data(row,col,index),1,length(index))))
% figure(4)
% plot(log10(abs(fft(reshape(normal.data(row,col,index),1,length(index))))))%%傅里叶变化对数图
% axis([1 inf 0 Inf])


figure(4)                                                                   %%傅里叶变化对数图

normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index))-140;
y = y/A.A(a(1),a(2));
y_after = reshape(normal.after(row,col,index),1,length(index))-140;
y_after = y_after/A.A(a(1),a(2));

NFFT = 2^nextpow2(length(normal.index));        % 频率图的点数
A = abs(fft(y,NFFT));                           % 频域幅值
f = Fs/2*linspace(0, 1, NFFT/2);                % 采样点数决定了频率分辨力
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.r');
title('真实频谱，幅值为该频率正弦波对应的幅值')

hold on
A = abs(fft(y_after,NFFT));                           % 频域幅值
f = Fs/2*linspace(0, 1, NFFT/2);                %采样点数决定了频率分辨力
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.b');
title('真实滤波后频谱，幅值为该频率正弦波对应的幅值')


%% 标准化后的数据
a = [5 3];
row = a(1);
col = a(2);
A = load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat')
figure(10);
% G = (normal.data(row,col,:)-140)/A.A(row,col)
G = (normal.after(row,col,:)-140)/A.A(row,col)
plot(reshape(G,1,size(normal.data,3)));                %%数据全景图
