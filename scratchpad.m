% a = ones(1,10);
% a(5:10) = a(5:10)*0.4;
% b = wthresh(a,'h',0.45)

clear all

noise = [];
threshes = [];
jval =[];

for j=5:1:15
[k,Fs] = audioread('fem_voice.wav');
k = k.*0.5/rms(k);
y0=k;
k = awgn(k,j,'measured');
k = k.*0.5/rms(k);
y=k;
T = 1/Fs;                   
L = length(y);    
yf = fft(y);
xf = linspace(0.0, 1.0/(2.0*T), L/2);
plot(xf,(2/L)*abs(yf(1:L/2)));
noise_low = (int32(L*(0.9*Fs/2)/Fs));
noise_high = (int32(L*(1*Fs/2)/Fs));
z = real(ifft(yf(noise_low:noise_high)));
noise = [ noise , rms(z) ];
lx = [];
ly = [];
    for i=0:0.01:0.4
    lx = [lx,i];
    [c,l] = wavedec(k,4,'db20');
    b = wthresh(c,'s',i);
    x = waverec(b,l,'db20');
    %sound(x,Fs)
    x = x.*0.5/rms(x);
    err = immse(x,y0);
    ly = [ly,err];
    %plot(lx,ly)
    end
%plot(lx,ly)
%pause(1);
jval = [jval,j];
threshes = [ threshes , lx(ly == min(ly)) ];
end

%plot(lx,ly)
plot(noise,threshes)
hold on
p = polyfit(noise,threshes,1);
nk = polyval(p,noise)
plot(noise,nk)


    