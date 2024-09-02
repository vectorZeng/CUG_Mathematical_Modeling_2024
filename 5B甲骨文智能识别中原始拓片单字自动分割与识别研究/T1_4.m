% clc,clear,close all
I = Bridge_gray;
% I=pout_imadjust;
%I=I(51:358,151:458);
I = im2gray(I);
[posX,posY]=harris(I);
figure;imshow(I);

hold on; plot(posX, posY, 'g+');



function [posX,posY]=harris(I)
%Harris角点检测
%I:输入图像
%posX:角点X坐标
%posY:角点Y坐标
I=double(I);
[m,n]=size(I);
hx=[-1,0,1;-1,0,1;-1,0,1];
Ix=imfilter(I,hx,'replicate','same');%X方向差分图像
Iy=imfilter(I,hx','replicate','same');%Y方向差分图像
Ix2=Ix.^2;
Iy2=Iy.^2;
Ixy=Ix.*Iy;
h=fspecial('gaussian',3,2);
Ix2=imfilter(Ix2,h,'replicate','same');%高斯滤波
Iy2=imfilter(Iy2,h,'replicate','same');
Ixy=imfilter(Ixy,h,'replicate','same');
R=zeros(m,n);
k=0.06;          %建议值(0.04--0.06)
for i=1:m
    for j=1:n
       R(i,j)=(Ix2(i,j)*Iy2(i,j)-Ixy(i,j)*Ixy(i,j))-k*((Ix2(i,j)+Iy2(i,j))^2);%角点响应值
    end
end
T=0.1*max(R(:));% 阈值，可控制返回的角点个数
result=zeros(m,n);
%非极大值抑制（3*3窗口中大于阈值T的局部极大值点被认为是角点）
for i=2:m-1
    for j=2:n-1
        tmp=R(i-1:i+1,j-1:j+1);
        tmp(2,2)=0;
        if(R(i,j)>T&&R(i,j)>max(tmp(:)))
            result(i,j)=1;
        end
    end
end
[posY,posX]=find(result);
end
