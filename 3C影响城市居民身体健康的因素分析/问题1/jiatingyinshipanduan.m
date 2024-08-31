function zhibiao3 = jiatingyinshipanduan(qishi,row,new1,danwei)
zhibiao3 = zeros(row,1);
for i = 1:row
    %计算家庭人数
    renshu = ceil((new1(i,39)+new1(i,40)+new1(i,46)+new1(i,47)+new1(i,53)+new1(i,54))/6);
    zhibiao3(i) = (new1(i,qishi)*danwei)/(28*renshu);
end
