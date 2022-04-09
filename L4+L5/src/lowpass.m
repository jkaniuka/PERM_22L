
% Parametry:
% sig - sygnal wejsciowy
% fc - czestotliwosc graniczna
% BW - szerokosc pasma przejsciowego (wyrazona jako ulamek fs)
% 
% Wartosci zwracane:
% y - sygnal po przefiltrowaniu
% f - odp.imp. filtru

function [y,f] = lowpass(sig,fc,BW)

M=floor(4/BW); % ustalenie liczby probek filtru
if mod(M,2)==1 % jesli M nieparzyste, to zamien na najlblizsza parzysta
    M=M+1;
end    

n=0:M;

sinc_sig=2*pi*fc*sinc(2*fc*(n-M/2)); % funkcja sinc

w=0.42-0.5*cos(2*pi*n/(M))+0.08*cos(4*pi*n/(M)); % okno Blackmana

f=(sinc_sig.*w);

K=sum(f); % K dobieramy tak, by suma probek filtru = 1
f=f/K; % filtr LP

y=conv(sig,f); % splot sygnalu wejsciowego i odp. imp. filtru

end