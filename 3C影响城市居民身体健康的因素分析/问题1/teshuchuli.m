function zhibiao = teshuchuli(x,max1)
M = max(x)-max1;
[row,col] = size(x);
zhibiao = zeros(row,1);
for i=1:row
    if x(i)<max1
        zhibiao(i) = 1;
    else
        zhibiao(i) = 1-(x(i)-max1)/M;
    end
end