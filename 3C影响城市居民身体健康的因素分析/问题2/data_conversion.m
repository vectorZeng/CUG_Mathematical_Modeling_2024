function new_data = data_conversion(x);
[x,index] = sort(x);
[row,col] = size(x);
count = 0;
for i=1:row
    if i == 1
        if x(i) == x(i+1)
            count = count+1;
        else
            y(i) = 1;
        end
    elseif i == row
        if count ~= 0
            y(i-count:i) = sum(i-count:i)/(count+1);
        else
            y(i) = row;
        end
    elseif count == 0
        %前面没有重复数据
        if x(i) == x(i+1)
            count = count+1;
        else
            y(i) = i;
        end
    else
        %与后一个数据重复
        if x(i) == x(i+1)
            count = count+1;
        else
            %后一个数据不重复
            y(i-count:i) = sum(i-count:i)/(count+1);
            count = 0;
        end
    end
end
for i = 1:row
    new_data(index(i)) = y(i);
end
        
            