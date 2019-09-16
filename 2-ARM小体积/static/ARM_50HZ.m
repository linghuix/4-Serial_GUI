

%{
������
1. ͨ��ѡȡ�����ݣ����û����ķ�������ƽ��
2. Ȼ��չƽ8x8�ľ���

%}

clc
clear all
NORMAL  = 0;
TOEIN   = 1;                % ������
TOEOUT  = 2;                % ������

name = {'Toein-11'...
        ,'Toeout-11'...
        ,'normal-11'...
        };
%��ǩ
Label = [TOEIN ...
        TOEOUT  ...
        NORMAL];

%% ��ȡ��ѹ��������
% A = load('D:\1-embed\xxx.mat')


%% ѡ�񴫸�����
% a = [1 1];
% row = a(1);
% col = a(2);

%% ��ȡ��ѹ���ݣ� ���ݼ���
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
    dir_name = [dir char(name(name_index)) '.mat'];      % cell ת��Ϊ char�ַ�����
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

%% ������������
save('D:\1-embed\4-Serial_GUI\2-ARMС���\static\data\sample.mat','sample');

%% ���� train_model.py ���� ģ��ֱ�ӽ���ѵ��------------------------
cd 'D:\1-embed\4-Serial_GUI\2-ARMС���\static\'
pcaNum = 10;
cross_test = 1;
% save = 0; 
save = 1;
cali_dir = 0;

ss = sprintf('python train_model.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout���ռ����е�cmd���ڵ������Ϊ�ַ�����ʽ
[status,cmdout] = system(ss)          % �ȴ�pythonִ�����