% Demonstration of Eb/N0 Vs SER for M-QAM modulation scheme
clc;
load Kf;
load t;
%---------Input Fields------------------------
%% QPSk
bitsperframe=1e3; %Number of input symbols
EbN0dB = [linspace(0,20,50) fliplr(linspace(0,20,50))]; %Define EbN0dB range for simulation
M=4; %for QPSk modulation.
hMod = comm.RectangularQAMModulator('ModulationOrder',M);
const = step(hMod,(0:3)');
%---------------------------------------------
refArray =1/sqrt(2)*const';
k=log2(M);
totPower=15; %Total power of LOS path & scattered paths

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
u=1;
% Kf = 4.9;
K = 10.^(Kf/10);
for x=EsN0dB
    sn=sqrt(K(u)/(K(u)+1)*totPower); %Non-Centrality Parameter
    sigma=totPower/sqrt(2*(K(u)+1));
    h=((sigma*randn(1,bitsperframe)+sn)+1i*(randn(1,bitsperframe)*sigma+0));
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
symErrSimulatedqpsk(1,index) = numerr/numBits;
biterrsim(1,index) = symErrSimulatedqpsk(1,index)/k;
index=index+1;
% u=u+1;
end

%% 16 QAM
bitsperframe=1e3; %Number of input symbols
EbN0dB = [linspace(0,10,50) fliplr(linspace(0,10,50))]; %Define EbN0dB range for simulation
M=16; %for QPSk modulation.
hMod = comm.RectangularQAMModulator('ModulationOrder',M);
const = step(hMod,(0:M-1)');
%---------------------------------------------
refArray =1/sqrt(10)*const';
k=log2(M);
totPower=10; %Total power of LOS path & scattered paths


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
u=1;
K = 10.^(Kf/10);
for x=EsN0dB
    numerr = 0;
    numBits = 0;
    while numerr < 100 && numBits < 1e7
        sn=sqrt(K(u)/(K(u)+1)*totPower); %Non-Centrality Parameter
        sigma=totPower/sqrt(2*(K(u)+1));
        h=((sigma*randn(1,bitsperframe)+sn)+1i*(randn(1,bitsperframe)*sigma+0));
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
symErrSimulatedqam(1,index) = numerr/numBits;
biterrsim(1,index) = symErrSimulatedqam(1,index)/k;
index=index+1;
u=u+1;
end

%% 64 QAM Modulation...
bitsperframe=1e3; %Number of input symbols
EbN0dB = [linspace(0,10,50) fliplr(linspace(0,10,50))]; %Define EbN0dB range for simulation
M=64; %for QPSk modulation.
hMod = comm.RectangularQAMModulator('ModulationOrder',M);
const = step(hMod,(0:M-1)');
%---------------------------------------------
refArray =1/sqrt(42)*const';
k=log2(M);
totPower=10; %Total power of LOS path & scattered paths
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
u=1;
K = 10.^(Kf/10);
for x=EsN0dB
     sn=sqrt(K(u)/(K(u)+1)*totPower); %Non-Centrality Parameter
     sigma=totPower/sqrt(2*(K(u)+1));
     h=((sigma*randn(1,bitsperframe)+sn)+1i*(randn(1,bitsperframe)*sigma+0));
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
symErrSimulatedqam64(1,index) = numerr/numBits;
biterrsim(1,index) = symErrSimulatedqam64(1,index)/k;
index=index+1;
u=u+1;
end

%%
figure(1);
semilogy(t*1e3,symErrSimulatedqpsk(1,:),'-d','LineWidth',2);
hold on;
semilogy(t*1e3,symErrSimulatedqam(1,:),'-d','LineWidth',2);
semilogy(t*1e3,symErrSimulatedqam64(1,:),'-d','LineWidth',2);
xlabel('Time (ms)');
ylabel('Bit Error Rate (Pb)');
title(['BER For OFDM Under Rician Fading Environment Inside Tunnel']);
grid on;
set(gca,'fontsize',30,'box','on','LineWidth',2,'GridLineStyle','--','GridAlpha',0.7);
axis([0 max(t)*1e3 10e-7 0])
% lgd = legend('QPSK','16QAM','64QAM');
% lgd.FontSize=20;