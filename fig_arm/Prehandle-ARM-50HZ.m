
%{
������
1. ǰ���Ƶ�ѹ��������С����Ÿ������ϴ󣬲�������
2. ѡ��Ƚ����������ѹ������ index �Σ���normal���浽���أ��ýṹ����� �ɼ�ʱ������ʾ����y���˲�����after��ԭʼ����data��index����
%}

A = load('D:\1-embed\3-ARDUINO\test_flexforce\flexforce_precise\coef_4.04.mat');
Fs = 50;                         % Hz

%%ѡ�񴫸�����
a = [5 5];
row = a(1);
col = a(2);

% % index = 1300:1800;
index = 100:1200;
%%���ݼ���
normal = load('D:\1-embed\4-Serial_GUI\fig_arm\Small_50Hz_fig\normal_20190916T144608.mat');


figure(1);
subplot 211
plot(reshape(normal.data(row,col,:),1,size(normal.data,3)));                %%����ȫ��ͼ
subplot 212
plot(reshape(normal.after(row,col,:),1,size(normal.after,3)))
title('����ȫ��ͼ')


figure(2)
plot(reshape(normal.data(row,col,index),1,length(index)));                  %%����indexѡ��ͼ
hold on
plot(reshape(normal.after(row,col,index),1,length(index)));                 %%�˲�����indexѡ��ͼ
legend('ԭʼ����','�˲��������')
title('����indexѡ��ͼ')



figure(4)                                                                   %%����Ҷ�仯����ͼ

normal.index = index;
y = reshape(normal.data(row,col,index),1,length(index));
y_after = reshape(normal.after(row,col,index),1,length(index));

NFFT = 2^nextpow2(length(normal.index));        % Ƶ��ͼ�ĵ���
A = abs(fft(y,NFFT));                           % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                % ��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.r');
title('��ʵƵ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')

hold on
A = abs(fft(y_after,NFFT));                           % Ƶ���ֵ
f = Fs/2*linspace(0, 1, NFFT/2);                %��������������Ƶ�ʷֱ���
A_f = [A(1)  2*A(2:NFFT/2)];
stem(f,A_f/NFFT,'.b');
title('��ʵ�˲���Ƶ�ף���ֵΪ��Ƶ�����Ҳ���Ӧ�ķ�ֵ')


%% ��׼���������

row = a(1);
col = a(2);
AAA=[
  720 730 1150 1160 1180 1180 895 730;
  670 870 1060 1150 1180 1180 890 723;
  720 840 1150 795 1180 1180 890 730;
  722 867 840 1150 1137 1180 890 730;
  715 870 1150 1111 1180 850 890 730;
  715 870 1145 1157 850 1183 850 727;
  725 870 1147 1160 1185 1100 890 650;
  715 870 1145 1160 1185 1185 780 730];
  
figure(5)

for j = normal.index
    imshow(imresize(normal.after(:,:,j)-AAA,50,'nearest'),[-10 600]); 
    drawnow limitrate         
    %F(j) = getframe;
end

close figure 5
