numFeatures = 1;
numHiddenUnits = 100;
numClasses = 3;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
Specify the training options. Set the solver to 'adam'. Train for 60 epochs. To prevent the gradients from exploding, set the gradient threshold to 2.
options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
  'InitialLearnRate',0.001 , ...
    'GradientThreshold',2, ...
    'Verbose',0, ...
    'Plots','training-progress');
Train the LSTM network with the specified training options using trainNetwork. Each mini-batch contains the whole training set, so the plot is updated once per epoch. The sequences are very long, so it might take some time to process each mini-batch and update the plot.
% net = trainNetwork(EMR_train_X,EMR_train_Y,layers,options);
% net_ABC = trainNetwork(EMR_train_X_ABC,EMR_train_Y_ABC,layers,options);
net_AE_ABC = trainNetwork(AE_train_X_ABC,AE_train_Y_ABC,layers,options);
%%
%深度学习数据划分
EMR_train_X = EMR';
EMR_train_Y =categorical(class_EMR)';
%%
%深度学习数据划分
EMR_train_X_ABC = EMR_train_X;
EMR_train_X_ABC(DE_idx) = [];
EMR_train_Y_ABC = class_EMR;
EMR_train_Y_ABC(DE_idx) = [];
EMR_train_Y_ABC = categorical(EMR_train_Y_ABC)';

%%
%深度学习数据划分

AE_train_X_ABC = data1_AE1.AE';
AE_train_X_ABC(DE_idx) = [];
AE_train_Y_ABC = data1_AE1.class;
AE_train_Y_ABC(DE_idx) = [];
AE_train_Y_ABC = categorical(AE_train_Y_ABC)';
%%
EMR_Test = readtable("Attachment2.xlsx",'Sheet','EMR');
EMR_Test_X1 = EMR_Test.EMR1;

%%
AE_Test = readtable("Attachment2.xlsx",'Sheet','AE');
AE_Test_X =AE_Test.AE3;



%%
% 加载数据，假设 EMR_Test 已经定义并包含相关数据  
% EMR_Test = ... ;  

time_EMR1 = datetime(EMR_Test.time1, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');  
% class_EMR = data1_EMR.class;  
% 检测离群值  
outlierMask = isoutlier(EMR_Test.EMR1, 'movmedian',16000,"ThresholdFactor",6);  

% 提取所有离群值  
% outliers_time = EMR_Test(outlierMask, :);  

figure
hold on
% 绘制正常类 （A, B, D）的电磁辐射信号  
plot(time_EMR1, EMR_Test.EMR1, '-', 'LineWidth', 1); % 蓝色线 
plot(time_EMR1(outlierMask), EMR_Test.EMR1(outlierMask), '*', 'LineWidth', 1); % 蓝色线  
% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
% title('电磁辐射信号时间序列图');  
legend('电磁辐射信号','干扰数据','Location', 'Best');  
set(gca,'fontsize',20)
hold off

%%
AE_TEST = readtable("Attachment2.xlsx",'Sheet','AE');
 time_AE1 = datetime(AE_TEST.time3, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');  
 %%
% class_EMR = data1_EMR.class;  
% 检测离群值  
outlierMask = isoutlier(AE_TEST.AE3, 'movmedian',16000,"ThresholdFactor",4);  

% 提取所有离群值  
% outliers_time = EMR_Test(outlierMask, :);  

figure
hold on
% 绘制正常类 （A, B, D）的电磁辐射信号  
plot(time_AE1, AE_TEST.AE3, '-', 'LineWidth', 1); % 蓝色线 
plot(time_AE1(outlierMask), AE_TEST.AE3(outlierMask), '*', 'LineWidth', 1); % 蓝色线  
% 设置图形的属性  
xlabel('时间');  
ylabel('声发射信号 (AE)');  
% title('电磁辐射信号时间序列图');  
legend('声发射信号','干扰数据','Location', 'Best');  
set(gca,'fontsize',20)
hold off


AE_OUT_TIME = time_AE1(outlierMask);
%%
% 求导  
dt = seconds(diff(time_EMR));  % 计算时间间隔  
dEMR = diff(EMR);          % 计算 EMR 的差分  

% 计算导数（相对于时间）  
dEMR_per_time = dEMR ./ dt; % 按时间间隔进行归一化  

% 绘图  
figure;  
hold on;   

% 绘制 EMR 信号  
% plot(time_EMR, EMR, 'b-', 'DisplayName', '原始EMR信号');  
% 绘制导数信号  
% 由于求导后数据长度减小1，需要调整时间向量  
% plot(time_EMR(2:end), dEMR_per_time, '-', 'DisplayName', '其他导数');
plot(time_EMR(normal_idx), dEMR_per_time(normal_idx), '*', 'DisplayName', '正常导数');  
  
% plot(time_EMR(C_idx), dEMR_per_time(C_idx), '*', 'DisplayName', '干扰导数');  
plot(time_EMR(predict_idx), dEMR_per_time(predict_idx), '*', 'DisplayName', '前兆导数');  

% 设置图形的属性  
xlabel('时间');  
ylabel('信号与导数');  
title('电磁辐射信号及其导数');  
legend('Location', 'Best');  
grid on;  

hold off;  
set(gca,'fontsize',20)

%%
data3_EMR  = readtable("Attachment3.xlsx",'Sheet','EMR');
data3_AE = readtable("Attachment3.xlsx",'Sheet','AE');
