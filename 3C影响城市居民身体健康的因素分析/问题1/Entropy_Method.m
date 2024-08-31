function [W] = Entropy_Method(Z)
%% 计算熵权
    [n,m] = size(Z);
    D = zeros(1,m);  % 初始化保存信息效用值的行向量
    for i = 1:m
        x = Z(:,i);  % 取出第i列的指标
        p = x / sum(x);
        % 注意，p有可能为0，此时计算ln(p)*p时，Matlab会返回NaN，所以这里我们自己定义一个函数
        e = -sum(p .* mylog(p)) / log(n); % 计算信息熵
        D(i) = 1- e; % 计算信息效用值
    end
    W = D ./ sum(D);  % 将信息效用值归一化，得到权重    
end