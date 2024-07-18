%3. 分析影响国内碳排放变化的主要影响因素和贡献率，建立合适的碳排放量模型并预测2030 年碳达峰目标实现的可行性
%% 数据读取
data_China = readtable("pro3.xlsx",'Sheet','Sheet1');
%0-1标准化
normalized_data_China = normalize(data_China(:,2:end), 'range');

year_China = data_China.year;

%% 趋势图
figure
plot(year_China,normalized_data_China.China_Carbon,'r-*','linewidth',2);
hold on;
plot(year_China,normalized_data_China.Countryside_Carbon,'linewidth',1.5);
plot(year_China,normalized_data_China.population_density,'m-','linewidth',1.5);
plot(year_China,normalized_data_China.income,'linewidth',1.5);
plot(year_China,normalized_data_China.graduate,'g-','linewidth',1.5);
plot(year_China,normalized_data_China.energy,'linewidth',1.5);
plot(year_China,normalized_data_China.library,'linewidth',1.5);
plot(year_China,normalized_data_China.SO2,'linewidth',1.5);
plot(year_China,normalized_data_China.enterprise,'linewidth',1.5);
%set(China_plot,'linewidth',1.5)
xlim([1997,2022]);
legend('国内碳排放量','农村碳排放量','人口密度','人均可支配收入','本专科毕业生数','能源消费总量','公共图书馆业机构数','国内二氧化硫排放量','工业企业单位数')
xlabel('年份')
ylabel('归一化后的数据')
title('国内碳排放与各影响因素的变化趋势图')
set(gca,'FontSize',20)
hold off;


%% 相关性分析

variable = {'国内碳排放量','农村碳排放量','人口密度',...
    '人均可支配收入','本专科毕业生数','能源消费总量',...
    '公共图书馆业机构数','国内二氧化硫排放量','工业企业单位数'};
[corr_China,pval] = corr(table2array(normalized_data_China)) 
figure

% 相关性矩阵热图
h = heatmap(variable, ...
    variable,corr_China);
title('国内碳排放与各影响因素的相关性热力图')
set(gca, 'FontSize', 20);
%% 相关性排序
R = corr_China(1,2:end);
factors_lable = variable(2:end);
% 将数组 R 转换为表，列的名称是1到22
%T = array2table(R, 'VariableNames',cellstr(num2str((1:22)')));

% 对T表按照第一行降序排序
[~, idx] = sort(abs(R), 'descend');
T_sorted = R(idx);
L_sorted = factors_lable(idx);
figure
bar(T_sorted);
xticks(1:8);
xticklabels(L_sorted);
xlabel('影响因素');
ylabel('相关系数');
title('中国碳排放量与影响因素之间的相关系数', 'FontWeight', 'bold', 'FontSize', 20);
% 在条形图上显示数值
for i = 1:length(T_sorted)
    text(i, T_sorted(i), num2str(T_sorted(i), '%.3f'), 'HorizontalAlignment', ...
        'center', 'VerticalAlignment', 'bottom','FontSize',23);
end
set(gca,'FontSize',20)

%% 主成分分析
factors = table2array(normalized_data_China);
factors(:,2) = [];
%%
[coeff,score,latent,tsquared,explained] = pca(factors)
num = 8;
X = categorical({'PC1','PC2','PC3','PC4','PC5','PC6','PC7','PC8'});
explained_pc = explained(1:num,1);
contribution = sum(explained_pc);
for i = 1:num
    fprintf('第%d个主成分的贡献度为%f%%\n',i,explained_pc(i,1));
end
fprintf('主成分总贡献度为%f%%\n',contribution);

figure
bar(X,explained_pc);%variable(2:end),
xlabel('主成分');
ylabel('贡献度');
title('主成分降维', 'FontWeight', 'bold', 'FontSize', 14);
for i = 1:length(explained_pc)
    text(i, explained_pc(i), num2str(explained_pc(i), '%.2f'), 'HorizontalAlignment', ...
        'center', 'VerticalAlignment', 'bottom','FontSize',20);
end
set(gca,'FontSize',20)

%% regress model
regress_train_data = readtable("pro3.xlsx",'Sheet','predict2');

%% time series
countryside =readtable("pro3.xlsx",'Sheet','countryside');
T_countryside = countryside.countryside;
% 将数据存储在变量中  
year = [1997:2021];  

% 创建时间序列对象  
ts = timeseries(T_countryside, year);
% 拟合ARIMA模型  
mdl = arima(2,5,2); % 定义ARIMA模型的参数  

% 将时间序列数据拟合到ARIMA模型中  
fit = estimate(mdl, ts.Data);  

% 预测未来的值  
futureYears = [2022:2035];  
[countrysidePredicted, ~] = forecast(fit, length(futureYears));

% 可视化结果  
figure;  
plot(year, T_countryside, 'b.-', 'DisplayName', 'Actual Data');  
hold on;  
plot(futureYears, countrysidePredicted, 'r.-', 'DisplayName', 'Predicted Data');  
xlabel('Year');  
ylabel('Countryside Carbon Emission');  
legend;  
title('Prediction of Countryside Carbon Emission');

