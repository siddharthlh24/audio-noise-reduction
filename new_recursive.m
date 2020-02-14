
clear all 
[k,Fs] = audioread('prewhitened_male.wav');
k = k.*0.5/rms(k);
y0=k;
k = awgn(k,10,'measured');
k = k.*0.5/rms(k);

x=k;
% y = sum(abs(diff(x>0)))/length(x)   %zero crossing rate

winLen = double(int32(Fs*0.025));
ste = sum(buffer(k.^2, winLen));
diffste = diff(ste);
