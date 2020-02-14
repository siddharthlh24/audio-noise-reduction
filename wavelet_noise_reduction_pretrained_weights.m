clear all

[k,Fs] = audioread('man_voice.wav');
k = k.*0.5/rms(k);
k = awgn(k,10,'measured');
k = k.*0.5/rms(k);
y=k;
T = 1/Fs;                   
L = length(y);    

sound(k,Fs)
pause(L/Fs);
pause(1);

% yf = fft(y);
% xf = linspace(0.0, 1.0/(2.0*T), L/2);
% %plot(xf,(2/L)*abs(yf(1:L/2)));
% noise_low = (int32(L*(0.9*Fs/2)/Fs));
% noise_high = (int32(L*(1*Fs/2)/Fs));
% z = real(ifft(yf(noise_low:noise_high));
% noise = rms(z)

winLen = double(int32(Fs/30));
ste = sum(buffer(k.^2, winLen));

minste = min(abs(ste(1:length(ste)-1)));
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

kno = rms((k(noisewin)));

noise=kno;

trained_vals = [5.7971    0.0876   0]
threshval = [polyval(trained_vals,noise)]

[c,l] = wavedec(k,3,'db20');
b = wthresh(c,'s',threshval);
x = waverec(b,l,'db20');
x = x.*0.5/rms(x);

sound(x,Fs)
