%% 聚类 分3类
% 选择最佳聚类数
optimal_clusters = 3; % 根据图形选择的最佳聚类数

% 执行K-means聚类
[idx, C] = kmeans(features, optimal_clusters, 'Replicates', 10);
%% after 手动调整

% 绘制聚类结果
figure;
gscatter(x_node,y_node,idx);
hold on
scatter(C(:,1),C(:,2),'filled','green')
hold on;
xlabel('X坐标');
ylabel('Y坐标');
title('K-means聚类结果');
legend('Cluster 1', 'Cluster 2','Cluster 3','配送站');
grid on;
hold off;
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 15);

%% 画图


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

end_node1 = [];

dist1 = [];
for i = 1:140
    if all(ismember(node_ways(i,:),cluster1)) || all(ismember(node_ways(i,:),cluster2)) || all(ismember(node_ways(i,:),cluster3))
         start_node1 = [start_node1,start_node(i)];
         end_node1 = [end_node1,end_node(i)];
         dist1 = [dist1,dist(i)];
    end   
    % if ismember(node_ways(i),cluster2)
    %      start_node2 = [start_node2,start_node(i)];
    %      end_node2 = [end_node2,end_node(i)];
    %      dist2 = [dist2,dist(i)];
    % end
    % if ismember(node_ways(i),cluster3)
    %      start_node3 = [start_node3,start_node(i)];
    %      end_node3 = [end_node3,end_node(i)];
    %      dist3 = [dist3,dist(i)];
    % end
end

s_c1 = start_node1;
t_c1 = end_node1;
w_c1 = dist1;

G1 = graph(s_c1,t_c1,w_c1);%无向图


%求出距离和
D_c3 = distances(G1);
D_c3(isinf(D_c3)) = 0;

% 计算每一行的和, 找出和最小的行
row_sums = sum(D_c3, 2);

for i = 1:3

 clusterIndices = (idx == i);

    if i == 1
        row_sums_1 = row_sums(clusterIndices);
        [min_sum(i), min_row(i)] = min(row_sums_1);
        cluster_min_num(i,:) = [cluster1(min_row(i)),min_sum(i)];  %每个聚类的配送站，即其距离和
    end
    if i == 2
        row_sums_2 = row_sums(clusterIndices);
        [min_sum(i), min_row(i)] = min(row_sums_2);
        cluster_min_num(i,:) = [cluster2(min_row(i)),min_sum(i)];
    end
    if i == 3
        row_sums_3 = row_sums(clusterIndices);
        [min_sum(i), min_row(i)] = min(row_sums_3);
        cluster_min_num(i,:) = [cluster3(min_row(i)),min_sum(i)];
    end
end

%配送站
center_idx = cluster_min_num(:,1);  

% 距离和
Sum_dist_3 = sum(cluster_min_num(:,2));

%%
figure
myplot = plot(G1,'EdgeLabel', G1.Edges.Weight, 'linewidth', 2) ;
highlight(myplot, cluster_min_num(:,1), 'NodeColor', 'g')
%set( gca, 'XTick', [], 'YTick', [] );  
hold on

for j = 1:3
for i = 1:92
    [S_P,d] = shortestpath(G1,cluster_min_num(j,1),i);
  
    writematrix(S_P,'Cluster_short.xls','WriteMode','append')
    % 在图中高亮我们的最短路径
    highlight(myplot,S_P, 'EdgeColor', 'r')   %对这个变量即我们刚刚绘制的图形进行高亮处理（给边加上r红色）
    hold on
end
end

%% 实际地理图
figure;
%绘制城市坐标散点图
for i=1:92
    %将前20号的直销中心单独标出
        plot(location(i,1),location(i,2),'b.','MarkerSize',15)%坐标点用蓝色点表示
        text(location(i,1),location(i,2),num2str(node_location(i,1)),'FontSize',15);%标记城市标号
        hold on;
end

%连接各城市间的公路
for i=1:140
    start_x=[location(node_ways(i,1),1),location(node_ways(i,2),1)];%起始城市的横坐标与结束城市的横坐标
    end_y=[location(node_ways(i,1),2),location(node_ways(i,2),2)];%起始城市的纵坐标与结束城市的纵坐标
    plot(start_x,end_y,'b-','LineWidth',1.5)%画线
    hold on;
end

P= xlsread('Cluster_short.xls');
for i=1:92
    len = find(~isnan(P(i,:)));
    for j=1:length(len)-1
    start_x=[location(P(i,j),1),location(P(i,j+1),1)];%起始城市的横坐标与结束城市的横坐标
    end_y=[location(P(i,j),2),location(P(i,j+1),2)];%起始城市的纵坐标与结束城市的纵坐标
    plot(start_x,end_y,'r-','LineWidth',1.5)%画线
    hold on;
    end
end  
%将配送中心单独标记出来，方便区分
%计算出配送中心的标号为城市
plot(location(47,1),location(47,2),'g.','MarkerSize',17) %坐标点用绿色*表示
plot(location(1,1),location(1,2),'g.','MarkerSize',17) %坐标点用绿色*表示
plot(location(11,1),location(11,2),'g.','MarkerSize',17) %坐标点用绿色*表示

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


