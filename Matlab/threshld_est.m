% Threshold Estimation with Noise Floor
%% Read the binary data in proper formats..
filenamer = input('Enter the file name to read\n');
data=  [];
fidr = fopen(filenamer,'r');
i=1;
while ~feof(fidr)
    [k,count]= fread(fidr,1,'float');
    if count==1
        data(i) = k;
    end
    i=i+1;
end
figure;
plot(data,'->b','LineWidth',2);
save('maxsnr_data.mat','data');
fclose(fidr);
