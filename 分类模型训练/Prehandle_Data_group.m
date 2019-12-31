
clc;clear all

NORMAL  = 0;
% ABNORMAL= 5;                % 不正常步态
TOEIN   = 1;                % 足内旋
TOEOUT  = 2;                % 足外旋
PING    = 3;                % 扁平足
% GAO     = 4;                % 高弓足
STATIC  = 6;

% % load the original data ---- normal struct
% dir = 'D:\1-embed\4-Serial_GUI\fig\';
% suffix = '.mat';

% load the calibrating data -----normal struct
dir = 'D:\1-embed\4-Serial_GUI\fig\';
suffix = '.mat';

%% python程序钩子功能设定
lcaNum = 4;
pcaNum = lcaNum;    % 降维后的维度  0.9898
cross_test = 1; % 是否需要十次交叉验证

%%---------------------------------------------------

n = 2^8;        % 分类原始时域数据数据长度256
N = 10;         % 0-10Hz
sample = [];    % 形成一个样本点，一行为一个样本点
Fs = 30;        % Hz

% 字符可以看做是一个数组，所以不能直接用空格建立字符串数组，只能建立cell
name = {'1','2','3','4','adult_gril_nor2'...
        ,'tin_1','adult_gril_toein1','adult_gril_toein2',...
        'tout_1','tout_2' ,'adult_gril_toeout1','adult_gril_toeout2' ,...
        's1','s2',...
        'ping1-1','ping2-1','ping3-1','ping1-2','ping2-2','ping3-4','ping4-4'};
Label = [NORMAL NORMAL NORMAL NORMAL NORMAL...
        TOEIN TOEIN TOEIN TOEOUT TOEOUT TOEOUT TOEOUT...
        STATIC STATIC...
        PING PING PING PING PING PING PING];

%     数据所属的人的编号
individual = [1 1 1 1 2 ...
            3 4 4 ...
            5 5 6 6 ...
            7 8 ...
            9 9 9 10 10 11 11];

group_individual = []   % 记录数据对应的人的编号
group = [];             % 训练数据
for name_index = 1:length(name)
    
    this_individual =[];
    gro = individual(name_index);                  % 组别，individual
    
    dir_name = [dir char(name(name_index)) suffix]  % cell 转化为 char字符类型
    load(dir_name);                                 % 根据 name_index, 选择加载的数据集 normal
    label = Label(name_index);                      % label 根据 name_index 变化

    sample = [];
    for i = normal.index(1):(normal.index(1)+length(normal.index))
        
        coef = [];
        
        if((i+n) >(normal.index(1)+length(normal.index)))      % index数据不够长时
            break
        end
        
        % 多个传感器块串起来
%         Row = [8 8 7 7 1   1 2 3 4 5 6];
%         Col = [1 2 1 2 7   8 7 6 5 4 3];
        Row = [1 2 3 4 5 3 4 5 2 6 4 5 7 5 7 8];
        Col = [7 7 7 7 7 6 6 6 5 5 4 4 4 3 3 1];
        merge_R = [8 7 7];
        merge_C = [2 1 2];

%           Row = [1]
%           Col = [1]
        for row_col = 1:length(Row) 
            
            row = Row(row_col);
            col = Col(row_col);
            
            if row ~= 8
                ser = reshape(normal.after(row,col,i:i+n-1),1,n);% 某个传感器的时间序列
                serial = ser/mean(ser);
            else
                ser = reshape(normal.after(row,col,i:i+n-1),1,n);% 某个传感器的时间序列
                for ii = 1:length(merge_R)
                    ser = ser + reshape(normal.after(merge_R(ii),merge_C(ii),i:i+n-1),1,n);
                end
                ser = ser/4;
                serial = ser/mean(ser);
            end
                
            %%傅里叶系数计算
            NFFT = 2^nextpow2(n);                      % 频率图的点数
            A = abs(fft(serial,NFFT));                 % 频域幅值
            f = Fs/2*linspace(0, 1, NFFT/2);            % 采样点数决定了频率分辨力
            A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;
            % stem(f,A_f/NFFT,'.b');
            
%             temp = [A_f(f == 0) sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
            temp = [sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
            coef = [coef temp];                                         % 多个传感器块串起来
        end
        
        sample = [sample;coef label];
    end
    group = [group; sample];
    
    sample_size = size(sample,1)
    this_individual = ones(1, sample_size)*gro;
    group_individual = [group_individual , this_individual];    % 添加group编号
end

group_size = size(group)

fprintf('-----------------\n样本集信息：\n类别\t数目\n');

for class=0:3
    num = sum(group(:,end)==class);
    fprintf('%d\t%d\n',class,num)
end

save('D:\1-embed\4-Serial_GUI\分类模型训练\tmp\features.mat','group');         % 行 为一个样本
save('D:\1-embed\4-Serial_GUI\分类模型训练\tmp\group.mat','group_individual');
%% 模型直接进行训练
% clc
cd 'D:\1-embed\4-Serial_GUI\分类模型训练\'
% save = 0;
save = 1;
cali_dir = 0;
ss = sprintf('python train_model_group.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout，收集所有的cmd窗口的输出，为字符串格式
[status,cmdout] = system(ss)          % 等待python执行完毕

%% 模型预测
%{

n = 2^8;

NFFT = 2^nextpow2(length(normal.index));                    % 频率图的点数
A = abs(fft(serial(normal.index),NFFT));                    % 频域幅值
f = Fs/2*linspace(0, 1, NFFT/2);                            % 采样点数决定了频率分辨力
A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;
sent_data = [A_f(f == 0) sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];

%}
%%
% clc;
cd 'D:\1-embed\4-Serial_GUI\分类模型训练'
% line = 3370
line = unidrnd(size(group,1))                              % 随机产生一个正整数
sent_data = group(line,1:(end-1));

s_sent_data = sprintfc('%g',sent_data);                     % 数字数组转化成字符串数组
s = s_sent_data(1);
for i = 2:length(sent_data)
     s = strcat(s,',', s_sent_data(i));                     % 得到的s是一个cell，所以下文必须用s{1}
end
command = sprintf('python model.py "%s" %d',char(s),cali_dir)
[status,cmdout] = system(command);


% this python model has warning ,so we need to pick the result out cmdout(end-4:end)
real = group(line,end)
pre = str2num(cmdout(end-4:end))
if(real == pre)
    fprintf('OK')
else
    fprintf('BAD')
end
%}
