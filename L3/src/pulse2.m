% Liczba ramek do wczytania (przy 10 sekundach i 30 FPS będzie to 300)
N = 255;
L = N;
Fs = 30;

% wektor jasności
br = zeros(1, N);

% lista obrazów do analizy
%imds = imageDatastore('.', 'FileExtension', '.jpg');

% alternatywnie można załadować bezpośrednio plik wideo
% v = VideoReader('C:\Users\kanja\Desktop\Studia\SEM 6\PERM\lab_perm\L3\src\test5.mp4');
v = VideoReader('C:\Users\kanja\Desktop\output.mp4');



% wczytanie pierwszych N obrazów i analiza jasności
for i=1:N
    % wczytujemy obraz i przekształcamy go do skali szarości
    %I = rgb2gray(imread(imds.Files{i}));
    % dla pliku wideo ładowanie ramki z otwartego źródła
    I = rgb2gray(read(v,i));

    % wyznaczamy średnią z całego obrazu
    br(i) = mean(I, 'all');
end

% dla ułatwienia późniejszej analizy od razu można odjąć od sygnału składową stałą
br = br - mean(br);
figure;
plot(br, 'LineWidth', 1.5);
xlim([0 N])
xlabel('sample')
ylabel('brightness')
title('Raw signal')


f3 = ones(1,3) / 3;
c3_1 = conv(br, f3, 'same');
figure;
plot(c3_1, 'LineWidth', 1.5);
xlabel('sample')
ylabel('brightness')
title('After MA filtering')

[r1, lags] = xcorr(c3_1);
r1 = r1(lags >= 0);
lags = lags(lags>=0);
figure;
plot(30./lags, r1, 'LineWidth', 1.5);
hold on;
plot(lags, r1, 'LineWidth', 1.5);
title('Autocorrelation')

[pks, loc] = findpeaks(r1);

fs = 30;
% przesunięcie w sekundach
lag_s = loc(1) * 1/fs;
% częstotliwość bazowa
freq = 1/lag_s
BPM = freq * 60


