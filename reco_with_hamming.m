clear all

[k,Fs] = audioread('man_voice.wav');
k = awgn(k,10,'measured');
L = length(k);
y = k;
y = k*0;

M = 301;
% p = (M-1)/2
% q = p+1
% 
% mean1 = mean(k(1:M))
% y(p) = mean1;
% 
% for i = q+1:L-q
%     y(i) = y(i-1) + k(i+p) - k(i-q);
% end

y = wdenoise(k);

sound(y*rms(k)/rms(y),Fs)

%sound(k,Fs)

