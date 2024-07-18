%function [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% 返回经过训练的回归模型及其 RMSE。以下代码重新创建在回归学习器中训练的模型。您可以使用该生
% 成的代码基于新数据自动训练同一模型，或通过它了解如何以程序化方式训练模型。
%
%  输入:
%      trainingData: 一个包含导入 App 中的预测变量和响应列的表。
%
%
%  输出:
%      trainedModel: 一个包含训练的回归模型的结构体。该结构体中具有各种关于所训练模型的
%       信息的字段。
%
%      trainedModel.predictFcn: 一个对新数据进行预测的函数。
%
%      validationRMSE: 表示验证 RMSE 的双精度值。在 App 中，"模型" 窗格显示每个模型
%       的验证 RMSE。
%
% 使用该代码基于新数据来训练模型。要重新训练模型，请使用原始数据或新数据作为输入参数
% trainingData 从命令行调用该函数。
%
% 例如，要重新训练基于原始数据集 T 训练的回归模型，请输入:
%   [trainedModel, validationRMSE] = trainRegressionModel(T)
%
% 要使用返回的 "trainedModel" 对新数据 T2 进行预测，请使用
%   yfit = trainedModel.predictFcn(T2)
%
% T2 必须是一个表，其中至少包含与训练期间使用的预测变量列相同的预测变量列。有关详细信息，请
% 输入:
%   trainedModel.HowToPredict

% 由 MATLAB 于 2024-07-16 12:19:30 自动生成


% 提取预测变量和响应
% 以下代码将数据处理为合适的形状以训练模型。
%
inputTable = trainingData;
predictorNames = {'Countryside_Carbon', 'population_density', 'income', 'graduate', 'energy', 'library', 'enterprise'};
predictors = inputTable(:, predictorNames);
response = inputTable.China_Carbon;
isCategoricalPredictor = [false, false, false, false, false, false, false];

% 训练回归模型
% 以下代码指定所有模型选项并训练模型。
template = templateTree(...
    'MinLeafSize', 2, ...
    'NumVariablesToSample', 3);
regressionEnsemble = fitrensemble(...
    predictors, ...
    response, ...
    'Method', 'Bag', ...
    'NumLearningCycles', 499, ...
    'Learners', template);

% 使用 predict 函数创建结果结构体
predictorExtractionFcn = @(t) t(:, predictorNames);
ensemblePredictFcn = @(x) predict(regressionEnsemble, x);
trainedModel.predictFcn = @(x) ensemblePredictFcn(predictorExtractionFcn(x));

% 向结果结构体中添加字段
trainedModel.RequiredVariables = {'Countryside_Carbon', 'population_density', 'income', 'graduate', 'energy', 'library', 'enterprise'};
trainedModel.RegressionEnsemble = regressionEnsemble;
trainedModel.About = '此结构体是从回归学习器 R2023b 导出的训练模型。';
trainedModel.HowToPredict = sprintf('要对新表 T 进行预测，请使用: \n yfit = c.predictFcn(T) \n将 ''c'' 替换为作为此结构体的变量的名称，例如 ''trainedModel''。\n \n表 T 必须包含由以下内容返回的变量: \n c.RequiredVariables \n变量格式(例如矩阵/向量、数据类型)必须与原始训练数据匹配。\n忽略其他变量。\n \n有关详细信息，请参阅 <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>。');

% 提取预测变量和响应
% 以下代码将数据处理为合适的形状以训练模型。
%
inputTable = trainingData;
predictorNames = {'Countryside_Carbon', 'population_density', 'income', 'graduate', 'energy', 'library', 'enterprise'};
predictors = inputTable(:, predictorNames);
response = inputTable.China_Carbon;
isCategoricalPredictor = [false, false, false, false, false, false, false];

% 执行交叉验证
partitionedModel = crossval(trainedModel.RegressionEnsemble, 'KFold', 5);

% 计算验证预测
validationPredictions = kfoldPredict(partitionedModel);

% 计算验证 RMSE
validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));
