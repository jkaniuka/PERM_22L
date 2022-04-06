%           FILTR BP
% Parametry:
% sig - sygnal wejsciowy
% fd - dolna czestotliwosc graniczna
% fu - gorna czestotliwosc graniczna
% BW - szerokosc pasma przejsciowego (wyrazona jako ulamek fs)
% 
% Wartosci zwracane:
% y - sygnal po przefiltrowaniu
% f - odp.imp. filtru

function [y,f] = bandstop(sig,fd,fu,BW)

M=floor(4/BW); % ustalenie liczby probek filtru
if mod(M,2)==1 % jesli M nieparzyste, to zamien na najlblizsza parzysta
    M=M+1;
end    

n=0:M;
sinc_sig_d=2*pi*fd*sinc(2*fd*(n-M/2)); % funkcja sinc dla filtru LP1

sinc_sig_u=2*pi*fu*sinc(2*fu*(n-M/2)); % funkcja sinc dla filtru LP2

w=0.42-0.5*cos(2*pi*n/(M))+0.08*cos(4*pi*n/(M)); % okno Blackmana

fd=sinc_sig_d.*w;
fu=sinc_sig_u.*w;

Kd=sum(fd); % K dobieramy tak, by suma probek filtru = 1
Ku=sum(fu); % K dobieramy tak, by suma probek filtru = 1

fd=fd/Kd; % filtr LP1
fu=fu/Ku; % filtr LP2

% inwersja spektralna LP2->HP
fu=-fu;
fu(fu==min(fu))=fu(fu==min(fu))+1;

% polaczenie filtrow (LP1 + HP) -> BR
f=(fd+fu);


y=conv(sig,f); % splot sygnalu wejsciowego i odp. imp. filtru

end
