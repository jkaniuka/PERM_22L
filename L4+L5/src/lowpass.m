function [y,kernel] = lowpass(sig, fc, BW)

M=floor(4/BW); % długość jądra
if mod(M,2)==1 % M musi być parzyste
    M=M+1;
end

i=0:M;
sinc_func=2*pi*fc*sinc(2*fc*(i-M/2)); % funkcja sinc
window=0.42-0.5*cos(2*pi*i/M)+0.08*cos(4*pi*i/M); % okno Blackmana
kernel=(sinc_func.*window);

% zapewnienie wzmocnienia=1 dla zerowej częstotliwości
kernel=kernel/sum(kernel); 

y=conv(sig,kernel); % splot sygnału z jądrem filtru

end