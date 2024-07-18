%1. 请分析碳排放量、自然灾害发生量与地球地表温度之间的关系
disaster = readtable("自然灾害数据.csv");
disaster_year = disaster.Year;

% 使用histogram函数统计各年份出现的次数
histogram_data = histogram(disaster_year);

disaster_count = histogram_data.Values;

%% 画图
data = readtable("pro1_data.xlsx");
%0-1标准化
normalized_data = normalize(data, 'range');

year = linspace(2000, 2020, 21);

Carbon = normalized_data.Carbon;
disaster_count = normalized_data.Disaster;
Temp = normalized_data.Temp;

figure


plot(year,Carbon,'b-*','LineWidth',1.5)
hold on
plot(year,disaster_count,'g-*','LineWidth',1.5)
plot(year,Temp,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('归一化后的数据')
title('碳排放量,自然灾害发生量和地球地表温度的面板数据变化趋势图')
legend('碳排放量','自然灾害发生量','地球地表温度')
set(gca,'FontSize',20)

%% 增量画图
diff_data = diff(table2array(normalized_data));
figure
plot(year(2:end),diff_data(:,1),'b-*','LineWidth',1.5)
hold on
plot(year(2:end),diff_data(:,2),'g-*','LineWidth',1.5)
plot(year(2:end),diff_data(:,3),'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('归一化后的数据')
title('碳排放量,自然灾害发生量和地球地表温度的增量数据变化趋势图')
legend('碳排放变化量','自然灾害变化量','地球地表温度变化量')
set(gca,'FontSize',20)

%% 增量相关性分析
[corr_diff,pval1] = corr(diff_data) ;
figure

% 相关性矩阵热图
h_diff = heatmap(normalized_data.Properties.VariableNames, ...
    normalized_data.Properties.VariableNames,corr_diff);
title('增量间的相关性热力图')
set(gca, 'FontSize', 20);

%% 相关性分析
[correlationMatrix,pval] = corr(table2array(normalized_data)) 
figure

% 相关性矩阵热图
h = heatmap(normalized_data.Properties.VariableNames, ...
    normalized_data.Properties.VariableNames,correlationMatrix);
title('面板数据间的相关性热力图')
set(gca, 'FontSize', 20);
%% 二元回归
y = Temp;
X = [ones(size(Carbon)) Carbon disaster_count Carbon.*disaster_count];
[b,bint,r,rint,stats]  = regress(y,X)  
figure
scatter3(Carbon,disaster_count,y,'filled')
hold on
Carbonfit = min(Carbon):0.01:max(Carbon);
disaster_countfit = min(disaster_count):0.01:max(disaster_count);
[CarbonFIT,disaster_countFIT] = meshgrid(Carbonfit,disaster_countfit);
YFIT = b(1) + b(2)*CarbonFIT + b(3)*disaster_countFIT + b(4)*CarbonFIT.*disaster_countFIT;
mesh(CarbonFIT,disaster_countFIT,YFIT)
xlabel('Carbon')
ylabel('Disaster')
zlabel('Temp')
view(50,10)
hold off
legend('data','多重回归拟合曲线')
set(gca, 'FontSize', 20);
%% 3个一元回归
OLS = zeros(3,2);
 figure
 sgtitle('最小二乘拟合', 'FontWeight', 'bold', 'FontSize', 20)
for i=1:2
if i ==1
    x = Carbon;
    y = disaster_count;
    v1 = {'碳排放量'};
    v2 = {'自然灾害发生量'};
end
if i ==2
    x = Carbon;
    y = Temp;
    v1 = {'碳排放量'};
    v2 = {'地球地表温度'};
end
if i ==3
    x = Temp;
    y = disaster_count;
    v1 = {'地球地表温度'};
    v2 = {'自然灾害发生量'};
end
%figure
 fitresult = fit(x, y, 'poly1' );
% OLS(i,1) = fitresult.p1;
% OLS(i,2) = fitresult.p2;
[p,S] = polyfit(x,y,1); 
[y_fit,delta] = polyval(p,x,S);

subplot(1,2,i)
plot(x,y,'bo','LineWidth',1.5)
hold on
plot(x,y_fit,'r-','LineWidth',1.5)
plot(x,y_fit+2*delta,'m--',x,y_fit-2*delta,'m--','LineWidth',1.5)
title('Linear Fit of Data with 95% Prediction Interval')
legend('Data','Linear Fit','95% Prediction Interval')
% myplot = plot(fitresult,x,y);
 xlabel(v1)
ylabel(v2)
title(['y = ',num2str(fitresult.p1),' x + ',num2str(fitresult.p2)])
%set(myplot,'linewidth',1.5,'MarkerSize',18)
set(gca, 'FontSize', 15);
end

%%

