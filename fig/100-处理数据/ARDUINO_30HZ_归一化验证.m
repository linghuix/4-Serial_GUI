%{
分析：
数据的归一化验证
%}
cd 'F:\1-embed\4-Serial_GUI\fig\'

A = load('F:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat');
Fs = 30; % Hz

a = [5 5];                                                      %% 选择传感器块
row = a(1);col = a(2);
% b = [1 256];

A = load('F:\1-embed\4-Serial_GUI\fig\1.mat');                     %% 数据加载
B = load('F:\1-embed\4-Serial_GUI\fig\ping4.mat');

lengthA = size(A.normal.after,3)                                 %% 数据长度信息
lengthB = size(B.normal.after,3)

serial_A = reshape(A.normal.after(row,col,:),1,lengthA);         %% 得到数据数组
serial_B = reshape(B.normal.after(row,col,:),1,lengthB);

% serial_A = (serial_A-mean(serial_A))/sqrt(var(serial_A,1));                             %% 归一化
% serial_B = (serial_B-mean(serial_B))/sqrt(var(serial_B,1));
j = abs(fft(serial_A))
serial_A = serial_A/mean(serial_A);                             %% 归一化
serial_B = serial_B/mean(serial_B);
k = abs(fft(serial_A))

figure(1);
plot(serial_A);                                                 %% 数据全景图
hold on
plot(serial_B)

%%
figure(2)                                                                   %%傅里叶变化对数图
normal.index = index;
% y = reshape(normal.data(row,col,index),1,length(index))-140;
% y = y/A.A(a(1),a(2));
% y_after = reshape(normal.after(row,col,index),1,length(index))-140;
% y_after = y_after/A.A(a(1),a(2));

NFFTA = 2^nextpow2(lengthA);        % 频率图的点数
NFFTB = 2^nextpow2(lengthB);        % 频率图的点数

A_A = abs(fft(serial_A,NFFTA));                    % 频域幅值
A_B = abs(fft(serial_B,NFFTB));

f_A = Fs/2*linspace(0, 1, NFFTA/2);                % 采样点数决定了频率分辨力
f_B = Fs/2*linspace(0, 1, NFFTB/2);

A_A = [A_A(1)  2*A_A(2:NFFTA/2)]./NFFTA;
A_B = [A_B(1)  2*A_B(2:NFFTB/2)]./NFFTB;

stem(f_A,A_A,'.r');hold on;
stem(f_B,A_B,'.b');
