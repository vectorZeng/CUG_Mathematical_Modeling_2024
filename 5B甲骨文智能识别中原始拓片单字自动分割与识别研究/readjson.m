% 指定包含 JSON 文件的文件夹路径
folderPath = 'E:\filereceive\math_model\No.5\code\figs\2_Train';

% 获取文件夹中所有 JSON 文件的信息
jsonFiles = dir(fullfile(folderPath, '*.json'));

% 创建一个大小为 100x2 的 cell 数组
matrixData = cell(100,2);
% ,'VariableNames',{'imageFilename','oracle'},'VariableTypes',{'string','double'});

% 遍历每个 JSON 文件并将其转换为矩阵数据
for i = 1:numel(jsonFiles)
    % 获取当前 JSON 文件的完整路径
    jsonFile = fullfile(jsonFiles(i).folder, jsonFiles(i).name);
    
    % 加载 JSON 文件
    jsonData = jsondecode(fileread(jsonFile));
    
    % 解析 JSON 数据
    imgName = jsonData.img_name;
    annotations = jsonData.ann;
    
    % 将图片路径添加到第一列
    matrixData{i, 1} = [imgName,'.jpg'];
    
    % 创建一个 table 来存储当前图片的边界框
    bboxTable = [];
    
    % 将边界框数据添加到 table 中
    for j = 1:size(annotations, 1)
        bbox = annotations(j, 1:4);
        % label = annotations(j, 5);
        bboxTable = [bboxTable; bbox];
    end
    
    % 将当前图片的边界框 table 添加到第二列
    matrixData{i, 2} = bboxTable;
end

% 显示前几行数据
disp(matrixData(1:5, :));
matrixData = cell2table(matrixData);
matrixData.Properties.VariableNames = {'imageFilename','oracle'};
%%
% 指定包含 jpg 文件的文件夹路径
folderPath = 'E:\filereceive\math_model\No.5\code\figs\3_Test\Figures';

% 获取文件夹中所有 JSON 文件的信息
jpgFiles = dir(fullfile(folderPath, '*.jpg'));

% 创建一个大小为 100x2 的 cell 数组
Test_matrixData = cell(100,1);
% ,'VariableNames',{'imageFilename','oracle'},'VariableTypes',{'string','double'});

% 遍历每个 JSON 文件并将其转换为矩阵数据
for i = 1:numel(jpgFiles)
    % 获取当前 JSON 文件的完整路径
    jpgFile = fullfile(jpgFiles(i).folder, jpgFiles(i).name);
    

    % 将图片路径添加到第一列
    Test_matrixData{i, 1} = jpgFile;
    
end

% 显示前几行数据
% 
% Test_matrixData = cell2table(Test_matrixData);
% Test_matrixData.Properties.VariableNames = {'imageFilename'};

