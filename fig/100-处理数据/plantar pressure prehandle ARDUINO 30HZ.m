%{
������
1. ǰ���Ƶ�ѹ��������С����Ÿ������ϴ󣬲�������
2. ѡ��Ƚ����������ѹ������ index �Σ���normal���浽���أ��ýṹ����� �ɼ�ʱ������ʾ����y���˲�����after��ԭʼ����data��index����
%}

A = load('D:\1-embed\3-Hardware_Test\test_flexforce\flexforce_precise\coef_4.04.mat')
Fs = 30                         % Hz

%%ѡ�񴫸�����
a = [4 4];
row = a(1);
col = a(2);

% row = 5;
% col = 4;

% % index = 1300:1800;
index = 200:500
%%���ݼ���
normal = load('D:\1-embed\4-Serial_GUI\fig\2-subject1\girl_��ƽ�㣬�ڰ��� 20190418T104147.mat');
% index = 1400:2500; normal = load('C:\Users\xlh\Desktop\fig\subject2\girl_��ƽ��_20190507T093304.mat');


figure(1);
subplot 211
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%����ȫ��ͼ
subplot 212
plot(reshape(normal.after(row,col,:),1,size(normal.after,3)))
title('����ȫ��ͼ')


figure(3)
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%����indexѡ��ͼ
hold on
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%�˲�����indexѡ��ͼ
legend('ԭʼ����','�˲��������')
title('����indexѡ��ͼ')

% normal.index = index;
% % normal.fft = abs(fft(reshape(normal.data(row,col,index),1,length(index))))
% figure(4)
% plot(log10(abs(fft(reshape(normal.data(row,col,index),1,length(index))))))%%����Ҷ�仯����ͼ
% axis([1 inf 0 Inf])


figure(4)                                                                   %%����Ҷ�仯����ͼ

normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index))-140;
y = y/A.A(a(1),a(2));
y_after = reshape(normal.after(row,col,index),1,length(index))-140;
y_after = y_after/A.A(a(1),a(2));

NFFT = 2^nextpow2(length(normal.index));        % Ƶ��ͼ�ĵ���
A = abs(fft(y,NFFT));                           % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                % ��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.r');
title('��ʵƵ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')

hold on
A = abs(fft(y_after,NFFT));                     % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                %��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.b');
title('��ʵ�˲���Ƶ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')


%% ��׼���������
a = [5 3];
row = a(1);
col = a(2);
A = load('D:\1-embed\3-Hardware_Test\test_flexforce\flexforce_precise\coef_4.04.mat')
figure(10);
% G = (normal.data(row,col,:)-140)/A.A(row,col)
G = (normal.after(row,col,:)-140)/A.A(row,col)
plot(reshape(G,1,size(normal.data,3)));                %%����ȫ��ͼ
