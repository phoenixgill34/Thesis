% Demonstration of Eb/N0 Vs SER for M-QAM modulation scheme
clc;
clear;
%---------Input Fields------------------------
%% 64 QAM Modulation...
bitsperframe=1e3; %Number of input symbols
EbN0dB = 0:2:20; %Define EbN0dB range for simulation
M=64; %for QPSk modulation.
hMod = comm.RectangularQAMModulator('ModulationOrder',M);
const = step(hMod,(0:M-1)');
%---------------------------------------------
refArray =1/sqrt(42)*const';
k=log2(M);
totPower=1; %Total power of LOS path & scattered paths
Kf = [22.63,14.2542,10.0237,4.7547,2.3155,-0.932];
for count=1:length(Kf)
    K = 10^(Kf(count)/10);
    sn=sqrt(K/(K+1)*totPower); %Non-Centrality Parameter
    sigma=totPower/sqrt(2*(K+1));
    EsN0dB = EbN0dB + 10*log10(k);
    biterrsim = zeros(size(EsN0dB));
    %---Generating a uniformly distributed random numbers in the set [0,1,2,..,M-1]
    data=ceil(M.*rand(bitsperframe,1))-1;
    s=refArray(data+1); %QPSK Constellation mapping with Gray coding
    %--- Reference Constellation for demodulation and Error rate computation--
    refI = real(refArray);
    refQ = imag(refArray);
    %---Place holder for Symbol Error values for each Es/N0 for particular M value--
    index=1;
    h=((sigma*randn(1,bitsperframe)+sn)+1i*(randn(1,bitsperframe)*sigma+0));
    for x=EsN0dB
        
        numerr = 0;
        numBits = 0;
        while numerr < 100 && numBits < 1e7
            %-------------------------------------------
            %Channel Noise for various Es/N0
            %-------------------------------------------
            %Adding noise with variance according to the required Es/N0
            noiseVariance = 1/(10.^(x/10));%Standard deviation for AWGN Noise
            noiseSigma = sqrt(noiseVariance/2);
            %Creating a complex noise for adding with M-QAM modulated signal
            %Noise is complex since M-QAM is in complex representation
            noise = noiseSigma*(randn(size(s))+1i*randn(size(s)));
            received = s.*h + noise;
            %-------------I-Q Branching---------------
            received = received./h;
            r_i = real(received);
            r_q = imag(received);
            %---Decision Maker-Compute (r_i-s_i)^2+(r_q-s_q)^2 and choose the smallest
            r_i_repmat = repmat(r_i,M,1);
            r_q_repmat = repmat(r_q,M,1);
            distance = zeros(M,bitsperframe); %place holder for distance metric
            minDistIndex=zeros(bitsperframe,1);
                for j=1:bitsperframe
                %---Distance computation - (r_i-s_i)^2+(r_q-s_q)^2 --------------
                distance(:,j) = (r_i_repmat(:,j)-refI').^2+(r_q_repmat(:,j)-refQ').^2;
                %---capture the index in the array where the minimum distance occurs
                [dummy,minDistIndex(j)]=min(distance(:,j));
                end
            y = minDistIndex - 1;
            %--------------Symbol Error Rate Calculation-------------------------------
            dataCap = y;
            numerr = sum(dataCap~=data)+numerr;
            numBits = numBits+bitsperframe;
            disp(numerr);
        end
    symErrSimulatedqam64(count,index) = numerr/numBits;
    biterrsim(count,index) = symErrSimulatedqam64(count,index)/k;
    index=index+1;
    disp(x);
    end
end
%%
figure(1);
semilogy(EbN0dB,symErrSimulatedqam64(1,:),'-d','LineWidth',2);
hold on;
semilogy(EbN0dB,symErrSimulatedqam64(2,:),'--','LineWidth',2);
semilogy(EbN0dB,symErrSimulatedqam64(3,:),'-p','LineWidth',2);
semilogy(EbN0dB,symErrSimulatedqam64(4,:),'-o','LineWidth',2);
semilogy(EbN0dB,symErrSimulatedqam64(5,:),'-.s','LineWidth',2);
semilogy(EbN0dB,symErrSimulatedqam64(6,:),'-','LineWidth',2);
xlabel('E_b/N_0(dB)');
ylabel('BER');
title(['BER For 64QAM Under Rician Fading Environment']);
grid on;
set(gca,'fontsize',30,'box','on','LineWidth',2,'GridLineStyle','--','GridAlpha',0.7);
lgd = legend('K = 22.6 dB','K = 14.2 dB','K = 10.1 dB','K = 4.7 dB','K = 2.3 dB','K = -0.9 dB');
lgd.FontSize=20;
axis([0 20 1e-6 1]);
