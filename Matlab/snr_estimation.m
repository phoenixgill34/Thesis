% Estimating SNR for RTL-SDR SU-1
load maxsnr_data.mat;
% load variance_SU_1;
variance = 24.34e-9;
data = data/2e6;
snr = (data-variance*2)/(2*variance);
snr_db = 10*log10(abs(snr));
% figure;
% subplot(2,1,1);
% plot(snr,'LineWidth',1.6);
% xlabel('Samples');
% ylabel('SNR in Linear Scale');
% subplot(2,1,2);
% plot(snr_db,'LineWidth',1.6);
% xlabel('Samples');
% ylabel('SNR in dB');