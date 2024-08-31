
age = 2020*ones(length(new1),1) - new1(:,2);
new1(:,2) = age;
% 性别列和饮酒列  
gender = new1(:,3);

%%
data = [gender zhibiao11];
% 计算男女饮酒和不饮酒人数  
male_drink = sum(data(data(:, 1) == 1 & data(:, 2) == 1, 1));  
male_no_drink = sum(data(data(:, 1) == 1 & data(:, 2) == 2, 1));  
female_drink = sum(data(data(:, 1) == 2 & data(:, 2) == 1, 1));  
female_no_drink = sum(data(data(:, 1) == 2 & data(:, 2) == 2, 1));  

% 计算比例  
male_total = male_drink + male_no_drink;  
female_total = female_drink + female_no_drink;  

male_ratio = [male_drink, male_no_drink] / male_total;  
female_ratio = [female_drink, female_no_drink] / female_total;  

% 绘制饼状图  
figure;  

subplot(1, 2, 1); % 创建1行2列的图，当前为第1个子图  
piechart(male_ratio, {'饮酒', '不饮酒'});  
title('男性饮酒比例');  
set(gca,'FontSize',20)
subplot(1, 2, 2); % 当前为第2个子图  
piechart(female_ratio, {'饮酒', '不饮酒'});  
title('女性饮酒比例');  

% 调整图形  
%sgtitle('饮酒与性别的关系'); % 添加总标题   
set(gca,'FontSize',20)

%%

%生活习惯和饮食习惯是否与年龄、性别、婚姻状况、文化程度、职业等因素相关
%clear;clc
%url = 'raw_data.xlsx';
text = readtable('raw_data.xlsx','Sheet','生活习惯');
text.x___ = -text.x___;
%对生活习惯数据进行评分
%1.对数据进行正向化
%其中1 3 5为极小型，2 4 6为极大型

%2.归一化处理
lifestyle = normalize(table2array(text), 'range');
row = length(lifestyle);
%3.利用熵权法计算各项指标的权重
W = Entropy_Method(lifestyle);
%4.计算最终得分
zuidajuli = sum([(lifestyle - repmat(max(lifestyle),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D+ 与最大值的距离向量
zuixiaojuli = sum([(lifestyle - repmat(min(lifestyle),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D- 与最小值的距离向量
score_life = zuixiaojuli ./ (zuidajuli+zuixiaojuli);
%% 判断相关性
data = readtable('raw_data.xlsx','Sheet','pro2');  % 从CSV文件中读取数据

% 将分类变量转换为哑变量  
data.gender = dummyvar(categorical(data.gender));  
data.education = dummyvar(categorical(data.education));  
data.marriage = dummyvar(categorical(data.marriage));  
data.career = dummyvar(categorical(data.career));  

% 提取连续变量和哑变量  
X = [data.age, data.gender, data.education, data.marriage, data.career];  
y_lifestyle = data.lifestyle;  
y_dietary = data.dietary;


%%
% 计算 dietary 与哑变量的相关性  
[correlations_dietary,p_dietary] = corr([y_dietary,X]);  
disp('Correlation with Dietary:');  
disp(correlations_dietary);  

% 计算 lifestyle 与哑变量的相关性  
[correlations_lifestyle,p_lifestyle] = corr([y_lifestyle,X]);  
disp('Correlation with Lifestyle:');  
disp(correlations_lifestyle);  



%%
% 线性回归分析生活习惯  
%生活习惯评分与个人因素的相关性分析
mdl_lifestyle = fitlm(X, y_lifestyle)
figure
plot(mdl_lifestyle.Coefficients.pValue,'*',LineWidth=1.5)
hold on
a = 0.05*ones(1,28);
plot(a,'r-',LineWidth=1.5)
legend('p值','阈值')
xlabel('哑变量')
ylabel('相关性p值')
set(gca,'FontSize',20)
% disp(mdl_lifestyle);  

% 线性回归分析饮食习惯  
mdl_dietary = fitlm(X, y_dietary);  

figure
plot(mdl_dietary.Coefficients.pValue,'*',LineWidth=1.5)
hold on
a = 0.05*ones(1,28);
plot(a,'r-',LineWidth=1.5)
legend('p值','阈值')
xlabel('哑变量')
ylabel('相关性p值')
set(gca,'FontSize',20)

% 计算相关系数矩阵  
[corr_lifestyle,p_lifestyle] = corr(data{:, {'age', 'lifestyle'}});  
[corr_dietary,p_dietary] = corr(data{:, {'age', 'dietary'}});  
disp('生活习惯评分和年龄的相关系数及p值：');  
disp(corr_lifestyle(1,2));  
disp(p_lifestyle(1,2)); 
disp('饮食习惯评分和年龄的相关系数及p值：');  
disp(corr_dietary(1,2));
disp(p_dietary(1,2));

%%
%对数据进行斯皮尔曼相关系数
%将得出的数据保存到excel表格中并读取数据
text = xlsread(url,4);
text(:,1) = data_conversion(text(:,1));
text(:,2) = data_conversion(text(:,2));
[R,P]=corr(text, 'type' , 'Spearman');
%显著性水平判断
a = P < 0.01  % 标记3颗星的位置
b = (P < 0.05) .* (P > 0.01)  % 标记2颗星的位置
c = (P < 0.1) .* (P > 0.05) % % 标记1颗星的位置
