
function [lnp] =  mylog(p)
n = length(p);   % 向量的长度
lnp = zeros(n,1);   % 初始化最后的结果
    for i = 1:n   % 开始循环
        if p(i) == 0   % 如果第i个元素为0
            lnp(i) = 0;  % 那么返回的第i个结果也为0
        else
            lnp(i) = log(p(i));  
        end
    end
end