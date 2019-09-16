

%{
分析：
1. 通过选取的数据，利用滑窗的方法进行平均
2. 然后展平8x8的矩阵

%}

clc
clear all
NORMAL  = 0;
TOEIN   = 1;                % 足内旋
TOEOUT  = 2;                % 足外旋

name = {'Toein-11'...
        ,'Toeout-11'...
        ,'normal-11'...
        };
%标签
Label = [TOEIN ...
        TOEOUT  ...
        NORMAL];

%% 读取足压补偿数据
% A = load('D:\1-embed\xxx.mat')


%% 选择传感器块
% a = [1 1];
% row = a(1);
% col = a(2);

%% 读取足压数据， 数据加载
% normal = load('D:\1-embed\4-Serial_GUI\fig\Static_ARM\1.mat');
AAA=[
  720 730 1150 1160 1180 1180 895 730;
  670 870 1060 1150 1180 1180 890 723;
  720 840 1150 795 1180 1180 890 730;
  722 867 840 1150 1137 1180 890 730;
  715 870 1150 1111 1180 850 890 730;
  715 870 1145 1157 850 1183 850 727;
  725 870 1147 1160 1185 1100 890 650;
  715 870 1145 1160 1185 1185 780 730];

dir = 'D:\1-embed\4-Serial_GUI\fig_arm\';

Avr = 100;
sample = [];
for name_index = 1:length(Label)
    dir_name = [dir char(name(name_index)) '.mat'];      % cell 转化为 char字符类型
    fprintf('reading %s ...\n',dir_name);
    load(dir_name);
    
    for i = normal.index(1):(normal.index(end)-Avr)
        SUM = 0;
        for j = 1:Avr
            SUM = SUM + normal.data(:,:,j)-AAA;
        end
        avr = SUM/Avr;
        sample = [sample;reshape(avr,1,64) Label(name_index)];
    end
    fprintf('OK!\n',dir_name);
end

%% 保存样本数据
save('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\sample.mat','sample');

%% 调用 train_model.py 程序 模型直接进行训练------------------------
cd 'D:\1-embed\4-Serial_GUI\2-ARM小体积\static\'
pcaNum = 10;
cross_test = 1;
% save = 0; 
save = 1;
cali_dir = 0;

ss = sprintf('python train_model.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout，收集所有的cmd窗口的输出，为字符串格式
[status,cmdout] = system(ss)          % 等待python执行完毕