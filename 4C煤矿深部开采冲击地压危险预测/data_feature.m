function feature = data_feature(data)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
range_C = max(data) - min(data);  
mean_C = mean(data);  
std_C = std(data);  
med_C = median(data);
mod_C = mode(data);
cv_C = std_C/mean_C*100;

feature(1) = range_C ;
feature(2) = mean_C ;  
feature(3) = std_C ;  
feature(4) = med_C ;
feature(5) = mod_C;
feature(6) =   std_C/mean_C*100;
disp(['数据的峰峰值: ', num2str(range_C)]);  
disp(['数据的均值: ', num2str(mean_C)]);  
disp(['数据的标准差: ', num2str(std_C)]);
disp(['数据的中位数: ', num2str(mod_C)]);
disp(['数据的众数: ', num2str(med_C)]);
disp(['数据的变异系数: ', num2str(cv_C)]);
end

