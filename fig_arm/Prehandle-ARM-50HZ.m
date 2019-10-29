
%{
分析：
1. 前脚掌的压力波动较小，后脚跟受力较大，波动剧烈
2. 选择比较完整的足底压力曲线 index 段，将normal保存到本地，该结构体包括 采集时曲线显示数据y，滤波数据after，原始数据data，index数据
%}

A = load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat');
Fs = 50;                         % Hz

cd 'D:\1-embed\4-Serial_GUI\fig_arm'

%%选择传感器块
a = [5 5];
row = a(1);
col = a(2);

index = 100:1200;

%%数据加载
normal = load('D:\1-embed\4-Serial_GUI\fig_arm\Small_50Hz_fig\nor_20190919T151612.mat');


figure(1);
subplot 211
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%数据全景图
subplot 212
plot(reshape(normal.after(row,col,:),1,size(normal.after,3)))
title('数据全景图')


figure(2)
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%数据index选择图
hold on
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%滤波数据index选择图
legend('原始数据','滤波后的数据')
title('数据index选择图')



figure(4)                                                                   %%傅里叶变化对数图

normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index));
y_after = reshape(normal.after(row,col,index),1,length(index));

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

row = a(1);
col = a(2);
AAA=[
  776 770 1120 1227 1252 1252 960 800;
  740 930 1126 1234 1250 1256 965 800;
  790 920 1200 950 1250 1250 960 790;
  780 944 930 1226 1250 1250 960 795;
  715 944 1150 1111 1180 850 890 730;
  715 870 1145 1157 850 1183 850 727;
  725 870 1147 1160 1185 1100 890 650;
  715 870 1145 1160 1185 1185 780 730];
  
figure(5)

for j = normal.index
    imshow(imresize(normal.after(:,:,j)-AAA,50,'nearest'),[-10 600]); 
    drawnow limitrate         
    %F(j) = getframe;
end

close figure 5
