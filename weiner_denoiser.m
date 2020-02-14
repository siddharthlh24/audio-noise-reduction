clear all

[k,Fs] = audioread('fem_peace.wav');
k = awgn(k,15,'measured');
truesignal=k;
N = length(truesignal);

level = 3;
wt='db20';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wt)        
[C,L] = wavedec(truesignal,level,Lo_D,Hi_D);
cA3 = appcoef(C,L,wt,level);

[cD1,cD2,cD3] = detcoef(C,L,[1,2,3]); 

A3 = wrcoef('a',C,L,Lo_R,Hi_R,level);

D1 = wrcoef('d',C,L,Lo_R,Hi_R,1);
D2 = wrcoef('d',C,L,Lo_R,Hi_R,2);
D3 = wrcoef('d',C,L,Lo_R,Hi_R,3);


tptr = 'sqtwolog';
sorh = 's';

thr_D1 = thselect(D1,tptr)
thr_D2 = thselect(D2,tptr)
thr_D3 = thselect(D3,tptr)


tD1 = wthresh(D1,sorh,thr_D1);
tD2 = wthresh(D2,sorh,thr_D2);
tD3 = wthresh(D3,sorh,thr_D3);


denoised = A3 + tD1 + tD2 + tD3;

sound(denoised,Fs);



