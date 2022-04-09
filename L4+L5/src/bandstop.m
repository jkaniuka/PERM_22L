function [y,kernel] = bandpass(sig,fL,fH,BW)

M=floor(4/BW); % długość jądra
if mod(M,2)==1 % M musi być parzyste
    M=M+1;
end

i=0:M;
sinc_func_LOW=2*pi*fL*sinc(2*fL*(i-M/2)); % lowpass 1
sinc_func_HIGH=2*pi*fH*sinc(2*fH*(i-M/2)); % lowpass 2

w=0.42-0.5*cos(2*pi*i/M)+0.08*cos(4*pi*i/M); % okno Blackmana

fL=sinc_func_LOW.*w;
fH=sinc_func_HIGH.*w;

% zapewnienie wzmocnienia=1 dla f=0
fL=fL/sum(fL); % filtr LP1
fH=fH/sum(fH); % filtr LP2

% filtr lowpass2 poddajemy inwersji spektralnej
fH=-fH;
fH(fH==min(fH))=fH(fH==min(fH))+1;

% złożenie jąder filtrów LP i HP w jedno
kernel=(fL+fH);

y=conv(sig,kernel); % splot sygnału i jądra filtru

end
