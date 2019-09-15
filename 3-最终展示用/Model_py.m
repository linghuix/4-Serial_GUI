function result = Model_py(feature)
Label = {'正常' '内八' '外八' '扁平足' '高弓足' '异常','静止'};
% NORMAL  = 0;
% ABNORMAL= 5;                % 不正常步态
% TOEIN   = 1;                % 足内旋
% TOEOUT  = 2;                % 足外旋
% PING    = 3;                % 扁平足
% GAO     = 4;                % 高弓足

% pcaNum = 20;    % 降维后的维度
% cross_test = 1; % 是否需要十次交叉验证
% tranNum = 300;  % 训练数据量 泛化能力差

%%

s_feature = sprintfc('%g',feature);                         % 数字数组转化成字符串数组
s = s_feature(1);
for i = 2:length(feature)
     s = strcat(s,',', s_feature(i));                       % 得到的s是一个cell，所以下文必须用char()转化为字符
end
command = sprintf('python model.py "%s"',char(s));

% cmdout，收集所有的cmd窗口的输出，为字符串格式
% [status,cmdout] = system(command);                          % 等待python执行完毕
[status,cmdout] = dos(command);
cmdout
result =Label{str2num(cmdout(end-4:end))+1};
% result = '正常';

%% MATLAB分类模型
% % load('F:\1-embed\4-Serial_GUI\Arduino 展示\linear_SVM_PCA_model.mat');
% % label = trainedClassifier.predictFcn(feature);
% % result = Label(label+1);

end