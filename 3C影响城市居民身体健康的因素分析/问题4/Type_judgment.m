function [level1,level2,level3,level4] = Type_judgment(data,ele1,ele2,row1,row2);
Number = size(data,1);
[level1,level2,level3,level4] = deal(0);
for i=1:Number
    if data(i,row1)>=ele1 && data(i,row2)>=ele2
        level1=level1+1;
    elseif data(i,row1)<ele1 && data(i,row2)>=ele2
        level2 = level2+1;
    elseif data(i,row1)>=ele1 && data(i,row2)<ele2
        level3 = level3+1;
    else
        level4=level4+1;
    end
end
        
    
    