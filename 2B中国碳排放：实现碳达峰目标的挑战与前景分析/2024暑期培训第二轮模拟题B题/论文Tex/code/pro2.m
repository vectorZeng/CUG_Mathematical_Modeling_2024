%% 数据读取
data_2 = readtable("pro2.xlsx",'Sheet','Sheet1');
raw3 = readtable("pro2.xlsx",'Sheet','com3');

%0-1标准化
normalized_data_3 = normalize(raw3, 'range');

normalized_data_2 = normalize(data_2, 'range');
NO = normalized_data_2.NO;
CH4 = normalized_data_2.CH4;
C = normalized_data_2.C;
Global = normalized_data_2.Global;

year2 = linspace(2010, 2020, 11);

year3 = linspace(1990, 2020, 31);

%% 趋势图 3  before 归一化
figure
plot(year3,raw3.NO,'r-*','LineWidth',1.5)
hold on
plot(year3,raw3.CH4,'g-*','LineWidth',1.5)
plot(year3,raw3.C,'b-*','LineWidth',1.5)
%plot(year2,Global,'r-o','LineWidth',1.5)
xlabel('年份')
ylabel('排放量（千公吨二氧化碳当量）')
title('一氧化氮、甲烷、碳排放量的变化趋势图')
legend('一氧化氮排放量','甲烷排放量','碳排放量')
set(gca,'FontSize',20)


%% 趋势图 3  after 归一化
figure
plot(year3,normalized_data_3.NO,'r-*','LineWidth',1.5)
hold on
plot(year3,normalized_data_3.CH4,'g-*','LineWidth',1.5)
plot(year3,normalized_data_3.C,'b-*','LineWidth',1.5)
%plot(year2,Global,'r-o','LineWidth',1.5)
xlabel('年份')
ylabel('归一化后的数据')
title('一氧化氮、甲烷、碳排放量的变化趋势图')
legend('一氧化氮排放量','甲烷排放量','碳排放量')
set(gca,'FontSize',20)

%% 趋势图 4  
figure
plot(year2,NO,'-*',"Color",[0.9290 0.6940 0.1250],'LineWidth',1.5)
hold on
plot(year2,CH4,'g-*','LineWidth',1.5)
plot(year2,C,'b-*','LineWidth',1.5)
plot(year2,Global,'r-o','LineWidth',1.5)
xlabel('年份')
ylabel('归一化后的数据')
title('一氧化氮、甲烷、碳排放量与全球温室气体排放量的变化趋势图')
legend('一氧化氮排放量','甲烷排放量','碳排放量','全球温室气体排放量')
set(gca,'FontSize',20)


%% 相关性分析
[corr2,pval_world] = corr(table2array(normalized_data_2)) ;
figure

% 相关性矩阵热图
h2 = heatmap(normalized_data_2.Properties.VariableNames, ...
    normalized_data_2.Properties.VariableNames,corr2);
title('面板数据间的相关性热力图')
set(gca, 'FontSize', 20);