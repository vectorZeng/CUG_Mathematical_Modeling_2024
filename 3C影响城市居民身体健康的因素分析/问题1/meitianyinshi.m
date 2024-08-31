function zhibiao3 = meitianyinshi(qishi,row,new1,danwei)
zhibiao3 = zeros(row,1);
%global new1
for i = 1:row
    %145
    if new1(i,qishi) ~=1
        zhibiao3(i,1) = 0;
        continue;
    else
        if new1(i,qishi+1)
            zhibiao3(i,1) = new1(i,qishi+1)*danwei*new1(i,qishi+4);
        elseif new1(i,qishi+2)
            zhibiao3(i,1) = (new1(i,qishi+2)*danwei)*new1(i,qishi+4)/7;
        elseif new1(i,qishi+3)
            zhibiao3(i,1) = (new1(i,qishi+3)*danwei)*new1(i,qishi+4)/28;
        end
    end
end