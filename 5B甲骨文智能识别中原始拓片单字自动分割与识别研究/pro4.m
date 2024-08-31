
digitDatasetPath = 'D:\桌面\数学建模\2024暑期培训\2024暑期培训第5轮模拟题B题\2024暑期培训第5轮模拟题B题附件\甲骨文智能识别中原始拓片单字自动分割与识别研究\4_Recognize\训练集';

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
numImages = numel(imds.Labels);
idx = randperm(numImages,16);
I = imtile(imds,Frames=idx);
figure
imshow(I)
classNames = categories(imds.Labels)
numClasses = numel(classNames)
labelCount = countEachLabel(imds)
[imdsTrain,imdsValidation,imdsTest] = splitEachLabel(imds,0.7,0.15,"randomized");
net = imagePretrainedNetwork(NumClasses=numClasses)
inputSize = net.Layers(1).InputSize
net = setLearnRateFactor(net,"conv10/Weights",10);
net = setLearnRateFactor(net,"conv10/Bias",10);
pixelRange = [-30 30];

imageAugmenter = imageDataAugmenter( ...
    RandXReflection=true, ...
    RandXTranslation=pixelRange, ...
    RandYTranslation=pixelRange);

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    DataAugmentation=imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
options = trainingOptions("adam", ...
    InitialLearnRate=0.0001, ...
    ValidationData=augimdsValidation, ...
    ValidationFrequency=5, ...
    Plots="training-progress", ...
    Metrics="accuracy", ...
    Verbose=false);
net = trainnet(augimdsTrain,net,"crossentropy",options);
YTest = minibatchpredict(net,augimdsTest);
YTest = scores2label(YTest,classNames);
TTest = imdsTest.Labels;
acc = mean(TTest==YTest)
%acc = 0.8567
testDatasetPath = 'D:\桌面\数学建模\2024暑期培训\2024暑期培训第5轮模拟题B题\pro4_test';

testimds = imageDatastore(testDatasetPath);

Test_augimds = augmentedImageDatastore(inputSize(1:2),testimds);

 result_lable = minibatchpredict(net, Test_augimds);    
 result_lable = scores2label(result_lable,classNames)
  figure
    k= 14;
for i = 1:k
    filename = cell2mat(Test_matrixData(i));
    I_test = imread(filename);
    subplot(2,7,i)
    imshow(I_test)
    title(string(result_lable(i)))
    set(gca,'FontSize',20);
end
