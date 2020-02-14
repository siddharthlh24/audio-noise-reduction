clear all

[k,Fs] = audioread('fem_peace.wav');
%k = awgn(k,15,'measured');
% wname = 'db20';
% n=1;
[c,l] = wavedec(k,3,'db2');
approx = appcoef(c,l,'db2');
[cd1,cd2,cd3] = detcoef(c,l,[1 2 3]);

subplot(5,1,1)
plot(approx)
title('Approximation Coefficients')
subplot(5,1,2)
plot(cd3)
title('Level 3 Detail Coefficients')
subplot(5,1,3)
plot(cd2)
title('Level 2 Detail Coefficients')
subplot(5,1,4)
plot(cd1)
title('Level 1 Detail Coefficients')
subplot(5,1,5)
plot(k)
title('le sig')