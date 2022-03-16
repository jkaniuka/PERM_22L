function out = dtmf(x, fs)
% Do testowania programu wykorzystałem poniższy generator
% https://www.audiocheck.net/audiocheck_dtmf.php

win_len = 512;     % wielkość okna do analizy
win_overlap = 256; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT

% x - wektor próbek audio
% fs - częstotliwość próbkowania
[s, f, t] = spectrogram(x, win_len, win_overlap, nfft, fs);
A = abs(s) / nfft;

% Wektory na dwie, dominujące częstotliwości w każdej dyskretnej chwili czasu 
freq1 = zeros(length(t),1);
freq2 = zeros(length(t),1);

for i=1:length(t)
    % szukam częstotliwości, dla której amplituda jest największa
    % szukam dwóch wartości, bo tony są złożeniem dwóch sinusoid
    [~,idx] = maxk(A(:,i),2);
    freq1(i) = f(idx(1));
    freq2(i) = f(idx(2));
end

% Ustalam limity częstotliwości - górny i dolny
% Tony o częstotliwościach spoza zakresu nie będą potrzebne
max_lim = 1500;
min_lim = 650;

% Zeruję częstotliwość, jeśli jest zbyt wysoka/zbyt niska
for i=1:length(t)
    if freq1(i) > max_lim || freq1(i) < min_lim
        freq1(i) = 0;
    end
    if freq2(i) > max_lim || freq2(i) < min_lim
        freq2(i) = 0;
    end
end

% Wygładzanie filtrem medianowym
figure;
filtered_freq1 = medfilt1(freq1,6);
TF1 = islocalmax(filtered_freq1,'FlatSelection','first'); % wykrywanie początku skoku
x_axis_scale  = 1:1:length(t);
plot(x_axis_scale,filtered_freq1,x_axis_scale(TF1),filtered_freq1(TF1),'r*')

hold on;

filtered_freq2 = medfilt1(freq2,6);
TF2 = islocalmax(filtered_freq2,'FlatSelection','first');
plot(x_axis_scale,filtered_freq2,x_axis_scale(TF2),filtered_freq2(TF2),'r*')

% Dodanie wartości referencyjnych do wykresu
yline(1209,'--r', 1209)
yline(1336,'--r', 1336)
yline(1477,'--r', 1477)
yline(697,'--r', 697)
yline(770,'--r', 770)
yline(852,'--r', 852)
yline(941,'--r', 941)
ylim([0 1600]);
xlabel('Numer dyskretnej chwili czasu');
ylabel('Wartość dominującej częstotliwości');
title('Sygnał po przetworzeniu');

% Dodaję do wektorów wartości dominujących częstotliwości
% Odpowiadają one punktom oznaczonym gwiazdką ("*") na wykresie
max_freq1 = [nnz(TF1),1];
max_freq2 = [nnz(TF1),1];

next_idx = 1;
for i=1:length(TF1)
    if TF1(i) == 1
        max_freq1(next_idx) = filtered_freq1(i);
        next_idx = next_idx+1;
    end
end

next_idx = 1;
for i=1:length(TF2)
    if TF2(i) == 1
        max_freq2(next_idx) =filtered_freq2(i);
        next_idx = next_idx+1;
    end
end

% Porządkuję zawartość dwóch wektorów
% Jeden z nich będzie miał częstotliwości wyznaczające wiersz (lower_freq)
% Drugi będzie miał częstotliwości wyznaczające kolumnę (higher_freq)
lower_freq = [nnz(TF1),1];
higher_freq = [nnz(TF1),1];

division_threshold = 1025; 

for i=1:nnz(TF1)
    if max_freq1(i) < division_threshold
        lower_freq(i) = max_freq1(i);
    end
    if max_freq1(i) > division_threshold
        higher_freq(i) = max_freq1(i);
    end
    if max_freq2(i) < division_threshold
        lower_freq(i) = max_freq2(i);
    end
    if max_freq2(i) > division_threshold
        higher_freq(i) = max_freq2(i);
    end
end

[~,colnum]=size(lower_freq);

% Częstotliwości referencyjne
low_ref_freq = [697, 770, 852, 941];
high_ref_freq = [1209, 1336, 1477];

% Alokacja miejsca na wynikowy ciąg znaków
out = "";

% Dla każdej pary częstotliwości składowych odnajduję najbliższą parę
% wartości referencyjnych i na tej podstawie przypisuję kolejny znak
for i=1:colnum
    [~,idx_low]=min(abs(low_ref_freq-lower_freq(i)));
     closest_low=low_ref_freq(idx_low);
     [~,idx_high]=min(abs(high_ref_freq-higher_freq(i)));
     closest_high=high_ref_freq(idx_high);
     
    
    if closest_low == 697
        if closest_high == 1209
            out = append(out,'1 ');
        elseif closest_high == 1336
            out = append(out,'2 ');
        elseif closest_high == 1477
            out = append(out,'3 ');
        end
    end
    
    if closest_low == 770
        if closest_high == 1209
            out = append(out,'4 ');
        elseif closest_high == 1336
            out = append(out,'5 ');
        elseif closest_high == 1477
            out = append(out,'6 ');
        end
    end
    
    if closest_low == 852
        if closest_high == 1209
            out = append(out,'7 ');
        elseif closest_high == 1336
            out = append(out,'8 ');
        elseif closest_high == 1477
            out = append(out,'9 ');
        end
    end
    
    if closest_low == 941
        if closest_high == 1209
            out = append(out,'* ');
        elseif closest_high == 1336
            out = append(out,'0 ');
        elseif closest_high == 1477
            out = append(out,'# ');
        end
    end
end


end