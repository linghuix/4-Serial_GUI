%{
������
1. ǰ���Ƶ�ѹ��������С����Ÿ������ϴ󣬲�������
%}

cd 'F:\1-embed\5-ARM\Small_50Hz_fig'
Fs = 50                         % Hz

%%ѡ�񴫸�����
a = [7 8];
row = a(1);                     % ��
col = a(2);                     % ��

%%���ݼ���
normal = load('test_filiter_dynamic_20190508T221417.mat');
index = 1:1400;         %����±�

%%��Ϊʵ�ʵĵ�ѹ
normal.data = normal.data./4095*3.3;
normal.after = normal.after./4095*3.3;
normal.y = normal.y./4095*3.3;

figure(1);                      % ԭʼ����ͼ
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%����ȫ��ͼ

figure(3)                       % �ϰ벿Ϊԭʼ�����±�ͼ���°벿Ϊ�˲����Ӧ��ͼ
subplot 211
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%����indexѡ��ͼ
subplot 212
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%�˲�����indexѡ��ͼ

% normal.index = index;
% % normal.fft = abs(fft(reshape(normal.data(row,col,index),1,length(index))))
% figure(4)
% plot(log10(abs(fft(reshape(normal.data(row,col,index),1,length(index))))))  %%����Ҷ�仯����ͼ
% axis([1 inf 0 Inf])

figure(4)                       % Ƶ�ʷ�ֵͼ
normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index));
% y = y/A.A(a(1),a(2));
y_after = reshape(normal.after(row,col,index),1,length(index));
% y_after = y_after/A.A(a(1),a(2));

NFFT = 2^nextpow2(length(normal.index))        % Ƶ��ͼ�ĵ���
A = abs(fft(y,NFFT));                           % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                % ��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.r');                          % ��ɫ��ԭʼ����
title('��ʵƵ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')

hold on
% subplot 212
A = abs(fft(y_after,NFFT));                     % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                % ��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.g');                          % ��ɫ���˲�
title('��ʵ�˲���Ƶ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')