function result = Model_py(feature, modelFrom)

% NORMAL  = 0;
% ABNORMAL= 5;                % ��������̬
% TOEIN   = 1;                % ������
% TOEOUT  = 2;                % ������
% PING    = 3;                % ��ƽ��
% GAO     = 4;                % �߹���

% pcaNum = 20;    % ��ά���ά��
% cross_test = 1; % �Ƿ���Ҫʮ�ν�����֤
% tranNum = 300;  % ѵ�������� ����������

    Label = {'NORMAL' 'TOEIN' 'TOEOUT' 'PING' 'GAO' 'ABNORMAL','STATIC'};
%%
    % cd 'F:\1-embed\4-Serial_GUI\չʾ��'
    if strcmp(modelFrom,'python')
        s_feature = sprintfc('%g',feature);                         % ��������ת�����ַ�������
        s = s_feature(1);
        for i = 2:length(feature)
             s = strcat(s,',', s_feature(i));                       % �õ���s��һ��cell���������ı�����char()ת��Ϊ�ַ�
        end
        
        % command = sprintf('python D:\\1-embed\\4-Serial_GUI\\չʾ��\\model.py "%s"',char(s))
        command = sprintf('python model.py "%s"',char(s))           % python F:\1-embed\4-Serial_GUI\չʾ��\model.py "0.00566178,0.00381959,0.00246555"

        % cmdout���ռ����е�cmd���ڵ������Ϊ�ַ�����ʽ
        % [status,cmdout] = system(command);                        % dos��system�����Ե��������У��ȴ�pythonִ�����
        [status,cmdout] = dos(command);

        result =Label{str2num(cmdout(end-4:end))+1};

    elseif strcmp(modelFrom,'matlab')

%% ����MATLAB�еķ���ģ�ͣ�������ٶȸ��ӵĿ��
        
        if ~exist('trainedClassifier') 
            load('����ģ��\linear_SVM_OVO_PCA_model.mat')
        end
        
        label = trainedClassifier.predictFcn(feature);
        result = Label(label+1);
    else
        error('ģ�͵��ô���');
    end
end