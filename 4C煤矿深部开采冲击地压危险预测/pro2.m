
YPred_EMR = classify(net_ABC,Lstm_Forecast_Value');

pro2_C_idx = (YPred_EMR == "C"); % 找到C类数据的索引  
pro2_normal_idx = (YPred_EMR == "A"); % 找到正常数据的索引  
pro2_predict_idx= (YPred_EMR =="B");
figure
plot(YPred_EMR,'.-')
% plot(EMR_Test.time2,YPred_EMR,'.-')
% plot(EMR_Test.time2,EMR_Test.EMR2,'.r-')
hold on
% plot(EMR_Test.time2(pro2_predict_idx), EMR_Test.EMR2(pro2_predict_idx), '*','LineWidth', 1); % 紫色线
% plot(YTest{1})
hold off
xlabel("时间")
ylabel("信号类型")
% title("Predicted Activities")
legend("Predicted" )
set(gca,'fontsize',20)
% 
% 
% figure
% plot(EMR_Test.EMR2)
% 
% xlabel("时间")
% ylabel('电磁辐射信号 (EMR)'); 
%%

YPred_AE = classify(net_AE_ABC,AE_Test_X');

pro2_C_idx = (YPred_AE == "C"); % 找到C类数据的索引  
pro2_normal_idx = (YPred_AE == "A"); % 找到正常数据的索引  
pro2_predict_idx= (YPred_AE =="B");
figure
plot(YPred_AE,'.-')
% plot(EMR_Test.time2,YPred_EMR,'.-')
% plot(EMR_Test.time2,EMR_Test.EMR2,'.r-')
hold on
% plot(EMR_Test.time2(pro2_predict_idx), EMR_Test.EMR2(pro2_predict_idx), '*','LineWidth', 1); % 紫色线
% plot(YTest{1})
hold off
xlabel("时间")
ylabel("信号类型")
% title("Predicted Activities")
legend("Predicted" )
set(gca,'fontsize',20)
