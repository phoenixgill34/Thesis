% Probability of deteciton with SNR...
snr = -15:0.1:10;
noise = 77.322e-9;
threshold = 4500000.7e-9;
snrlinear = 10.^(snr/10);
N=32;
pd = qfunc((threshold-N*2*noise*(1+snrlinear))./...
    (sqrt(N*(1+2*snrlinear))*(2*noise)));
pf = qfunc((threshold-N*(2*noise))/(sqrt(N)*(2*noise)));
plot(snr,pd,'->r','LineWidth',2);
hold on;
plot(snr,pf,'-<b','LineWidth',2);
