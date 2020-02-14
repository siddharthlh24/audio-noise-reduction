clear all

[k,Fs] = audioread('fem_peace.wav');
k = k.*0.5/rms(k);
k = awgn(k,15,'measured');
k = k.*0.5/rms(k);
winLen = 30;
ste = sum(buffer(k.^2, winLen));

minste = min(abs(ste));
valx = find(abs(ste)==minste);
noisewin = ((valx-1)*winLen+1):(valx*winLen);

subplot(4,1,1)
plot(diff(ste))
subplot(4,1,2)
plot(diff(ste))
subplot(4,1,3)
plot(k)
subplot(4,1,4)
blank = k.*0;
blank(noisewin) = k(noisewin);
plot(blank)


kno = rms((k(noisewin)))


% minste = min(ste)
% 
y=k;
% pos = y((minste==min(ste));
% vadE = rms(y==pos:y==pos+30);
% rmsvad = rms(vadE)

T = 1/Fs;                   
L = length(y);    

%sound(k,Fs)
% pause(L/Fs);
% pause(1);

yf = fft(y);
xf = linspace(0.0, 1.0/(2.0*T), L/2);
%plot(xf,(2/L)*abs(yf(1:L/2)));
noise_low = (int32(L*(0.9*Fs/2)/Fs));
noise_high = (int32(L*(1*Fs/2)/Fs));
z = abs(ifft(yf(noise_low:noise_high)));
%noise = rms(z)

