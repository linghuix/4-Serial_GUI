%{
��̬�����ѹ������
%}

clc
clear all
NORMAL  = 0;
TOEIN   = 1;                % ������
TOEOUT  = 2;                % ������

name = {'Toein-2','Toein-1','Toein-11','Toein-111','Toein-222'...
        ,'Toeout-3','Toeout-1','Toeout-2','Toeout-11','Toeout-111','Toeout-222'...
        ,'normal-111','normal-1','normal-11','normal-222'...
        };
    
% name = {'Toein-200105-2','Toein-200105-1', 'normal-200105-2', 'normal-200105-1'
%         };

    
%��ǩ
Label = [TOEIN TOEIN TOEIN TOEIN TOEIN ...
        TOEOUT TOEOUT TOEOUT TOEOUT TOEOUT TOEOUT  ...
        NORMAL NORMAL NORMAL NORMAL];
    
% Label = [TOEIN TOEIN NORMAL NORMAL];
%% ��ȡ��ѹ��������
% A = load('D:\1-embed\xxx.mat')


%% ѡ�񴫸�����
% a = [1 1];
% row = a(1);
% col = a(2);

%% ��ȡ��ѹ���ݣ� ���ݼ���
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
% AAA = load('D:\1-embed\4-Serial_GUI\2-ARMС���\static\data\AAAoffset.mat');

dir = 'D:\1-embed\4-Serial_GUI\fig_arm\';

Avr = 2;           % ����ƽ���ĳ���
sample = [];        % ��������
for name_index = 1:length(Label)
    dir_name = [dir char(name(name_index)) '.mat']      % cell ת��Ϊ char�ַ�����
    fprintf('reading %s ...\n',dir_name);
    load(dir_name);                                     % ����ԭʼ����
    
    for i = normal.index(1):Avr:(normal.index(end)-Avr) % 
        SUM = 0;    % ���
        for j = i:i + Avr
            SUM = SUM + normal.after(:,:,j);% - AAA.AAA;
        end
        avr = SUM / Avr;
        
%         for enhance = 1:10      % ������ǿ
            sample = [sample;reshape(avr,1,64)/sum(reshape(avr,1,64)) Label(name_index)];
%         end
    end
    fprintf('OK!\n',dir_name);
end

sam = sample(:,1:end-1);
sum_col = sum(sam,2);% һ����������Ԫ��֮��
for i = 1:size(sum_col,1)
   sample(i,1:end-1) =  sam(i,:)*1000.0/sum_col(i);
%    new_sample(:,i) =  sample(:,i)*100.0./sum_col(i);
end

% sample = new_sample;
%% ������������
save('D:\1-embed\4-Serial_GUI\2-ARMС���\static\data\sample.mat','sample');
save('D:\1-embed\4-Serial_GUI\2-ARMС���\static\data\sum_col.mat','sum_col');
% save('D:\1-embed\4-Serial_GUI\2-ARMС���\static\data\AAA.mat','AAA');

%% ���� train_model.py ���� ģ��ֱ�ӽ���ѵ��------------------------
cd 'D:\1-embed\4-Serial_GUI\2-ARMС���\static\'
pcaNum = 10;
cross_test = 1;
% save = 0; 
save = 1;
cali_dir = 0;

ss = sprintf('python train_model.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout���ռ����е�cmd���ڵ������Ϊ�ַ�����ʽ
[status,cmdout] = system(ss)% �ȴ�pythonִ�����





