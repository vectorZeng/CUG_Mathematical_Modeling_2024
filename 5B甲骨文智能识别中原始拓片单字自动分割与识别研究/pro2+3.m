% data = load('ILOVEYOU.mat');
% T = data.newTable;
% T(1:4,:)
vehicleDataset = matrixData;
pd = 'E:\filereceive\math_model\No.5\code\figs\2_Train';
% Add the full path to the local vehicle data folder.
vehicleDataset.imageFilename = fullfile(pd, vehicleDataset.imageFilename);
T = vehicleDataset;
rng(0);
shuffledIndices = randperm(height(T));
idx = floor(0.6 * length(shuffledIndices) );

trainingIdx = 1:idx;
trainingDataTbl = T(shuffledIndices(trainingIdx),:);

validationIdx = idx+1 : idx + 1 + floor(0.1 * length(shuffledIndices) );
validationDataTbl = T(shuffledIndices(validationIdx),:);

testIdx = validationIdx(end)+1 : length(shuffledIndices);
testDataTbl = T(shuffledIndices(testIdx),:);

imdsTrain = imageDatastore(trainingDataTbl{:,'imageFilename'});
bldsTrain = boxLabelDatastore(trainingDataTbl(:,'oracle'));

imdsValidation = imageDatastore(validationDataTbl{:,'imageFilename'});
bldsValidation = boxLabelDatastore(validationDataTbl(:,'oracle'));

imdsTest = imageDatastore(testDataTbl{:,'imageFilename'});
bldsTest = boxLabelDatastore(testDataTbl(:,'oracle'));

trainingData = combine(imdsTrain,bldsTrain);
validationData = combine(imdsValidation,bldsValidation);
testData = combine(imdsTest,bldsTest);

data = read(trainingData);
I = data{1};
bbox = data{2};
annotatedImage = insertShape(I,'Rectangle',bbox,'LineWidth',5);
annotatedImage = imresize(annotatedImage,2);
figure
imshow(annotatedImage)
inputSize = [224 224 3];
numClasses = width(T)-1;

trainingDataForEstimation = transform(trainingData,@(data)preprocessData(data,inputSize));
numAnchors = 7;
[anchorBoxes, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors)

featureExtractionNetwork = resnet50('Weights','none');
featureLayer = 'activation_40_relu';
lgraph = yolov2Layers(inputSize,numClasses,anchorBoxes,featureExtractionNetwork,featureLayer);

augmentedTrainingData = transform(trainingData,@augmentData);
% Visualize the augmented images.
augmentedData = cell(4,1);

%%
figure
for k = 1:3
    data = read(trainingData);
I = data{1};
bbox = data{2};
annotatedImage = insertShape(I,'Rectangle',bbox,'LineWidth',5);
annotatedImage = imresize(annotatedImage,2);
subplot(1,3,k),
imshow(annotatedImage)
end
figure
montage(augmentedData,'BorderSize',10)


%%
preprocessedTrainingData = transform(augmentedTrainingData,@(data)preprocessData(data,inputSize));
preprocessedValidationData = transform(validationData,@(data)preprocessData(data,inputSize));
data = read(preprocessedTrainingData);
I = data{1};
bbox = data{2};
annotatedImage = insertShape(I,'Rectangle',bbox);
annotatedImage = imresize(annotatedImage,2);
figure
imshow(annotatedImage)

options = trainingOptions('sgdm', ...
        'MiniBatchSize',4, ....
        'InitialLearnRate',1e-4, ...
        'MaxEpochs',10, ... 
        'CheckpointPath',tempdir, ...
        'ValidationData',preprocessedValidationData,...
        'Plots','training-progress');
    
[detector,info] = trainYOLOv2ObjectDetector(preprocessedTrainingData,lgraph,options);
%%

%I = imread('C:\Users\admin\Desktop\demomo\New\image_00004.jpg');
I = imread('E:\filereceive\math_model\No.5\code\figs\3_Test\Figures\w01838.jpg');
 I = repmat(I, [1, 1, 3]);
I = imresize(I,inputSize(1:2));
[bboxes,scores] = detect(detector,I);
I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)

preprocessedTestData = transform(testData,@(data)preprocessData(data,inputSize));
detectionResults = detect(detector, preprocessedTestData);
[ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);
figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f',0.6))
set(gca,'FontSize',20)

%%

jpglength = height(Test_matrixData);
Test_bboxes = cell(100,1);
Test_bboxes1 = cell(100,1);
for i = 1:151
    filename = Test_matrixData(i);
    filename = cell2mat(filename);
    I = imread(filename);
      % I = repmat(I, [1, 1, 3]);
    I = imresize(I,inputSize(1:2));
    [bboxes,scores] = detect(detector,I);
    Test_bboxes{i,1} =bboxes;
    Test_bboxes1{i,1} =mat2str(bboxes);
end

for i = 152:200
    filename = Test_matrixData(i);
    filename = cell2mat(filename);
    I = imread(filename);
       I = repmat(I, [1, 1, 3]);
    I = imresize(I,inputSize(1:2));
    [bboxes,scores] = detect(detector,I);
    Test_bboxes{i,1} =bboxes;
    Test_bboxes1{i,1} =mat2str(bboxes);
end

%%
Test_bboxes_str = table();
for k = 1:200
   

    aaa = cell2mat(Test_bboxes(k,1));

    
    Test_bboxes_str(k,1) =mat2str(aaa);
end
%%
Test_bboxes_table = cell2table(Test_bboxes);
Test_bboxes_table1 = table2(Test_bboxes_table);

writetable(Test_bboxes_table,'Test_bboxes_table.xlsx')
writecell(Test_bboxes1,'Test_bboxes_cell.xlsx')