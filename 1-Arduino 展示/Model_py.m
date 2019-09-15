function result = Model_py(feature, modelFrom)

% NORMAL  = 0;
% ABNORMAL= 5;                % 不正常步态
% TOEIN   = 1;                % 足内旋
% TOEOUT  = 2;                % 足外旋
% PING    = 3;                % 扁平足
% GAO     = 4;                % 高弓足

% pcaNum = 20;    % 降维后的维度
% cross_test = 1; % 是否需要十次交叉验证
% tranNum = 300;  % 训练数据量 泛化能力差

    Label = {'NORMAL' 'TOEIN' 'TOEOUT' 'PING' 'GAO' 'ABNORMAL','STATIC'};
%%
    % cd 'F:\1-embed\4-Serial_GUI\展示用'
    if strcmp(modelFrom,'python')
        s_feature = sprintfc('%g',feature);                         % 数字数组转化成字符串数组
        s = s_feature(1);
        for i = 2:length(feature)
             s = strcat(s,',', s_feature(i));                       % 得到的s是一个cell，所以下文必须用char()转化为字符
        end
        
        % command = sprintf('python D:\\1-embed\\4-Serial_GUI\\展示用\\model.py "%s"',char(s))
        command = sprintf('python model.py "%s"',char(s))           % python F:\1-embed\4-Serial_GUI\展示用\model.py "0.00566178,0.00381959,0.00246555"

        % cmdout，收集所有的cmd窗口的输出，为字符串格式
        % [status,cmdout] = system(command);                        % dos和system都可以调用命令行，等待python执行完毕
        [status,cmdout] = dos(command);

        result =Label{str2num(cmdout(end-4:end))+1};

    elseif strcmp(modelFrom,'matlab')

%% 调用MATLAB中的分类模型，分类的速度更加的快捷
        
        if ~exist('trainedClassifier') 
            load('分类模型\linear_SVM_OVO_PCA_model.mat')
        end
        
        label = trainedClassifier.predictFcn(feature);
        result = Label(label+1);
    else
        error('模型调用错误');
    end
end