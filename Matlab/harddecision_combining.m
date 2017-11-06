% Hard-Decision Combining Results For Sensor Nodes
clc;
close all;
clear all;
%% Parameter Initialization
N = 32;
k=4;%sensor nodes..
variance = 24.32e-9;
pfa = 0.05;
threshold = (qfuncinv(pfa)+sqrt(N)).*sqrt(N)*2*variance;
snrthreotical = -18:0.5:20;
snrlinear = 10.^(snrthreotical/10);
%% SNR values from USRP and RTL-SDR
snrpracticalavg = [-18.23,-14.22,-13.1,-12.22,-10.35,-8.25,-5.3,-2.1,0.13,...
    1.34,2.58,3.76,8.98,11.33,12.35,13.45,15.77];
snrlinearprac = 10.^(snrpracticalavg/10);
%% Computing Detection Probability and ROC Characteristics
pdprac = qfunc((threshold-2*N*variance.*(1+snrlinearprac))./...
    (sqrt(N.*(1+2*snrlinearprac))*(2*variance)));
pdpracor = 1-(1-pdprac).^4;
pdpracand = pdprac.^4;
tmp1 =  (1-pdprac).^2;
tmp2 = (1-pdprac);
pdpracmjr = (6*pdprac.^2).*tmp1+(4*pdprac.^3).*tmp2+pdprac.^4;

pfapracor = 1-(1-pfa).^4;
pfapracand = pfa.^4;
tmp1 =  (1-pfa).^2;
tmp2 = (1-pfa);
pfapracmjr = (6*pfa.^2).*tmp1+(4*pfa.^3).*tmp2+pfa.^4;

%% ROC Characteristics...
figure(1)
hold on;
grid on;
plot(pfapracor,pdpracor(:,5),'-->','LineWidth',2,'MarkerFaceColor','auto');
plot(pfapracor,pdpracor(:,7),'-->','LineWidth',2,'MarkerFaceColor','auto');
plot(pfapracand,pdpracand(:,5),'-d','LineWidth',2,'MarkerFaceColor','auto');
plot(pfapracand,pdpracand(:,7),'-d','LineWidth',2,'MarkerFaceColor','auto');
plot(pfapracmjr,pdpracmjr(:,5),'--','LineWidth',2,'MarkerFaceColor','auto');
plot(pfapracmjr,pdpracmjr(:,7),'--','LineWidth',2,'MarkerFaceColor','auto');
xlabel('Average Probability Of False Alarm');
ylabel('Average Probability of Detection');
title('ROC Characterisitcs of Hard Decision Combining');
hold off;
set(gca,'fontsize',30,'box','on','LineWidth',2,'GridLineStyle','--','GridAlpha',0.7);
lgd = legend('OR SNR=-10.35dB','OR SNR=-5.3dB','AND SNR=-10.35dB',...
    'AND SNR=-5.3dB','Majority SNR=-10.35dB','Majority SNR=-5.3dB');
lgd.FontSize=20;

%% Probability of detection
figure(2)
hold on;
grid on;
plot(snrpracticalavg,pdpracor,'->','LineWidth',2);
plot(snrpracticalavg,pdpracand,'-<','LineWidth',2);
plot(snrpracticalavg,pdpracmjr,'-d','LineWidth',2);
xlabel('SNR_{avg} in (dB)');
ylabel('Average Probability of Detection');
title('P_{davg} vs SNR_{avg} for Hard Decision Combining');
hold off;
set(gca,'fontsize',30,'box','on','LineWidth',2,'GridLineStyle','--','GridAlpha',0.7);
lgd = legend('OR Decision','AND Decision','Majority Rule Decision');
lgd.FontSize=20;
axis([-18.23 15.77 0 1])
