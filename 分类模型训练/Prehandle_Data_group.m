
clc;clear all

NORMAL  = 0;
% ABNORMAL= 5;                % ��������̬
TOEIN   = 1;                % ������
TOEOUT  = 2;                % ������
PING    = 3;                % ��ƽ��
% GAO     = 4;                % �߹���
STATIC  = 6;

% % load the original data ---- normal struct
% dir = 'D:\1-embed\4-Serial_GUI\fig\';
% suffix = '.mat';

% load the calibrating data -----normal struct
dir = 'D:\1-embed\4-Serial_GUI\fig\';
suffix = '.mat';

%% python�����ӹ����趨
lcaNum = 4;
pcaNum = lcaNum;    % ��ά���ά��  0.9898
cross_test = 1; % �Ƿ���Ҫʮ�ν�����֤

%%---------------------------------------------------

n = 2^8;        % ����ԭʼʱ���������ݳ���256
N = 10;         % 0-10Hz
sample = [];    % �γ�һ�������㣬һ��Ϊһ��������
Fs = 30;        % Hz

% �ַ����Կ�����һ�����飬���Բ���ֱ���ÿո����ַ������飬ֻ�ܽ���cell
name = {'1','2','3','4','adult_gril_nor2'...
        ,'tin_1','adult_gril_toein1','adult_gril_toein2',...
        'tout_1','tout_2' ,'adult_gril_toeout1','adult_gril_toeout2' ,...
        's1','s2',...
        'ping1-1','ping2-1','ping3-1','ping1-2','ping2-2','ping3-4','ping4-4'};
Label = [NORMAL NORMAL NORMAL NORMAL NORMAL...
        TOEIN TOEIN TOEIN TOEOUT TOEOUT TOEOUT TOEOUT...
        STATIC STATIC...
        PING PING PING PING PING PING PING];

%     �����������˵ı��
individual = [1 1 1 1 2 ...
            3 4 4 ...
            5 5 6 6 ...
            7 8 ...
            9 9 9 10 10 11 11];

group_individual = []   % ��¼���ݶ�Ӧ���˵ı��
group = [];             % ѵ������
for name_index = 1:length(name)
    
    this_individual =[];
    gro = individual(name_index);                  % ���individual
    
    dir_name = [dir char(name(name_index)) suffix]  % cell ת��Ϊ char�ַ�����
    load(dir_name);                                 % ���� name_index, ѡ����ص����ݼ� normal
    label = Label(name_index);                      % label ���� name_index �仯

    sample = [];
    for i = normal.index(1):(normal.index(1)+length(normal.index))
        
        coef = [];
        
        if((i+n) >(normal.index(1)+length(normal.index)))      % index���ݲ�����ʱ
            break
        end
        
        % ����������鴮����
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
                ser = reshape(normal.after(row,col,i:i+n-1),1,n);% ĳ����������ʱ������
                serial = ser/mean(ser);
            else
                ser = reshape(normal.after(row,col,i:i+n-1),1,n);% ĳ����������ʱ������
                for ii = 1:length(merge_R)
                    ser = ser + reshape(normal.after(merge_R(ii),merge_C(ii),i:i+n-1),1,n);
                end
                ser = ser/4;
                serial = ser/mean(ser);
            end
                
            %%����Ҷϵ������
            NFFT = 2^nextpow2(n);                      % Ƶ��ͼ�ĵ���
            A = abs(fft(serial,NFFT));                 % Ƶ���ֵ
            f = Fs/2*linspace(0, 1, NFFT/2);            % ��������������Ƶ�ʷֱ���
            A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;
            % stem(f,A_f/NFFT,'.b');
            
%             temp = [A_f(f == 0) sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
            temp = [sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
            coef = [coef temp];                                         % ����������鴮����
        end
        
        sample = [sample;coef label];
    end
    group = [group; sample];
    
    sample_size = size(sample,1)
    this_individual = ones(1, sample_size)*gro;
    group_individual = [group_individual , this_individual];    % ���group���
end

group_size = size(group)

fprintf('-----------------\n��������Ϣ��\n���\t��Ŀ\n');

for class=0:3
    num = sum(group(:,end)==class);
    fprintf('%d\t%d\n',class,num)
end

save('D:\1-embed\4-Serial_GUI\����ģ��ѵ��\tmp\features.mat','group');         % �� Ϊһ������
save('D:\1-embed\4-Serial_GUI\����ģ��ѵ��\tmp\group.mat','group_individual');
%% ģ��ֱ�ӽ���ѵ��
% clc
cd 'D:\1-embed\4-Serial_GUI\����ģ��ѵ��\'
% save = 0;
save = 1;
cali_dir = 0;
ss = sprintf('python train_model_group.py %d %d %d %d', pcaNum, cross_test ,save, cali_dir)

% cmdout���ռ����е�cmd���ڵ������Ϊ�ַ�����ʽ
[status,cmdout] = system(ss)          % �ȴ�pythonִ�����

%% ģ��Ԥ��
%{

n = 2^8;

NFFT = 2^nextpow2(length(normal.index));                    % Ƶ��ͼ�ĵ���
A = abs(fft(serial(normal.index),NFFT));                    % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                            % ��������������Ƶ�ʷֱ���
A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;
sent_data = [A_f(f == 0) sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];

%}
%%
% clc;
cd 'D:\1-embed\4-Serial_GUI\����ģ��ѵ��'
% line = 3370
line = unidrnd(size(group,1))                              % �������һ��������
sent_data = group(line,1:(end-1));

s_sent_data = sprintfc('%g',sent_data);                     % ��������ת�����ַ�������
s = s_sent_data(1);
for i = 2:length(sent_data)
     s = strcat(s,',', s_sent_data(i));                     % �õ���s��һ��cell���������ı�����s{1}
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
