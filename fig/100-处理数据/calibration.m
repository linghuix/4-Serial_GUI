%{
����ԭʼ���ݣ����ñ궨�Ĵ�������ȡ��ʵ����ѹ���ݵ�
D:\\1-embed\\4-Serial_GUI\\fig\\calibration\\

%}

clear all
clc

load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat') %A
% A = ones(8,8);
% A(:,1) = A(:,1)*1.0;
% A(5,:) = A(5,:)*1.0;

dir = 'D:\1-embed\4-Serial_GUI\fig\';

name = {'1','2','3','4','adult_gril_nor2'...
        ,'tin_1','adult_gril_toein1','adult_gril_toein2',...
        'tout_1','tout_2' ,'adult_gril_toeout1','adult_gril_toeout2' ,...
        's1','s2',...
        'ping1-1','ping2-1','ping3-1','ping1-2','ping2-2','ping3-4','ping4-4'};
    
suffix = '.mat';

%%

for name_index = 1:length(name)
    
    dir_name = [dir char(name(name_index)) suffix]          % cell ת��Ϊ char�ַ�����
    load(dir_name);                                         % ���μ��������ļ�  normal struct
    
    for i = 1:length(normal.after(1,1,:))                   %��ÿһ֡8x8���ݽ��в���
        normal.after(:,:,i) = (normal.after(:,:,i)-140)./A;  % ���ݱ궨���ݣ������ʵ��ѹ��ֵ����λg
        normal.data(:,:, i) = (normal.data(:,:,i)-140)./A;   % ���ݱ궨���ݣ������ʵ��ѹ��ֵ����λg
    end
    
    Dir = sprintf('D:\\1-embed\\4-Serial_GUI\\fig\\calibration\\%s_cali.mat',char(name(name_index)))
    save(Dir,'normal');
end

%% ��֤�����Ƿ�ִ����ȷ

% load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat') 
% A

format short
old = load('D:\1-embed\4-Serial_GUI\fig\ping2-2.mat');
load('D:\1-embed\4-Serial_GUI\fig\calibration\ping2-2_cali.mat');        %normal
a = normal.data(:,:,22);
b = (old.normal.data(:,:,22)-140)./A;
a==b
