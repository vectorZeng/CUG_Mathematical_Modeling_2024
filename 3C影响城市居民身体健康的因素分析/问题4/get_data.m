function data = get_data(x1,x2);
url = 'D:\Desktop\高血压.xlsx';
data = xlsread(url,2);
[row,col] = size(data);
index_x = find(data(:,1)==x1);
index_y = find(data(:,2)==x2);
if size(index_x,1)>size(index_y,1)
    index = find(index_x(1:size(index_y,1),1) == index_y);
    value_index = index_x(index)
else
    index = find(index_y(1:size(index_x,1),1) == index_x);
    value_index = index_x(index)
end
data = data(value_index,3)