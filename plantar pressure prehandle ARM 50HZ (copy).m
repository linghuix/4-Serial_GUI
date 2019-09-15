%{
分析：
1. 前脚掌的压力波动较小，后脚跟受力较大，波动剧烈
%}

cd 'F:\1-embed\5-ARM\Small_50Hz_fig'
Fs = 50                         % Hz

%%选择传感器块
a = [7 8];
row = a(1);                     % 行
col = a(2);                     % 列

%%数据加载
normal = load('test_filiter_dynamic_20190508T221417.mat');
index = 1:1400;         %序号下标

%%化为实际的电压
normal.data = normal.data./4095*3.3;
normal.after = normal.after./4095*3.3;
normal.y = normal.y./4095*3.3;

figure(1);                      % 原始数据图
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%数据全景图

figure(3)                       % 上半部为原始序列下标图，下半部为滤波后对应的图
subplot 211
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%数据index选择图
subplot 212
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%滤波数据index选择图

% normal.index = index;
% % normal.fft = abs(fft(reshape(normal.data(row,col,index),1,length(index))))
% figure(4)
% plot(log10(abs(fft(reshape(normal.data(row,col,index),1,length(index))))))  %%傅里叶变化对数图
% axis([1 inf 0 Inf])

figure(4)                       % 频率幅值图
normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index));
% y = y/A.A(a(1),a(2));
y_after = reshape(normal.after(row,col,index),1,length(index));
% y_after = y_after/A.A(a(1),a(2));

NFFT = 2^nextpow2(length(normal.index))        % 频率图的点数
A = abs(fft(y,NFFT));                           % 频域幅值
f = Fs/2*linspace(0, 1, NFFT/2);                % 采样点数决定了频率分辨力
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.r');                          % 红色，原始数据
title('真实频谱，幅值为该频率正弦波对应的幅值')

hold on
% subplot 212
A = abs(fft(y_after,NFFT));                     % 频域幅值
f = Fs/2*linspace(0, 1, NFFT/2);                % 采样点数决定了频率分辨力
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.g');                          % 绿色，滤波
title('真实滤波后频谱，幅值为该频率正弦波对应的幅值')