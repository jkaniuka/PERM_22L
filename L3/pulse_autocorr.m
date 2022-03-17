% Liczba ramek do wczytania (przy 10 sekundach i 30 FPS będzie to 300)
N = 255;
L = N;
Fs = 30;

% wektor jasności
br = zeros(1, N);

% lista obrazów do analizy
%imds = imageDatastore('.', 'FileExtension', '.jpg');

% alternatywnie można załadować bezpośrednio plik wideo
v = VideoReader('C:\Users\kanja\Desktop\test5.mp4');


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

% autokorelaja
auto_kor=xcorr(br);
auto_kor=auto_kor(length(auto_kor)/2+1:length(auto_kor));
figure;
plot(auto_kor);
maks=0;
auto_value=0;
for k=2:1:length(auto_kor)-1
    if(auto_kor(k-1)<auto_kor(k) && auto_kor(k)<auto_kor(k+1))
        if(auto_kor(k)>auto_value)
             maks=k;
            auto_value=auto_kor(k);
        end
    end
end
maks
tetno_auto=Fs/maks*60
