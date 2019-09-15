
%{
分析：
1. 前脚掌的压力波动较小，后脚跟受力较大，波动剧烈
2. 选择比较完整的足底压力曲线 index 段，将normal保存到本地，该结构体包括 采集时曲线显示数据y，滤波数据after，原始数据data，index数据
%}

A = load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat');
Fs = 50;                         % Hz

%%选择传感器块
a = [5 5];
row = a(1);
col = a(2);

% % index = 1300:1800;
index = 200:1000;
%%数据加载
normal = load('D:\1-embed\4-Serial_GUI\fig_arm\Small_50Hz_fig\Toeout_20190915T235236.mat');


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
% A =  [743 752 1210 1210 1180 1170 886 723
%       705 910 1105 1205 1180 1170 885 723
%       740 875 1210 880 1180 1170 885 726
%       740 900 960 1202 1120 1160 878 725
%       740 905 1206 1175 1175 850 875 726
%       740 905 1205 1205 955 1162 815 727
%       740 900 1206 1206 1176 1110 880 648
%       742 902 1205 1207 1178 1160 788 725];
A = [ 660 570 1050 1160 1180 1180 895 730;
      650 570 1080 1150 1180 1180 890 723;
      650 570 1080 795 1180 1180 890 730;
      645 570 780 1150 1137 1180 890 730;
      660 570 1080 1111 1180 850 890 730;
      715 820 1145 1157 850 1183 850 727;
      725 870 1147 1160 1185 1100 890 650;
      715 860 1145 1160 1185 1185 780 730;]
  
figure(5)

for j = normal.index
    imshow(imresize(normal.after(:,:,j)-A,50,'nearest'),[-10 600]); 
    drawnow limitrate         
    %F(j) = getframe;
end

close figure 5
