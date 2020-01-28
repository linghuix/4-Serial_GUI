%{
静态的足底压力分类
%}

clc
clear all
NORMAL  = 0;
TOEIN   = 1;                % 足内旋
TOEOUT  = 2;                % 足外旋

name = {'Toein-2','Toein-1','Toein-11','Toein-111','Toein-222'...
        ,'Toeout-3','Toeout-1','Toeout-2','Toeout-11','Toeout-111','Toeout-222'...
        ,'normal-111','normal-1','normal-11','normal-222'...
        };
    
% name = {'Toein-200105-2','Toein-200105-1', 'normal-200105-2', 'normal-200105-1'
%         };

    
%标签
Label = [TOEIN TOEIN TOEIN TOEIN TOEIN ...
        TOEOUT TOEOUT TOEOUT TOEOUT TOEOUT TOEOUT  ...
        NORMAL NORMAL NORMAL NORMAL];
    
% Label = [TOEIN TOEIN NORMAL NORMAL];
%% 读取足压补偿数据
% A = load('D:\1-embed\xxx.mat')


%% 选择传感器块
% a = [1 1];
% row = a(1);
% col = a(2);

%% 读取足压数据， 数据加载
% normal = load('D:\1-embed\4-Serial_GUI\fig\Static_ARM\1.mat');
% AAA=[
%   776 770 1120 1227 1252 1252 960 800;
%   740 930 1126 1234 1250 1256 965 800;
%   790 920 1200 950 1250 1250 960 790;
%   780 944 930 1226 1250 1250 960 795;
%   715 944 1150 1111 1180 850 890 730;
%   715 870 1145 1157 850 1183 850 727;
%   725 870 1147 1160 1185 1100 890 650;
%   715 870 1145 1160 1185 1185 780 730];
% AAA = load('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\AAAoffset.mat');

dir = 'D:\1-embed\4-Serial_GUI\fig_arm\';

Avr = 2;           % 用于平均的长度
sample = [];        % 样本集合
for name_index = 1:length(Label)
    dir_name = [dir char(name(name_index)) '.mat']      % cell 转化为 char字符类型
    fprintf('reading %s ...\n',dir_name);
    load(dir_name);                                     % 加载原始数据
    
    for i = normal.index(1):Avr:(normal.index(end)-Avr) % 
        SUM = 0;    % 求和
        for j = i:i + Avr
            SUM = SUM + normal.after(:,:,j);% - AAA.AAA;
        end
        avr = SUM / Avr;
        
%         for enhance = 1:10      % 数据增强
            sample = [sample;reshape(avr,1,64)/sum(reshape(avr,1,64)) Label(name_index)];
%         end
    end
    fprintf('OK!\n',dir_name);
end

sam = sample(:,1:end-1);
sum_col = sum(sam,2);% 一个样本所有元素之和
for i = 1:size(sum_col,1)
   sample(i,1:end-1) =  sam(i,:)*1000.0/sum_col(i);
%    new_sample(:,i) =  sample(:,i)*100.0./sum_col(i);
end

% sample = new_sample;
%% 保存样本数据
save('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\sample.mat','sample');
save('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\sum_col.mat','sum_col');
% save('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\AAA.mat','AAA');

%% 调用 train_model.py 程序 模型直接进行训练------------------------
cd 'D:\1-embed\4-Serial_GUI\2-ARM小体积\static\'
pcaNum = 10;
cross_test = 1;
% save = 0; 
save = 1;
cali_dir = 0;

ss = sprintf('python train_model.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout，收集所有的cmd窗口的输出，为字符串格式
[status,cmdout] = system(ss)% 等待python执行完毕





