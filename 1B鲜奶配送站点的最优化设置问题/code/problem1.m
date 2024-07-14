%% 读取数据

node_location = xlsread('data.xls',"鲜奶网点的位置、订货量");
node_ways = xlsread('data.xls',"鲜奶网点之间的道路");
node_num = node_location(:,1);  % 网点编号
x_node = node_location(:,2);    %网点x坐标
y_node = node_location(:,3);    %网点y坐标

location = [x_node, y_node];    %网点坐标

start_node = node_ways(:,1);    %起始网点
end_node = node_ways(:,2);      %终点


%% 构建邻接矩阵，画图


matrix=zeros(92,92);
for i = 1:140
    X=node_ways(i,1);
    Y=node_ways(i,2);
    matrix(X,Y)=1;
    matrix(Y,X)=1;
end


gplot(matrix,location,"-*")
%% 全距离矩阵

dist_all=zeros(92,92);    % 距离矩阵
 
for i = 1:92
    for j = 1:92
        if i ~= j
            % 计算网点i和网点j之间的距离
            dist_all(i, j) = sqrt((location(i, 1) - location(j, 1))^2 + (location(i, 2) - location(j, 2))^2);
        end
    end
end



%% 构建距离矩阵
%计算公路的起点城市与公路的终点城市的距离
dist = zeros(1,140);
for i=1:140
    sx=location(start_node(i),1);%起始城市的横坐标
    ex=location(end_node(i),1);%终止城市的横坐标
    sy=location(start_node(i),2);%起始城市的纵坐标
    ey=location(end_node(i),2);%终止城市的纵坐标
    dist(i)=sqrt(abs(sx-ex)^2+abs(sy-ey)^2);%勾股定理求距离
end

s = start_node';
t = end_node';
w = dist;

G = graph(s,t,w);       %无向图
 %G = digraph(s,t,w);   %有向图

figure
plot(G, 'EdgeLabel', G.Edges.Weight, 'linewidth', 2) 
set( gca, 'XTick', [], 'YTick', [] );  

%% 

%这个D值在第二三问中要用到
D = distances(G); % D为两两节点之间的最短距离
temp = 0;
for i=1:92
    for j=1:92
        temp = temp+D(i,j);
    end
    acc_dist(i) = temp;
    temp = 0;
end
format long g
index = find(acc_dist==min(acc_dist))
Sum_dist_1 = min(acc_dist);
%Q = zeros(92,20);
myplot = plot(G, 'EdgeLabel', G.Edges.Weight, 'linewidth', 2);  %首先将图赋给一个变量
highlight(myplot, index, 'NodeColor', 'g')
for i=1:92
    [P,d] = shortestpath(G,index,i);
  
    writematrix(P,'M.xls','WriteMode','append')
    % 在图中高亮我们的最短路径
    highlight(myplot, P, 'EdgeColor', 'r')   %对这个变量即我们刚刚绘制的图形进行高亮处理（给边加上r红色）
    hold on
end


%% 实际地理图
figure;
%绘制城市坐标散点图
for i=1:92
    %将前20号的直销中心单独标出
        plot(location(i,1),location(i,2),'b.','MarkerSize',15)%坐标点用蓝色点表示
        text(location(i,1),location(i,2),num2str(node_location(i,1)),'FontSize',8);%标记城市标号
        hold on;
end

%连接各城市间的公路
for i=1:140
    start_x=[location(node_ways(i,1),1),location(node_ways(i,2),1)];%起始城市的横坐标与结束城市的横坐标
    end_y=[location(node_ways(i,1),2),location(node_ways(i,2),2)];%起始城市的纵坐标与结束城市的纵坐标
    plot(start_x,end_y,'b-','LineWidth',1.2)%画线
    hold on;
end
%%
P= xlsread('M.xls');
for i=1:92
    len = find(~isnan(P(i,:)));
    for j=1:length(len)-1
    start_x=[location(P(i,j),1),location(P(i,j+1),1)];%起始城市的横坐标与结束城市的横坐标
    end_y=[location(P(i,j),2),location(P(i,j+1),2)];%起始城市的纵坐标与结束城市的纵坐标
    plot(start_x,end_y,'r-','LineWidth',1.2)%画线
    hold on;
    end
end  
%将配送中心单独标记出来，方便区分
%计算出配送中心的标号为城市3
plot(location(3,1),location(3,2),'gp','MarkerSize',10) %坐标点用绿色*表示

%% 需要的运输车数量
data = P;
for i = 1:92
    len = length(find(~isnan(data(i,:))));
    currentRow = data(i,1:len);
    for j = 1:size(data, 1)
        %len = length(find(~isnan(data(j,:))));
        nextRow = data(j,1:length(find(~isnan(data(j,:)))));
        if (length(currentRow) < length(nextRow)) && isequal(currentRow, nextRow(1:length(currentRow)))
            % 删除被包含的行
            data(i,:) = [0];
            break; % 跳出内层循环
        end
    end
   
end
zero_rows = all(data == 0, 2);

% 删除全部为0的行
car_num = data(~zero_rows, :);  
%% 肘部图

features = location;

% 肘部法确定聚类数
sum_of_squared_distances = [];
max_clusters = 10;

for k = 1:10
    [~, w, sumd] = kmeans(features, k, 'Replicates', 10);
    sum_of_squared_distances = [sum_of_squared_distances; sum(sumd) ];
end
%绘制肘部法
figure;
plot(1:max_clusters, sum_of_squared_distances, '-o','LineWidth',1.2);
xlabel('聚类数K');
ylabel('总的平方距离和');
title('肘部法确定聚类数');
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 15);

%% 聚类
% 选择最佳聚类数
optimal_clusters= 3; % 根据图形选择的最佳聚类数

% 执行K-means聚类
[idx, C] = kmeans(features, optimal_clusters, 'Replicates', 10);

% 绘制聚类结果
figure;
gscatter(x_node,y_node,idx);
%scatter(C(:,1),C(:,2),'filled','green')
hold on;
xlabel('X坐标');
ylabel('Y坐标');
title('K-means聚类结果');
legend('Cluster 1', 'Cluster 2', 'Cluster 3','配送站');
grid on;
hold off;
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 15);

%% 


for i = 1:3
    clusterIndices = (idx == i);
    if i == 1
        cluster1 = node_num(clusterIndices);
    end
    if i == 2
        cluster2 = node_num(clusterIndices);
    end
    if i == 3
        cluster3 = node_num(clusterIndices);
    end
end

start_node1 = [];
start_node2 = [];
start_node3 = [];
end_node1 = [];
end_node2 = [];
end_node3 = [];
dist1 = [];
dist2 = [];
dist3 = [];
for i = i:140
    if ismember(node_ways(i),cluster1)
         start_node1 = [start_node1,start_node(i)];
         end_node1 = [end_node1,end_node(i)];
         dist1 = [dist1,dist(i)];
    end   
    if ismember(node_ways(i),cluster2)
         start_node2 = [start_node2,start_node(i)];
         end_node2 = [end_node2,end_node(i)];
         dist2 = [dist2,dist(i)];
    end
    if ismember(node_ways(i),cluster3)
         start_node3 = [start_node3,start_node(i)];
         end_node3 = [end_node3,end_node(i)];
         dist3 = [dist3,dist(i)];
    end
end

s_c1 = start_node1;
t_c1 = end_node1;
w_c1 = dist1;

G1 = graph(s_c1,t_c1,w_c1);%无向图
 %G = digraph(s,t,w);%有向图
 s_c2 = start_node2;
t_c2 = end_node2;
w_c2 = dist2;

G2 = graph(s_c2,t_c2,w_c2);%无向图

s_c3 = start_node3;
t_c3 = end_node3;
w_c3 = dist3;

G3 = graph(s_c3,t_c3,w_c3);%无向图

figure
plot(G2,'EdgeLabel', G2.Edges.Weight, 'linewidth', 2) 
set( gca, 'XTick', [], 'YTick', [] );  
hold on

%end





