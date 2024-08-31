%对居民进行合理分类，并针对各类人群提出有利于身体健康的膳食、运动等方面的合理建议。

% 创建数据表  
data_pro4 = readtable("raw_data.xlsx",'Sheet','pro4');  

% 显示原始数据 

% 定义年龄段  
ageGroups = cell(size(data_pro4.age)); % 创建一个单元格数组以存储年龄段  

for i = 1:height(data_pro4)  
    if data_pro4.age(i) < 35  
        ageGroups{i} = '青年';  
    elseif data_pro4.age(i) < 60  
        ageGroups{i} = '中年';  
    else  
        ageGroups{i} = '老年';  
    end  
end  

% 将年龄段添加到数据表中  
data_pro4.ageGroup = categorical(ageGroups);  

%%
% 计算各年龄段的平均吸烟量  
averageSmoke_hyper = groupsummary(data_pro4, 'hypertension', 'mean', 'smoke');  

% 显示平均吸烟量  
disp('高血压患者和正常人的平均吸烟量：');  
disp(averageSmoke_hyper );  

% 绘制条形图  
figure;  
bar(categorical(averageSmoke_hyper.hypertension), averageSmoke_hyper.mean_smoke, 'FaceColor', [0 0 1]);  
xlabel('高血压患者和正常人');  
ylabel('平均吸烟量');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)


%%
% 计算各年龄段的平均吸烟量  
averageExercise_hyper = groupsummary(data_pro4, 'hypertension', 'mean', 'exercise');  

% 显示平均吸烟量  
disp('高血压患者和正常人的平均运动量：');  
disp(averageExercise_hyper );  

% 绘制条形图  
figure;  
bar(categorical(averageExercise_hyper.hypertension), averageExercise_hyper.mean_exercise, 'FaceColor', [0 0 1]);  
xlabel('高血压患者和正常人');  
ylabel('平均运动量');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)


%%
% 计算各年龄段的平均吸烟量  
averageSmoke = groupsummary(data_pro4, 'ageGroup', 'mean', 'smoke');  

% 显示平均吸烟量  
disp('各年龄段的平均吸烟量：');  
disp(averageSmoke);  

% 绘制条形图  
figure;  
bar(categorical(averageSmoke.ageGroup), averageSmoke.mean_smoke, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均吸烟量');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)
%%
% 计算各年龄段的平均吸烟量  
averageExercise = groupsummary(data_pro4, 'ageGroup', 'mean', 'exercise');  

% 显示平均吸烟量  
disp('各年龄段的平均运动量：');  
disp(averageExercise);  

% 绘制条形图  
figure;  
bar(categorical(averageExercise.ageGroup), averageExercise.mean_exercise, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均运动量');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)

%%
% 计算各年龄段的平均吸烟量  
averageDrink = groupsummary(data_pro4, 'ageGroup', 'mean', 'drink');  

% 显示平均吸烟量  
disp('各年龄段的平均饮酒量：');  
disp(averageDrink);  

% 绘制条形图  
figure;  
bar(categorical(averageDrink.ageGroup), averageDrink.mean_drink, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均饮酒量');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)

%%
% 计算各年龄段的平均吸烟量  
averageBreakfast = groupsummary(data_pro4, 'ageGroup', 'mean', 'breakfast');  

% 显示平均吸烟量  
disp('各年龄段的平均不吃早餐次数：');  
disp(averageBreakfast);  

% 绘制条形图  
figure;  
bar(categorical(averageBreakfast.ageGroup), averageBreakfast.mean_breakfast, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均不吃早餐次数');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)
%%
% 计算各年龄段的平均吸烟量  
averageDietary = groupsummary(data_pro4, 'ageGroup', 'mean', 'dietary');  

% 显示平均吸烟量  
disp('各年龄段的平均饮食习惯评分：');  
disp(averageDietary);  

% 绘制条形图  
figure;  
bar(categorical(averageDietary.ageGroup), averageDietary.mean_dietary, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均平均饮食习惯评分');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)

%%

% 计算各年龄段的平均吸烟量  
averageLifestyle = groupsummary(data_pro4, 'ageGroup', 'mean', 'lifestyle');  

% 显示平均吸烟量  
disp('各年龄段的平均生活习惯评分：');  
disp(averageLifestyle);  

% 绘制条形图  
figure;  
bar(categorical(averageLifestyle.ageGroup), averageLifestyle.mean_lifestyle, 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('平均平均生活习惯评分');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)
%%
% 计算各年龄段的平均吸烟量  
averageHypertension = groupsummary(data_pro4, 'ageGroup', 'mean', 'hypertension');  

% 显示平均吸烟量  
disp('各年龄段的高血压比例：');  
disp(averageHypertension);  

% 绘制条形图  
figure;  
bar(categorical(averageHypertension.ageGroup), (1-averageHypertension.mean_hypertension), 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('高血压比例');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)

%%
% 计算各年龄段的平均吸烟量  
averageDiabetes = groupsummary(data_pro4, 'ageGroup', 'mean', 'diabetes');  

% 显示平均吸烟量  
disp('各年龄段的糖尿病比例：');  
disp(averageDiabetes);  

% 绘制条形图  
figure;  
bar(categorical(averageDiabetes.ageGroup), (1-averageDiabetes.mean_diabetes), 'FaceColor', [0 0.5 0.5]);  
xlabel('年龄段');  
ylabel('糖尿病比例');  
%title('各年龄段的平均吸烟量');  
grid on;
set(gca,'FontSize',20)
%%
writetable(data_pro3,'data_pro3.xlsx' );
writetable(data,'data_pro2.xlsx' );
%%

%读入数据
url = "D:\Desktop\聚类分析.xlsx"
Youth_data = xlsread(url,4);
Middle_aged_data = xlsread(url,6);
Elderly_data = xlsread(url,8);
%对青年数据进行分析,青年存在运动性水平低和生活习惯水平偏低的问题
y_p = size(Youth_data,1);
m_p = size(Middle_aged_data,1);
e_p = size(Elderly_data,1);
%运动型水平
Athletic_level_avg = (sum(Middle_aged_data(:,5))+sum(Elderly_data(:,5)))/(m_p+e_p)
%生活习惯
Lifestyle_habits = (sum(Middle_aged_data(:,6))+sum(Elderly_data(:,6)))/(m_p+e_p)
%判断各种情况人群人数
[level1,level2,level3,level4]=Type_judgment(Youth_data,Athletic_level_avg,Lifestyle_habits,5,6)
%运动型水平和生活习惯水平正常
all_normal = level1/y_p;
%运动型水平低
abnormal1 = level2/y_p;
%生活习惯水平低
abnormal2 = level3/y_p;
%二者均低
all_abnormal = level4/y_p;
y_c = [level1,level2,level3,level4];
y_pp = [all_normal abnormal1 abnormal2 all_abnormal];

%对中年数据进行分析,中年人存在吸烟水平和饮酒水平水平偏高的问题
%饮酒水平
Drinking_level_avg = (sum(sum(Youth_data(:,1:2)))+sum(sum(Elderly_data(:,1:2))))/(y_p+e_p)
%吸烟水平
Smoking_level_avg = (sum(sum(Youth_data(:,3:4)))+sum(sum(Elderly_data(:,3:4))))/(y_p+e_p)
%判断各种情况人群人数
[level1,level2,level3,level4]=Type_judgment1(Middle_aged_data,Drinking_level_avg,Smoking_level_avg,1,2,3,4)
%吸烟和喝酒正常
all_normal = level1/m_p;
%喝酒偏高
abnormal1 = level2/m_p;
%吸烟偏高
abnormal2 = level3/m_p;
%吸烟和喝酒均偏高
allm_abnormal = level4/m_p;
m_c = [level1,level2,level3,level4];
m_pp = [all_normal abnormal1 abnormal2 all_abnormal];
%老年人数据分析,老年人血糖和血压偏
%获取 140 90对应的值
%data = get_data(130,80);
data = 0.80977;
[level1,level2,level3,level4]=Type_judgment2(Elderly_data,data,7,15,12);
all_normal = level1/e_p;
%高血压
abnormal1 = level2/e_p;
%糖尿病
abnormal2 = level3/e_p;
%均患有
allm_abnormal = level4/e_p;
o_c = [level1,level2,level3,level4];
o_pp = [all_normal abnormal1 abnormal2 allm_abnormal];