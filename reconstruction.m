clear all

[k,Fs] = audioread('prewhitened_male.wav');
k = awgn(k,15,'measured');
pk = rms(k);

y = sgolayfilt(k,2,301);
py = rms(y);

y = y.*pk/py;
%sound(y,Fs)


T = 1/Fs;                   
L = length(y);    
yf = fft(y);
xf = linspace(0.0, 1.0/(2.0*T), L/2);
plot(xf,(2/L)*abs(yf(1:L/2))) %%%%%%%%%%%

%gender analysis

manlow = (int16(L*85/Fs));
manhigh = (int16(L*180/Fs));

femlow = (int16(L*165/Fs));
femhigh = (int16(L*255/Fs));

yf = yf.* (0.2/rms(yf))

pm = rms(yf(manlow:manhigh))
pmf = rms(yf(femlow:femhigh))
 sum=0;

for i = femlow:femhigh
    a = double(abs(yf(int16(2*i))))/abs(yf(int16(i)));
    sum = double(sum) + double(a);
end
sum = double(sum/double(femhigh-femlow))

summ=0;
for i = manlow:manhigh
    a = double(abs(yf(int16(2*i))))/abs(yf(int16(i)));
    summ = double(summ) + double(a);
end
summ = double(summ/double(manhigh-manlow))

if(sum<1)
    yf(xf>femhigh)=0;
    yf(xf<femlow)=0;
    gval = sum;
    limlow = femlow;
    limhigh = femhigh;
end
   
if(sum>1)
    yf(xf>manhigh)=0;
    yf(xf<manlow)=0;
    gval = summ;
    limlow = femlow;
    limhigh = femhigh;
end


yzen = real(ifft(yf));
pyz = rms(yzen);
yzen = yzen.*pk/pyz;
%sound(yzen,Fs)

%plot(xf,(2/L)*abs(yf(1:L/2)))
haradd = 3;

for i = limlow:limhigh
    times = (Fs/2)/(limlow);
    inval=double(1);
    kt = double(i);
    for j = 1:haradd
        yf(int32(double(2*j+1)*double(kt)))=double(inval)*0.8;%exp(-gval);
        inval = yf(int32(double(j+1)*double(kt)));
    end
end

yf(int32(L/2):L)=0;
yf = abs(yf);

disp("done")

% rectangular window design
winsize=1000;
win = ones(winsize,1);

disp("block analysis")

for j = 1:winsize:int32(((int32(L/winsize))-1)*int32(winsize))
        resol = abs(yf(j:j+winsize-1));
        %disp(j)
        [ max_resol,ylower ] = envelope( yf );
        yf(yf==max_resol)=0;
        %yf((yf)<=1.1*(max_resol) & abs(yf)>=0.9*(max_resol))=0;
end

                    
yzen = real(ifft(yf));
plot(xf,(2/L)*abs(yf(1:L/2)))

%yzen = interp(yzen,1) + repmat(yzen,1,1);

pyz = rms(yzen);
yzen = yzen.*2*pk/pyz;
%yzen = movmean(yzen,(Fs)/3000);

pyz = rms(yzen);
yzen = yzen.*2*pk/pyz;


%plot(xf,(2/L)*abs(yf(1:L/2)))

figure
plot(yzen)
sound(yzen,Fs)
