drink = new1(:,19).*new1(:,20) + 0.5*new1(:,22).*new1(:,23) ...
    + 0.3*new1(:,25).*new1(:,26) +0.1*(new1(:,28).*new1(:,29) + new1(:,31).*new1(:,32));
%%
data_pro3 = readtable('raw_data.xlsx','Sheet','pro3');

rows_to_delete = find((data_pro3.diabetes == 0)|(data_pro3.hypertension == 0));  

% 删除这些行  
data_pro3(rows_to_delete, :) = []; 


data_pro3.career = dummyvar(categorical(data_pro3.career));  
%%
% 将hypertension列转换为逻辑变量（1: 有, 0: 没）  
data_pro3.hypertension = data_pro3.hypertension - 1;  % 将2变为1，将1变为0  
data_pro3.diabetes = data_pro3.diabetes - 1;  % 将2变为1，将1变为0

%%
X_pro3 = [data_pro3.dietary,data_pro3.lifestyle,data_pro3.smoke,data_pro3.exercise,data_pro3.drink,data_pro3.career];
% 逻辑回归模型  
%mdl = fitglm(data_pro3, 'hypertension ~ dietary + lifestyle + smoke + exercise + drink + career', 'Distribution', 'binomial');  
mdl_h = fitglm(X_pro3,data_pro3.hypertension, 'Distribution', 'binomial');
% 显示模型分析结果  
disp(mdl); 
figure
plot(mdl_h.Coefficients.pValue,'*',LineWidth=1.5)
hold on
a = 0.05*ones(1,18);
plot(a,'r-',LineWidth=1.5)
legend('p值','阈值')
xlabel('哑变量')
ylabel('相关性p值')
set(gca,'FontSize',20)
%%
mdl_d = fitglm(X_pro3,data_pro3.diabetes, 'Distribution', 'binomial');
% 显示模型分析结果  
disp(mdl); 
figure
plot(mdl_d.Coefficients.pValue,'*',LineWidth=1.5)
hold on
a = 0.05*ones(1,19);
plot(a,'r-',LineWidth=1.5)
legend('p值','阈值')
xlabel('哑变量')
ylabel('相关性p值')
set(gca,'FontSize',20)


%%

%%
clear;clc
%导入饮酒数据新型处理
% data_title = ["是否饮酒","饮酒年数","高度每周白酒饮用量","低度每周白酒饮用量","啤酒每周饮用量","黄酒、糯米酒每周饮用量","葡萄每周酒引用量"];
data_title = ["是否饮酒","饮酒年数","每周饮酒量"]
url = 'D:\Desktop\饮酒.xlsx';
data = xlsread(url);
[row,col] = size(data);
Drinking = zeros(row,1);
for i=1:row
    count = 1;
    sum = 0;
    if data(i,2) == 99
        data(i,2) = mean(data(:,2));
    end
    for j=4:3:col
        sum = sum + data(i,j)*data(i,j+1)*50;
        count=count+1;
    end
    Drinking(i) = sum;
end
a = [data(:,1) data(:,2) Drinking];
xlswrite('D:\Desktop\饮酒处理后数据.xlsx',[data_title;[data(:,1) data(:,2) Drinking]])
clear;clc
[row,col] = size(data);
score = zeros(row,1);
for i = 1:row
    if data(i,1) == 1
        score(i) = 0;
    elseif data(i,1) == 2
        score(i) = 1.5*data(i,2);
    elseif data(i,1) ==3
        score(i) = 4*data(i,2);
    elseif data(i,1) == 4
        score(i) = 6*data(i,2);
    end
end
        
        