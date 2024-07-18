%function [fitresult, gof] = createFit(Carbon, disaster_count, Temp)
%CREATEFIT(CARBON,DISASTER_COUNT,TEMP)
%  创建一个拟合。
%
%  要进行 'T' 拟合的数据:
%      X 输入: Carbon
%      Y 输入: disaster_count
%      Z 输出: Temp
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 15-Jul-2024 10:17:13 自动生成


%% 拟合: 'T'。
[xData, yData, zData] = prepareSurfaceData( Carbon, disaster_count, Temp );
%[xData, yData, zData] = prepareSurfaceData(  disaster_count, Carbon, Temp );
%[xData, yData, zData] = prepareSurfaceData( Temp, Carbon, disaster_count );
% 设置 fittype 和选项。
ft = 'cubicinterp';
opts = fitoptions( 'Method', 'CubicSplineInterpolant' );
opts.ExtrapolationMethod = 'none';
opts.Normalize = 'on';

% 对数据进行模型拟合。
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% 绘制数据拟合图。
figure( 'Name', 'T' );
h = plot( fitresult, [xData, yData], zData );
legend( h, '插值拟合', 'Temp vs. Carbon, Disaster_count', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
 xlabel( 'Carbon', 'Interpreter', 'none' );
 ylabel( 'disaster_count', 'Interpreter', 'none' );
 zlabel( 'Temp', 'Interpreter', 'none' );
% xlabel( 'Temp', 'Interpreter', 'none' );
%  ylabel( 'Carbon' ,'Interpreter', 'none' );
%  zlabel( 'disaster_count', 'Interpreter', 'none' );

grid on
view( 19.6, 20.5 );
%legend('data','多重回归拟合曲线')
set(gca, 'FontSize', 20);


