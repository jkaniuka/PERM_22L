% Liczba ramek do wczytania (przy 10 sekundach i 30 FPS będzie to 300)
N = 255
L = N
Fs = 30

% wektor jasności
br = zeros(1, N)

% lista obrazów do analizy
%imds = imageDatastore('.', 'FileExtension', '.jpg');

% alternatywnie można załadować bezpośrednio plik wideo
v = VideoReader('C:/Users/kanja/Desktop/Studia/SEM 6/PERM/lab/L1/test5.mp4');


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


Y = fft(br);     % transformata Fouriera

A = abs(Y);     % amplituda sygnału
A = A/L;        % normalizacja amplitudy

A = A(1:L/2+1); % wycięcie istotnej części spektrum
A(2:end-1) = 2*A(2:end-1);

F = angle(Y);   % faza sygnału
F = F(1:L/2+1); % wycięcie istotnej części spektrum

f_step = Fs/L;     % zmiana częstotliwości
f = 0:f_step:Fs/2; % oś częstotliwości do wykresu

% figure;
% plot(f, A);        % wykres amplitudowy
% figure;
% plot(f, F);        % wykres fazowy


idx = find(A == maxk(A,1));
freq = f(idx);
BPM = freq * 60

% matlab2tikz('pulse_signal.tex')