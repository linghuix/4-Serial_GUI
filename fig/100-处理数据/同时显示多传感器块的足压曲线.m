A = load('D:\1-embed\3-Hardware_Test\test_flexforce\flexforce_precise\coef_4.04.mat')
Fs = 30                         % Hz

%%ѡ�񴫸�����
for i = 1:8
    a = [9-i i]
    row = a(1);
    col = a(2);

    % row = 5;
    % col = 4;

    % % index = 1300:1800;
    index = 1:2400
    %%���ݼ���
%     normal = load('D:\1-embed\4-Serial_GUI\fig\2-subject1\girl_��ƽ�㣬�ڰ��� 20190418T104147.mat');
    % index = 1400:2500; normal = load('C:\Users\xlh\Desktop\fig\subject2\girl_��ƽ��_20190507T093304.mat');
    normal = load('D:\1-embed\4-Serial_GUI\fig\1-downstairs_girl\normal_20190414T190830.mat');




%     plot(reshape(normal.data(row,col,index),1,length(index)));                  %%����indexѡ��ͼ
    hold on
    plot(reshape(normal.after(row,col,index),1,length(index)));                 %%�˲�����indexѡ��ͼ

    title('����indexѡ��ͼ')
end