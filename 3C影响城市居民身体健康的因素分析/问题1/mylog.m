
function [lnp] =  mylog(p)
n = length(p);   % �����ĳ���
lnp = zeros(n,1);   % ��ʼ�����Ľ��
    for i = 1:n   % ��ʼѭ��
        if p(i) == 0   % �����i��Ԫ��Ϊ0
            lnp(i) = 0;  % ��ô���صĵ�i�����ҲΪ0
        else
            lnp(i) = log(p(i));  
        end
    end
end