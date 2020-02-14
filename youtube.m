clear all
[k,Fs] = audioread('man_voice.wav');
k = k * 0.5 / rms(k);
k = awgn(k,12,'measured');
% [c,l] = wavedec(k,3,'db4');
% b = wthresh(c,'s',0.25);
% y = waverec(b,l,'db4');
% y = y * 0.5/rms(y);
% sound(y,Fs);

slope = spectralSlope(k,Fs)