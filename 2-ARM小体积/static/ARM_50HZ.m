

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

name = {'Toein-1','Toein-2'...
        ,'Toeout-1','Toeout-2','Toeout-3'...
        ,'normal-1'...
        };
%��ǩ
Label = [TOEIN TOEIN...
        TOEOUT TOEOUT TOEOUT ...
        NORMAL];

%% ��ȡ��ѹ��������
% A = load('D:\1-embed\xxx.mat')


%% ѡ�񴫸�����
% a = [1 1];
% row = a(1);
% col = a(2);

%% ��ȡ��ѹ���ݣ� ���ݼ���
% normal = load('D:\1-embed\4-Serial_GUI\fig\Static_ARM\1.mat');

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
            SUM = SUM + normal.data(:,:,j);
        end
        avr = SUM/Avr;
        sample = [sample;reshape(avr,1,64) Label(name_index)];
    end
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