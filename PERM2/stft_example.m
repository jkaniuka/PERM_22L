clear all;
win_len = 512;     % wielkość okna do analizy
win_overlap = 256; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT

% x - wektor próbek audio
% fs - częstotliwość próbkowania
[x, fs] = audioread('dtmf.wav');
[s, f, t] = spectrogram(x, win_len, win_overlap, nfft, fs);
A = abs(s) / nfft;

freq1 = zeros(length(t),1);
freq2 = zeros(length(t),1);

for i=1:length(t)
    [val,idx] = maxk(A(:,i),2);
    fprintf('Sample %d\n', i);
    fprintf('Value1 %d, index1 = %d\n', val(1), idx(1));
    freq1(i) = f(idx(1));
    fprintf('Value2 %d, index2 = %d\n', val(2), idx(2));
    freq2(i) = f(idx(2));
end

max_lim = 1500;
min_lim = 650;

for i=1:length(t)
    if freq1(i) > max_lim || freq1(i) < min_lim
        freq1(i) = 0;
    end
end

for i=1:length(t)
    if freq2(i) > max_lim || freq2(i) < min_lim
        freq2(i) = 0;
    end
end

figure;
plot(freq1)
hold on;
plot(freq2)