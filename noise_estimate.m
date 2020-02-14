clear all
[k,Fs] = audioread('fem_peace.wav');
k = awgn(k,5,'measured');
L = length(k);
rms_ref = 1;
k = k.*1/rms(k);
y = k;
T = 1/Fs;                   
L = length(y);    
yf = fft(y);
xf = linspace(0.0, 1.0/(2.0*T), L/2);
plot(xf,(2/L)*abs(yf(1:L/2)));

noise_low = (int32(L*(0.8*Fs/2)/Fs));
noise_high = (int32(L*(1*Fs/2)/Fs));

% z = ifft(yf(noise_low:noise_high));
% rms(z)
% thr = 1;
% ytsoft = wthresh(y,'s',thr);
% sound(ytsoft,Fs)
