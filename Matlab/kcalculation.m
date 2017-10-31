clear all;
close all;
clc;
%% Creating a doppler profile for high speed raiway scenario..
Ds = 30;%Initial Distance between tx and rx times 2..
Dmin = 2;% Distance between raiway tracks and leaky feeder cables...
Kf = [];
fc = 3e9;%center frequency..
c = 3e8;
v = 138.9;%300;
t = linspace(0,(2*Ds)/v(1),100);
fd = (v*fc)/3e8;%maximum doppler frequency...
costheta = zeros(size(t));%angle between BS and MS
d1 = [];
for i=1:length(t)
    d1(i) = sqrt(2^2+(Ds/2-v(1)*t(i))^2);%distance between tx and rx..
    if t(i) >=0 && t(i)<= (Ds/v)
        costheta(i) = ((Ds/2)-v*t(i))./sqrt(Dmin^2+(Ds/2-v*t(i))^2);
    
    elseif t(i) > (Ds/v) && t(i)<=(2*Ds)/v
        costheta(i) = (-1.5*Ds+v*t(i))./sqrt(Dmin^2+(-1.5*Ds+v*t(i))^2);
    end  
end
fs  = fd*costheta;
thetadeg = acosd(costheta);
%% 
fc_wds = fc-fs;
lambda = c./fc_wds;
Cin = 5-((0.1*1.8e10)./fc_wds)*1j;
C = Cin;
gammanum = C.*sind(thetadeg)-sqrt(Cin-(cosd(thetadeg)).^2);
gammaden = C.*sind(thetadeg)+sqrt(Cin-(cosd(thetadeg)).^2);
gamma = gammanum./gammaden;
%%
ht = 6.1;%height of feeder cable
hr = 4.2;%height of the train
var1 = sqrt(d1.^2+(ht+hr)^2);
var2 = sqrt(d1.^2+(ht-hr)^2);
phase = ((((2*pi)./lambda).*(var1-var2))*180)/pi;
gammad = atan2d(imag(gamma),real(gamma));
phasegamma = abs(cosd(gammad-phase));
K = abs(gamma).^2+2*abs(gamma).*phasegamma;
Kf(1,:) = 10*log10(1./K);

%% Part II
fc = 3e9;%center frequency..
c = 3e8;
v = 138.9;
t = linspace(0,(2*Ds)/v(1),100);
fd = (v(1)*fc)/3e8;%maximum doppler frequency...
costheta = zeros(size(t));%angle between BS and MS
d2 = [];
for i=1:length(t)
    d2(i) = sqrt(2^2+(Ds/2-v(1)*t(i))^2);%distance between tx and rx..
    if t(i) >=0 && t(i)<= (Ds/v(1))
        costheta(i) = ((Ds/2)-v(1)*t(i))./sqrt(Dmin^2+(Ds/2-v(1)*t(i))^2);
    elseif t(i) > (Ds/v) && t(i)<=(2*Ds)/v
        costheta(i) = (-1.5*Ds+v*t(i))./sqrt(Dmin^2+(-1.5*Ds+v*t(i))^2);
    end  
end
fs  = fd*costheta;
thetadeg = acosd(costheta);
%% Verical Polarization...
fc_wds = fc-fs;
lambda = c./fc_wds;
Cin = 5-((0.1*1.8e10)./fc_wds)*1j;
C = Cin;
gammanum = C.*sind(thetadeg)-sqrt(Cin-(cosd(thetadeg)).^2);
gammaden = C.*sind(thetadeg)+sqrt(Cin-(cosd(thetadeg)).^2);
gamma = gammanum./gammaden;
%%
ht = 6.1;%height of feeder cable
hr = 4.2;%height of the train
var1 = sqrt(d2.^2+(ht+hr)^2);
var2 = sqrt(d2.^2+(ht-hr)^2);
phase = ((((2*pi)./lambda).*(var1-var2))*180)/pi;
gammad = atan2d(imag(gamma),real(gamma));
phasegamma = abs(cosd(gammad-phase));
K = abs(gamma).^2+2*abs(gamma).*phasegamma;
Kf(2,:) = 10*log10(1./K);
%% Part III
fc = 3e9;%center frequency..
c = 3e8;
v = 138.9;
t = linspace(0,(2*Ds)/v(1),100);
fd = (v(1)*fc)/3e8;%maximum doppler frequency...
costheta = zeros(size(t));%angle between BS and MS
d3 = [];
for i=1:length(t)
    d3(i) = sqrt(2^2+(Ds/2-v(1)*t(i))^2);%distance between tx and rx..
    if t(i) >=0 && t(i)<= (Ds/v(1))
        costheta(i) = ((Ds/2)-v(1)*t(i))./sqrt(Dmin^2+(Ds/2-v(1)*t(i))^2);
    elseif t(i) > (Ds/v) && t(i)<=(2*Ds)/v
        costheta(i) = (-1.5*Ds+v*t(i))./sqrt(Dmin^2+(-1.5*Ds+v*t(i))^2);
    end  
end
fs  = fd*costheta;
thetadeg = acosd(costheta);
%% Verical Polarization...
fc_wds = fc-fs;
lambda = c./fc_wds;
Cin = 5-((0.1*1.8e10)./fc_wds)*1j;
C = Cin;
gammanum = C.*sind(thetadeg)-sqrt(Cin-(cosd(thetadeg)).^2);
gammaden = C.*sind(thetadeg)+sqrt(Cin-(cosd(thetadeg)).^2);
gamma = gammanum./gammaden;
%%
ht = 6.1;%height of feeder cable
hr = 4.2;%height of the train
var1 = sqrt(d3.^2+(ht+hr)^2);
var2 = sqrt(d3.^2+(ht-hr)^2);
phase = ((((2*pi)./lambda).*(var1-var2))*180)/pi;
gammad = atan2d(imag(gamma),real(gamma));
phasegamma = abs(cosd(gammad-phase));
K = abs(gamma).^2+2*abs(gamma).*phasegamma;
Kf(3,:) = 10*log10(1./K);
%% Figure for K-factor with veloctiy
figure(1);
plot(d1,Kf(1,:),'--','LineWidth',2);
hold on;
plot(d2,Kf(2,:),'--o','LineWidth',2);
plot(d3,Kf(3,:),'-.','LineWidth',2);
xlabel('Distance Between Tx and Rx (in meters)');
ylabel('K-Factor (dB)');
title('K-Factor versus Center Frequency');
grid on;
hold off;
set(gca,'fontsize',30,'box','on','LineWidth',2,'GridLineStyle','--','GridAlpha',0.7);
lgd = legend('f_c = 2 GHz','f_c = 3 GHz',...
    'f_c = 5 GHz');
lgd.FontSize=20;
axis([2 45.0444 -2 24])
