function result = Model_py(feature)
Label = {'����' '�ڰ�' '���' '��ƽ��' '�߹���' '�쳣','��ֹ'};
% NORMAL  = 0;
% ABNORMAL= 5;                % ��������̬
% TOEIN   = 1;                % ������
% TOEOUT  = 2;                % ������
% PING    = 3;                % ��ƽ��
% GAO     = 4;                % �߹���

% pcaNum = 20;    % ��ά���ά��
% cross_test = 1; % �Ƿ���Ҫʮ�ν�����֤
% tranNum = 300;  % ѵ�������� ����������

%%

s_feature = sprintfc('%g',feature);                         % ��������ת�����ַ�������
s = s_feature(1);
for i = 2:length(feature)
     s = strcat(s,',', s_feature(i));                       % �õ���s��һ��cell���������ı�����char()ת��Ϊ�ַ�
end
command = sprintf('python model.py "%s"',char(s));

% cmdout���ռ����е�cmd���ڵ������Ϊ�ַ�����ʽ
% [status,cmdout] = system(command);                          % �ȴ�pythonִ�����
[status,cmdout] = dos(command);
cmdout
result =Label{str2num(cmdout(end-4:end))+1};
% result = '����';

%% MATLAB����ģ��
% % load('F:\1-embed\4-Serial_GUI\Arduino չʾ\linear_SVM_PCA_model.mat');
% % label = trainedClassifier.predictFcn(feature);
% % result = Label(label+1);

end