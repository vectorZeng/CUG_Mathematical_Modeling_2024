clc,clear,close all
I=imread('h02060.jpg');
%I=I(51:358,151:458);
Bridge_gray=im2gray(I);
Bridge_gray_gn=imnise(Bridge_gray,'gaussian',0,0.01);  % Add Gaussian noise

net = denoisingNetwork("DnCNN");
g = denoiseImage(Bridge_gray_gn,net);
% g = denoiseImage(Bridge_gray_gn,net);
pout_imadjust = imadjust(g);
figure

subplot(1,4,1); imshow(Bridge_gray); 
title('原始图像 ')

set(gca,'FontSize',20)
subplot(1,4,2); imshow(Bridge_gray_gn); title('高斯噪声图像') 
set(gca,'FontSize',20)
subplot(1,4,3); imshow(g); title('DnCNN去噪图像')
set(gca,'FontSize',20)
subplot(1,4,4); imshow(pout_imadjust); title('增强对比度图像')                     
% subplot(1,4,4); imshow(Bridge_gray_gn_g); title('高斯滤波去噪')   
set(gca,'FontSize',20)

 %%
pre_test_result = batchimadjust("E:\filereceive\math_model\No.5\code\figs\1_Pre_test","E:\filereceive\math_model\No.5\code\figs\1_Pre_Test_result")
%%
