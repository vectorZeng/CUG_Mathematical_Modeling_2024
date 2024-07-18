%variable = {'国内碳排放量','农村碳排放量','人口密度',...
    % '人均可支配收入','本专科毕业生数','能源消费总量',...
    % '公共图书馆业机构数','国内二氧化硫排放量','工业企业单位数'};
  %% 农村碳排放量
T = readtable("LSTM_pre1.xlsx");
countryside_actual = T.countryside;
%countryside_predict = Lstm_Forecast_Value;
year_countryside = linspace(1997, 2021, 25);
year_countryside1 = linspace(2022, 2032, 11);
figure
plot(year_countryside,countryside_actual,'b-*','LineWidth',1.5)
hold on
plot(year_countryside1,countryside_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('碳排放量')
title('农村碳排放量预测')
legend('实际值','预测值')
set(gca,'FontSize',20)

%% 人口密度
T = readtable("LSTM_pre2.xlsx");
density_actual = T.population_density;
density_predict = Lstm_Forecast_Value;
year_density = linspace(1949, 2022,74);
year_density1 = linspace(2023, 2032, 10);
figure
plot(year_density,density_actual,'b-*','LineWidth',1.5)
hold on
plot(year_density1,density_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('人口密度')
title('人口密度预测')
legend('实际值','预测值')
set(gca,'FontSize',20)


%% 收入
T = readtable("LSTM_pre3.xlsx");
income_actual = T.income;
income_predict = Lstm_Forecast_Value;
year_income = linspace(1978, 2023, 46);
year_income1 = linspace(2024, 2032, 9);
figure
plot(year_income,income_actual,'b-*','LineWidth',1.5)
hold on
plot(year_income1,income_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('人均可支配收入')
title('人均可支配收入预测')
legend('实际值','预测值')
set(gca,'FontSize',20)

%% 毕业生
T = readtable("LSTM_pre4.xlsx");
graduate_actual = T.graduate;
graduate_predict = Lstm_Forecast_Value;
year_graduate = linspace(1949, 2023, 75);
year_graduate1 = linspace(2024, 2032, 9);
figure
plot(year_graduate,graduate_actual,'b-*','LineWidth',1.5)
hold on
plot(year_graduate1,graduate_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('本专科毕业生数')
title('本专科毕业生数预测')
legend('实际值','预测值')
set(gca,'FontSize',20)

%% 能源
T = readtable("LSTM_pre5.xlsx");

energy_actual = T.energy;
energy_predict = Lstm_Forecast_Value;
year_energy = linspace(1980, 2021, 42);
year_energy1 = linspace(2022, 2032, 11);
figure
plot(year_energy,energy_actual,'b-*','LineWidth',1.5)
hold on
plot(year_energy1,energy_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('能源消费总量')
title('能源消费总量预测')
legend('实际值','预测值')
set(gca,'FontSize',20)


%% 图书馆
T = readtable("LSTM_pre6.xlsx");

lib_actual = T.lib;
lib_predict = Lstm_Forecast_Value;
year_lib = linspace(1949, 2023, 75);
year_lib1 = linspace(2024, 2032, 9);
figure
plot(year_lib,lib_actual,'b-*','LineWidth',1.5)
hold on
plot(year_lib1,lib_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('公共图书馆业机构数')
title('公共图书馆业机构数预测')
legend('实际值','预测值')
set(gca,'FontSize',20)


%% 企业
T = readtable("LSTM_pre7.xlsx");

enterprise_actual = T.enterprise;
enterprise_predict = Lstm_Forecast_Value;
year_enterprise = linspace(1992, 2022, 31);
year_enterprise1 = linspace(2023, 2032, 10);
figure
plot(year_enterprise,enterprise_actual,'b-*','LineWidth',1.5)
hold on
plot(year_enterprise1,enterprise_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('工业企业单位数')
title('工业企业单位数预测')
legend('实际值','预测值')
set(gca,'FontSize',20)

%% 预测模型检验
regress_train_data = readtable("pro3.xlsx",'Sheet','predict2');
China_C_actual = regress_train_data.China_Carbon;
regress_train_variable = regress_train_data(:,1:7);
China_C_regress_predict = rf_trainedModel.predictFcn(regress_train_variable);
%year_China1 = linspace(2018, 2032, 15);
figure
hold on
plot(year_China,China_C_actual,'b--o','LineWidth',1.5)
plot(year_China,China_C_regress_predict,'r-*','LineWidth',1.5)
xlabel('年份')
ylabel('国内碳排放量')
title('基于随机森林的国内碳排放量预测')
box on
legend('实际值','预测值')
set(gca,'FontSize',20)
hold off


%% 预测2018-2032的中国碳排放量
V_predict = readtable("pro3.xlsx",'Sheet','predict4');
China_C_actual = data_China.China_Carbon;

China_C_future_predict = rf_trainedModel.predictFcn(V_predict(:,1:end-1));
China_predict = [China_C_regress_predict;China_C_future_predict];

year_China1 = linspace(2018, 2032, 15);
year_China2 = linspace(1997, 2032, 36);
figure
hold on
plot(year_China,China_C_actual,'-*','LineWidth',1.5)
plot(year_China1,China_C_future_predict,'-*','LineWidth',1.5)
%plot(year_China2,China_predict,'--','Color',[0.8500 0.3250 0.0980],'LineWidth',1.5)
box on
xlabel('年份')
ylabel('国内碳排放量')
title('国内碳排放量预测')
legend('实际值','预测值')
set(gca,'FontSize',20)
hold off



