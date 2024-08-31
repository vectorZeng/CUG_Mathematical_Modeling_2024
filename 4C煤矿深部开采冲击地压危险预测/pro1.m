data1_EMR = readtable("Attachment1.xlsx",'Sheet','EMR');
data1_AE = readtable("Attachment1.xlsx",'Sheet','AE');

%%
% 分离 EMR, time 和 class 列  
EMR = data1_EMR.EMR;  
time_EMR = datetime(data1_EMR.time, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');  
class_EMR = data1_EMR.class;  

% 创建图形  
figure;  
hold on; % 保持当前图  

% 使用逻辑索引绘制不同类别的数据  
C_idx = class_EMR == "C"; % 找到C类数据的索引  
normal_idx = (class_EMR == "A"); % 找到正常数据的索引  
predict_idx= (class_EMR =="B");
%DE
DE_idx= (class_EMR =="D/E");
plot(time_EMR, EMR, 'LineWidth', 1); % 蓝色线  


plot(time_EMR(DE_idx), EMR(DE_idx),'*','Color',[0.3010 0.7450 0.9330] ,'LineWidth', 0.5)
% 绘制 C 类 的电磁辐射信号  


% 绘制正常类 （A, B, D）的电磁辐射信号  
plot(time_EMR(normal_idx), EMR(normal_idx), 'g*', 'LineWidth', 1); % 蓝色线  

plot(time_EMR(predict_idx), EMR(predict_idx), '*','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1); % 紫色线

plot(time_EMR(C_idx), EMR(C_idx), 'r*', 'LineWidth', 1); % 红色线  

% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
%title('电磁辐射信号时间序列图');  
legend('EMR信号', '不正常/停产数据','正常数据', '前兆数据','干扰数据','Location', 'Best');  
grid on;  

hold off; % 停止保持图形  
set(gca,'fontsize',20)
% 在这里你可以继续添加分析 C 类数据的其他代码  
% 例如：  
% 绘制 C 类的统计特征（均值、标准差等）  
range_C = max(EMR(C_idx)) - min(EMR(C_idx));  
mean_C = mean(EMR(C_idx));  
std_C = std(EMR(C_idx));  
med_C = median(EMR(C_idx));
mod_C = mode(EMR(C_idx));
cv_C = std_C/mean_C*100;

disp(['C类数据的峰峰值: ', num2str(range_C)]);  
disp(['C类数据的均值: ', num2str(mean_C)]);  
disp(['C类数据的标准差: ', num2str(std_C)]);
disp(['C类数据的中位数: ', num2str(mod_C)]);
disp(['C类数据的众数: ', num2str(mod_C)]);
disp(['C类数据的变异系数: ', num2str(cv_C)]);
%%

% 创建图形  
figure;  
% hold on; % 保持当前图  

plot(time_EMR, EMR, 'LineWidth', 1); % 蓝色线  
% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
title('电磁辐射信号时间序列图');  
legend('EMR信号','Location', 'Best');  
set(gca,'fontsize',20)



figure
plot(time_EMR(DE_idx), EMR(DE_idx),'-*','Color',[0.3010 0.7450 0.9330] ,'LineWidth', 0.5)
% 绘制 C 类 的电磁辐射信号  
% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
% title('电磁辐射信号时间序列图');  
legend('不正常/停产数据','Location', 'Best');  
set(gca,'fontsize',20)

figure
% 绘制正常类 （A, B, D）的电磁辐射信号  
plot(time_EMR(normal_idx), EMR(normal_idx), 'g-*', 'LineWidth', 1); % 蓝色线  
% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
% title('电磁辐射信号时间序列图');  
legend('正常数据','Location', 'Best');  
set(gca,'fontsize',20)




EMR_C_time = time_EMR(C_idx);
EMR_C_data = EMR(C_idx);


EMR_B_time = time_EMR(predict_idx);
EMR_B_data = EMR(predict_idx);

figure
 % plot(EMR_B_time(59:736), EMR_B_data(59:736) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1); % 紫色线
 plot(EMR_B_time(1187:1767), EMR_B_data(1187:1767) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1);
% plot(EMR_B_time(2544:4665), EMR_B_data(2544:4665) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1);
% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
% title('电磁辐射信号时间序列图');  
legend('前兆数据','Location', 'Best');  
set(gca,'fontsize',20)


figure
plot(EMR_C_time(40:308), EMR_C_data(40:308), 'r-', 'LineWidth', 1); % 红色线  

% 设置图形的属性  
xlabel('时间');  
ylabel('电磁辐射信号 (EMR)');  
%title('电磁辐射信号时间序列图');  
legend('干扰数据','Location', 'Best');  
grid on;  

% hold off; % 停止保持图形  
set(gca,'fontsize',20)


%%
% 分离 EMR, time 和 class 列  
AE = data1_AE.AE;  
time_AE = datetime(data1_AE.time, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');  
class_AE = data1_AE.class;  

% 创建图形  
figure;  
hold on; % 保持当前图  

% 使用逻辑索引绘制不同类别的数据  
C_idx = (class_AE == "C"); % 找到C类数据的索引  
normal_idx = (class_AE == "A"); % 找到正常数据的索引  
predict_idx= (class_AE =="B");
%DE
DE_idx= (class_AE =="D/E");
plot(time_AE, AE, 'LineWidth', 1); % 蓝色线  


plot(time_AE(DE_idx), AE(DE_idx),'*','Color',[0.3010 0.7450 0.9330] ,'LineWidth', 0.5)
% 绘制 C 类 的电磁辐射信号  


% 绘制正常类 （A, B, D）的电磁辐射信号  
plot(time_AE(normal_idx), AE(normal_idx), 'g*', 'LineWidth', 1); % 蓝色线  

plot(time_AE(predict_idx), AE(predict_idx), '*','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1); % 紫色线

plot(time_AE(C_idx), AE(C_idx), 'r*', 'LineWidth', 1); % 红色线  

% 设置图形的属性  
xlabel('时间');  
ylabel('声发射信号（AE）');  
%title('电磁辐射信号时间序列图');  
legend('AE信号', '不正常/停产数据','正常数据', '前兆数据','干扰数据','Location', 'Best');  
grid on;  

hold off; % 停止保持图形  
set(gca,'fontsize',20)
% 在这里你可以继续添加分析 C 类数据的其他代码  
% 例如：  
% 绘制 C 类的统计特征（均值、标准差等）  


range_C = max(AE(C_idx)) - min(AE(C_idx));  
mean_C = mean(AE(C_idx));  
std_C = std(AE(C_idx));  
med_C = median(AE(C_idx));
mod_C = mode(AE(C_idx));
cv_C = std_C/mean_C*100;

disp(['C类数据的峰峰值: ', num2str(range_C)]);  
disp(['C类数据的均值: ', num2str(mean_C)]);  
disp(['C类数据的标准差: ', num2str(std_C)]);
disp(['C类数据的中位数: ', num2str(mod_C)]);
disp(['C类数据的众数: ', num2str(med_C)]);
disp(['C类数据的变异系数: ', num2str(cv_C)]);
%%

AE_B_time = time_AE(predict_idx);
AE_B_data = AE(predict_idx);

figure
 % plot(EMR_B_time(59:736), EMR_B_data(59:736) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1); % 紫色线
  plot(AE_B_time(1:547), AE_B_data(1:547) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1);
  % plot(AE_B_time(548:845), AE_B_data(548:845) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1);
% plot(EMR_B_time(2544:4665), EMR_B_data(2544:4665) , '-','Color',[0.9290 0.6940 0.1250], 'LineWidth', 1);
% 设置图形的属性  
xlabel('时间');  
ylabel('声发射信号 (AE)');  
% title('电磁辐射信号时间序列图');  
legend('前兆数据','Location', 'Best');  
set(gca,'fontsize',20)

%%
AE_feature = zeros(6,4);
AE_feature(:,1) = data_feature(AE(C_idx));
AE_feature(:,2) = data_feature(AE(normal_idx));
AE_feature(:,3) = data_feature(AE(predict_idx));
AE_feature(:,4) = data_feature(AE(DE_idx));
%%
EMR_feature = zeros(6,4);
EMR_feature(:,1) = data_feature(EMR(C_idx));
EMR_feature(:,2) = data_feature(EMR(normal_idx));
EMR_feature(:,3) = data_feature(EMR(predict_idx));
EMR_feature(:,4) = data_feature(EMR(DE_idx));
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
