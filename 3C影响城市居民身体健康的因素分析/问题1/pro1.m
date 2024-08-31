
%% 数据预处理
clc;clear
url = 'raw_data.xlsx';
data = readtable(url);
text = table2array(data);
[row,col] = size(text);
panduan = zeros(row,1);
%15 33 197
text = [text(:,1:14) panduan text(:,15:col)];
text = [text(:,1:32) panduan text(:,33:col+1)];
text = [text(:,1:196) panduan text(:,197:col+2)];
%数据预处理
[row,col] = size(text);
%方便数据处理,将所有的NAN值转换为0
text(find(isnan(text)==1)) = 0;
for i=1:row
    %处理异常值
    %吸烟
    if text(i,9) == 3
        if text(i,10) > 0 || text(i,11) > 0 || text(i,12) > 0
            text(i,15) = -1;
        end
    end
    %饮酒
    if text(i,16) == 2
        if sum(text(i,17:32)) > 0
            text(i,33) = -1;
        end
    end
    %处理缺失值
    %吸烟
    if text(i,9) == 0
        if text(i,10) > 0 || text(i,11) > 0 || text(i,12) > 0
            text(i,1) = 1;
        else
            text(i,1) = 3;
        end
    end
    if text(i,16) == 0
        if sum(text(i,17:32)) > 0
            text(i,1) = 1;
        else
            text(i,1) = 2;
        end
    end
end
%饮食
%是否吃 天/次 周/次 月/次 平均每次的摄入量
[row,col] = size(text);
for i=1:row
    for j = 55:5:197-8
        %处理错误值
        if text(i,j) == 1
            if text(i,j+1)+text(i,j+2)+text(i,j+3) == 0 || text(i,j+4) == 0
                text(i,197) = -1;
                break;
            end
        end
        %处理缺失值
        if text(i,j) == 0
            %存在摄入频率即为1
            if text(i,j+1)+text(i,j+2)+text(i,j+3)> 0
                text(i,j) = 1;
            else
                text(i,j) = 2;
            end
        end
    end
end

%去除掉无法计算家庭人数的数据
for i = 1:row
    if text(i,39)+text(i,40)+text(i,46)+text(i,47)+text(i,53)+text(i,54) == 0
        text(i,197) = -1;
    end
end

%去除吃的太多的数据
for i = 1:row
    if  text(i,146) > 4 || text(i,149) > 15 ||text(i,192) >105 ...
        || text(i,179) >50 ||text(i,106) >4 ||text(i,111) >4 || text(i,109) >100 || text(i,119) >100 
        text(i,197) = -1;
    end
end


%去除年龄不合理的和年龄偏大的,其他指标不合理的
for i = 1:row
    if text(i,2) <=1943 || text(i,225) <=130 || text(i,226)<=35 || text(i,226)>=140
       text(i,197) = -1;
    end
    if find(text(i,227:col) == 0)
        text(i,197) = -1;
    end

end

t = 1;
for i = 1:1:row
     if(text(i,15) > -1 && text(i,33) > -1 && text(i,197) > -1)
         new1(t,:) = text(i,:); 
         t = t + 1;
     end
end

%获得预处理后的数据new1 进行处理
[row,col] = size(new1);


%% 得出所有指标数据
%指标1:每天摄入12种以上食物计数
zhibiao1 = zeros(row,1);
for i=1:row%从第一个到最后一个居民
    count = 0;
    for j = 55:5:197-8
        if new1(i,j+1) ~= 0
            %判断天数
            count= count+1;
        elseif new1(i,j+2) >= 7
            %平均每天吃一次
            count=count+1;
        elseif new1(i,j+3)>=28
            %一个月看做是28天,平均每天一次
            count=count+1;
        end
    end
    for j=190:196
        if new1(i,j) > 0
            count=count+1;
        end
    end    
    zhibiao1(i,1) = count;
end
%指标2 每周摄入25种以上
zhibiao2 = zeros(row,1);
for i=1:row%从第一个到最后一个居民
    count = 0;
    for j = 55:5:197-8
        if new1(i,j+1) ~= 0
            %判断天数
            count= count+1;
        elseif new1(i,j+2) ~= 0
            %每周都吃
            count=count+1;
        elseif new1(i,j+3)>=4
            %一个月看做是28天,至少平均每周一次
            count=count+1;
        end
    end
    for j=190:196
        if new1(i,j) > 0
            count=count+1;
        end
    end    
    zhibiao2(i,1) = count;
end
%指标3 保证每天摄入不少于300g的新鲜蔬菜
zhibiao3 = meitianyinshi(145,row,new1,50);
%指标4 保证每天摄入200~350g的新鲜水果，果汁不能代替鲜果  
zhibiao4 = meitianyinshi(175,row,new1,50);   
%指标5 吃各种各样的奶制品，与第四版相比最高摄入量由原来的300g提高到500g
%奶粉 鲜奶 酸奶
zhibiao5 = meitianyinshi(105,row,new1,50)+meitianyinshi(110,row,new1,10)+meitianyinshi(115,row,new1,50);
%指标6:鱼禽、蛋类和瘦肉摄入要适量，平均每天120~200g
%80 
zhibiao6 = meitianyinshi(80,row,new1,50)+meitianyinshi(85,row,new1,50)+meitianyinshi(90,row,new1,50)...
    +meitianyinshi(100,row,new1,50)+meitianyinshi(120,row,new1,50);
%指标7:成人每天摄入烹调油25~30g
%将三餐就餐的平均人数四舍五入作为其家庭成员人数
zhibiao7 = jiatingyinshipanduan(190,row,new1,500)+jiatingyinshipanduan(191,row,new1,500);
% zhibiao7 = (植物油和动物油)
%指标8:食用盐＜5g
zhibiao8 = jiatingyinshipanduan(192,row,new1,50);

%指标9:饮食规律 不吃早餐+中餐+晚餐
zhibiao9 = new1(:,34);

%指标10:吸烟与否
% （可以删）
zhibiao10 = new1(:,9);


%指标11 :饮酒与否
zhibiao11 = new1(:,16);
zhibiao11((zhibiao11 == 3)|(zhibiao11 == 0)) = 2; 



%% 数据可视化

%指标1:每天摄入12种以上食物计数
figure
% 绘制直方图  
h = histogram(zhibiao1, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的食物计数');  
ylabel('频数');  
%title('直方图示例');  

set(gca,'FontSize',20)


count_le12food = sum(zhibiao1 <= 12);  % 统计 <=12种食物 的数量  
count_g12food = sum(zhibiao1 >12);      % 统计 >12种食物 的数量


% 绘制饼状图  
figure; 
piechart([count_le12food,count_g12food], {'不足12种', '大于12种'}); % 创建饼状图并标记图例  
%title('每天摄入的食物不足12种和大于12种的比例'); % 添加标题  
set(gca,'FontSize',20)

%%


%指标2:每周摄入25种以上
figure
% 绘制直方图  
h = histogram(zhibiao2, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每周摄入的食物种类计数');  
ylabel('频数');  
%title('直方图示例');  

set(gca,'FontSize',20)



count_le25food = sum(zhibiao2 <= 25);  % 统计 <=12种食物 的数量  
count_g25food = sum(zhibiao2 >25);      % 统计 >12种食物 的数量


% 绘制饼状图  
figure; 
piechart([count_le25food,count_g25food], {'不足25种', '大于25种'}); % 创建饼状图并标记图例  
%title('每周摄入的食物不足25种和大于25种的比例'); % 添加标题  
set(gca,'FontSize',20)

%%
%指标3:保证每天摄入不少于300g的新鲜蔬菜
figure
% 绘制直方图  
h = histogram(zhibiao3, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的新鲜蔬菜重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le300vega = sum(zhibiao3 <= 300);  % 统计 <=12种食物 的数量  
count_g300vega = sum(zhibiao3 >300);      % 统计 >12种食物 的数量


% 绘制饼状图  
figure; 
piechart([count_le300vega,count_g300vega], {'不足300g', '大于300g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)


%%
%指标4:保证每天摄入不少于200g的新鲜水果
figure
% 绘制直方图  
h = histogram(zhibiao4, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的新鲜水果重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le200fruit = sum(zhibiao4 <= 200);  % 统计 <=12种食物 的数量  
count_g200fruit = sum(zhibiao4 >200);      % 统计 >12种食物 的数量


% 绘制饼状图  
figure; 
piechart([count_le200fruit,count_g200fruit], {'不足200g', '大于200g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%%
%指标5: 保证奶制品200~500
figure
% 绘制直方图  
h = histogram(zhibiao5, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的奶制品重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le200milk = sum(zhibiao5 <= 200);  % 统计 <=200 的数量  
count_g200le500milk = sum((zhibiao5 >200) &( zhibiao5 <500));      % 统计 200~500 的数量
count_g500milk = sum( zhibiao5 >500);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_le200milk,count_g200le500milk,count_g500milk], {'不足200g', '大于200g小于500g','大于500g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)


%%
%指标6: 保证肉蛋奶120~200
figure
% 绘制直方图  
h = histogram(zhibiao6, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的鱼蛋肉重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le120meat = sum(zhibiao6 <= 120);  % 统计 <=200 的数量  
count_g120le200meat = sum((zhibiao6 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_g200meat = sum( zhibiao6 >200);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_le120meat,count_g120le200meat,count_g200meat], {'不足120g', '大于120g小于200g','大于200g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%%
%指标7:成人每天摄入烹调油25~30g
%将三餐就餐的平均人数四舍五入作为其家庭成员人数

figure
% 绘制直方图  
h = histogram(zhibiao7, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的烹调油重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le25oil = sum(zhibiao7 <= 25);  % 统计 <=200 的数量  
count_g25le30oil = sum((zhibiao7 >25) &( zhibiao7 <30));      % 统计 200~500 的数量
count_g30oil = sum( zhibiao7 >30);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_le25oil,count_g25le30oil,count_g30oil], {'不足25g', '大于25g小于30g','大于30g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

% zhibiao7 = (植物油和动物油)

%%
%指标8:食用盐＜5g
figure
% 绘制直方图  
h = histogram(zhibiao8, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每天摄入的食用盐重量（g）');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)


count_le5salt = sum(zhibiao8 <= 5);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_g5salt = sum( zhibiao8 >5);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_le5salt,count_g5salt], {'不足5g', '大于5g'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%%
%指标9:饮食规律 吃早餐
figure
% 绘制直方图  
h = histogram(zhibiao9, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每周不吃早餐的次数');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)
count_breakfast = sum(zhibiao9 ==0);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_nobreakfast = sum( zhibiao9 >0);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_breakfast,count_nobreakfast], {'吃早餐', '不吃早餐'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)


%%
%指标9:饮食规律 吃早餐
figure
% 绘制直方图  
h = histogram(zhibiao9, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每周不吃早餐的次数');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)
count_breakfast = sum(zhibiao9 ==0);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_nobreakfast = sum( zhibiao9 >0);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_breakfast,count_nobreakfast], {'吃早餐', '不吃早餐'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)


%%
% 吸烟
count_smoke = sum(zhibiao10 == 1);  % 统计 吸烟 的数量  
count_unsmoke = sum(zhibiao10 == 3);      % 统计 不吸烟 的数量
count_quitsmoke = sum(zhibiao10 == 2);      % 统计 不吸烟 的数量

% 绘制饼状图  
figure; 
piechart([count_smoke,count_unsmoke,count_quitsmoke], {'吸烟', '不吸烟','戒烟'}); % 创建饼状图并标记图例  
%title('吸烟，不吸烟，戒烟所占比例'); % 添加标题  
set(gca,'FontSize',20)

%%
% 指标11:喝酒
count_alcohol = sum(zhibiao11 == 1);  % 统计 喝酒 的数量  
count_unalcohol = sum(zhibiao11 == 2);      % 统计 不喝酒 的数量  

% 绘制饼状图  
figure; 
piechart([count_alcohol,count_unalcohol], {'喝酒', '不喝酒'}); % 创建饼状图并标记图例  
%title('喝酒和不喝酒所占比例'); % 添加标题  
set(gca,'FontSize',20)


%%
%体育锻炼
figure
% 绘制直方图  
h = histogram(data_pro4.exercise, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('每周的体育锻炼量');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)
count_exercise_meet = sum(data_pro4.exercise >150);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_exercise_notmeet = sum( data_pro4.exercise <150);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_exercise_meet,count_exercise_notmeet], {'体育锻炼量达标', '体育锻炼量不达标'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%%
%家务
lifestyle =  readtable("raw_data.xlsx",'Sheet','生活习惯'); 
figure
% 绘制直方图  
h = histogram(lifestyle.homework, 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('家务类型');  
ylabel('频数');  
%title('每天摄入的新鲜蔬菜重量（g）');  

set(gca,'FontSize',20)
count_home1 = sum(lifestyle.homework == 1);  % 统计 <=200 的数量  

count_home2 = sum(lifestyle.homework == 2);  % 统计 <=200 的数量  
count_home3 = sum(lifestyle.homework == 3);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
%count_exercise_notmeet = sum( data_pro4.exercise <150);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_home1 ,count_home2 ,count_home3 ], {'轻度', '中度','重度'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%% 1.对各项指标进行正向化处理
zhibiao_raw = [zhibiao1 zhibiao2 zhibiao3 zhibiao4 zhibiao5 zhibiao6 zhibiao7 zhibiao8 zhibiao9  zhibiao11];
zhibiao_raw = [zhibiao_raw; 13 26 300 200 200 120 25 2.5 1 2];
row = row+1;
%指标3、4、6、7、9属于区间型
% 
% zhibiao3e = Inter2Max(zhibiao3,300,500);
% zhibiao4e = Inter2Max(zhibiao4,200,350);
% zhibiao5e = Inter2Max(zhibiao5,300,500);
% zhibiao6e = Inter2Max(zhibiao6,120,200);
% zhibiao7e = Inter2Max(zhibiao7,25,30);

zhibiao3e = Inter2Max(zhibiao_raw(:,3),300,1000);
zhibiao4e = Inter2Max(zhibiao_raw(:,4),200,1000);
zhibiao5e = Inter2Max(zhibiao_raw(:,5),300,500);
zhibiao6e = Inter2Max(zhibiao_raw(:,6),120,200);
zhibiao7e = Inter2Max(zhibiao_raw(:,7),25,30);
%指标1 2当做极大型处理
zhibiao1e = normalize(zhibiao_raw(:,1), 'range');
zhibiao2e = normalize(zhibiao_raw(:,2), 'range');
zhibiao9e = normalize(-zhibiao_raw(:,9), 'range');
%zhibiao10e = normalize(zhibiao10, 'range');
zhibiao11e = normalize(zhibiao_raw(:,10), 'range');

%指标8特殊处理
zhibiao8e = teshuchuli(zhibiao_raw(:,8),5);
%2.归一化处理
zhibiao = [zhibiao1e zhibiao2e zhibiao3e zhibiao4e zhibiao5e zhibiao6e zhibiao7e zhibiao8e zhibiao9e  zhibiao11e];
%zhibiao = zhibiao ./ repmat(sum(zhibiao.*zhibiao) .^ 0.5, row, 1);
%3.利用熵权法计算各项指标的权重
W = Entropy_Method(zhibiao);
%4.计算最终得分
zuidajuli = sum([(zhibiao - repmat(max(zhibiao),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D+ 与最大值的距离向量
zuixiaojuli = sum([(zhibiao - repmat(min(zhibiao),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D- 与最小值的距离向量
score = zuixiaojuli ./ (zuidajuli+zuixiaojuli);    % 未归一化的得分
%%
figure
% 绘制直方图  
h = histogram(score(2:end), 'Normalization', 'count');  


% 为直方图添加标签（可选）  
xlabel('饮食习惯的合理性评分');  
ylabel('频数');  
%title('饮食习惯的合理性评分');  

set(gca,'FontSize',20)
count_reasonable = sum(score >= 0.7428);  % 统计 <=200 的数量  
%count_g120le200meat = sum((zhibiao8 >120) &( zhibiao6 <200));      % 统计 200~500 的数量
count_unreasonable = sum(score < 0.7428);      % 统计 >500 的数量

% 绘制饼状图  
figure; 
piechart([count_reasonable,count_unreasonable], {'合理', '不合理'}); % 创建饼状图并标记图例  
%title('每天摄入的新鲜蔬菜重量不足300g和大于300g的比例'); % 添加标题  
set(gca,'FontSize',20)

%5.将分数按照从高到低的顺序进行排序
%[score,index] = sort(score,'descend');
%去除加入的辅助行
%new1 = [new1(:,1:14)  new1(:,16:32) new1(:,34:196) new1(:,198:col)];