clear all 

snrval = 5;

[k,Fs] = audioread('man_voice.wav');
k = k.*0.5/rms(k);
y0=k;
k = awgn(k,snrval,'measured');
k = k.*0.5/rms(k);

x=k;
% y = sum(abs(diff(x>0)))/length(x)   %zero crossing rate

winLen = double(int32(Fs*0.025));

ste = sum(buffer(k.^2, winLen));
steflag = ones(length(ste),1);
diffste = diff(ste);

for i=1:int32(length(diffste))
    if(abs(diffste(i))<=15)
        steflag(i) = 0;
    end
end

p = zeros(length(k),1);
q = zeros(length(k),1);

for i=1:int32(length(steflag)-3)
    if(steflag(i)==1)
        if(steflag(i+2)==1)
            steflag(i+1)=1;
        end
    end
    %if(steflag(i)==0)
    %    if(steflag(i+2)==0)
    %        steflag(i+1)=0;
    %   end
    %end
end

noise = [];

for i=1:int32(length(steflag)-1)
    if(steflag(i)==1)
        p(winLen*(i-1)+1:winLen*(i)+1)= k(winLen*(i-1)+1:winLen*(i)+1);
    end
    if(steflag(i)==0)
        q(winLen*(i-1)+1:winLen*(i)+1)= k(winLen*(i-1)+1:winLen*(i)+1);
    end
end

max = 0;
farray = find(steflag==0);

for i=1:length(farray)
    for j=i:length(farray)
        if(mean(steflag(i:j))==0)
            if(j-i>=max)
                minf = i;
                maxf = j;
                max = j-i;
            end
        end
    end
end

noise = q((minf-1)*winLen+1:(maxf-1)*winLen)+1;
%rmsn = sum(noise.^2)/length(noise)
varn = var(noise);

snr=[];
emp=[];
empf=[];
for i=0:0.01:0.5
    [c,l] = wavedec(k,5,'db20');
    b = wthresh(c,'s',i);
    x = waverec(b,l,'db20');
    %threshval = i;
    noisex = x((minf-1)*winLen+1:(maxf-1)*winLen)+1;
    varnx = var(noisex);
    
    if(10*log(varnx/varn)<=-11.5)
        threshval = i;
        break;
    end
end

threshval

subplot(4,1,1)
plot(k)
title('noisy signal')
subplot(4,1,2)
plot(p)
title('voice activity from noisy signal')
subplot(4,1,3)
plot(q)
title('noise avtivity from noisy signal')

[c,l] = wavedec(p,5,'db20');
jk = wthresh(c,'s',threshval);
pfin=waverec(jk,l,'db20');

subplot(4,1,4)
plot(pfin)
title('denoised voice activity')

sound(k,Fs)
pause(length(k)/Fs+1)
sound(pfin,Fs)