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
%     fprintf('Sample %d\n', i);
%     fprintf('Value1 %d, index1 = %d\n', val(1), idx(1));
    freq1(i) = f(idx(1));
%     fprintf('Value2 %d, index2 = %d\n', val(2), idx(2));
    freq2(i) = f(idx(2));
end


figure;
plot(freq1)
hold on;
plot(freq2)
title("Bez filtracji")
xlabel("Numer chwili czasu")
ylabel("Dominująca częstotliwość")

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
title("Po wstępnej filtracji")
xlabel("Numer chwili czasu")
ylabel("Dominująca częstotliwość")


% Wygładzanie filtrem medianowym
figure;
filtered_freq1 = medfilt1(freq1,6);
TF1 = islocalmax(filtered_freq1,'FlatSelection','first'); % wykrywanie początku skoku
x_axis_scale  = 1:1:length(t);
plot(x_axis_scale,filtered_freq1,x_axis_scale(TF1),filtered_freq1(TF1),'r*')
hold on;
filtered_freq2 = medfilt1(freq2,10);
TF2 = islocalmax(filtered_freq2,'FlatSelection','first');
plot(x_axis_scale,filtered_freq2,x_axis_scale(TF2),filtered_freq2(TF2),'r*')
yline(1209,'--r')
yline(1336,'--g')
yline(1477,'--b')
yline(697,'--c')
yline(770,'--m')
yline(852,'--y')
yline(941,'--k')



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

max_freq1 
max_freq2 







% możliwe etykiety danych
labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
