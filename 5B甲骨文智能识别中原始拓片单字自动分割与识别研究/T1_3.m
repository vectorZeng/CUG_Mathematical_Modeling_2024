clc,clear,close all
I=imread('h02060.jpg');
%I=I(51:358,151:458);
Bridge_gray=im2gray(I);
% Bridge_Ec = edge(Bridge_gray,'canny');     % Roberts edges
% Bridge_Es = edge(Bridge_gray,'sobel');      % Prewitt edges
% Bridge_Ep = edge(Bridge_gray,'prewitt');    % Sobel edges
% Bridge_El = edge(Bridge_gray,'log');        % LOG edges
Bridge_Er = edge(pout_imadjust,'Roberts');    % Roberts edges
figure
subplot(1,2,1); imshow(Bridge_gray); title('原始图像')
set(gca,'FontSize',20)
% subplot(2,3,2); imshow(Bridge_Ec); title('Canny边缘')
% subplot(2,3,3); imshow(Bridge_Es); title('Sobel边缘')   
% subplot(2,3,4); imshow(Bridge_Ep); title('Prewitt边缘')   
% subplot(2,3,5); imshow(Bridge_El); title('LOG边缘')  
subplot(1,2,2); imshow(Bridge_Er); title('Roberts边缘') 
set(gca,'FontSize',20)