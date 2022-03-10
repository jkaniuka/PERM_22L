clear all;
win_len = 512;     % wielkość okna do analizy
win_overlap = 256; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT
% x - wektor próbek audio
% fs - częstotliwość próbkowania
[x, fs] = audioread('dtmf.wav');
[s, f, t] = spectrogram(x, win_len, win_overlap, nfft, fs);
A = abs(s) / nfft;

% wyświetlenie przebiegu czasowego trzech wybranych częstotliwości


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


% figure;
% plot(freq1);
% hold on;
% plot(freq2);
% yline(1209,'--r')
% yline(1336,'--g')
% yline(1477,'--b')
% yline(697,'--c')
% yline(770,'--m')
% yline(852,'--y')
% yline(941,'--k')
figure;
my_array = medfilt1(freq1,10);
TF1 = islocalmax(my_array,'FlatSelection','first');
x_axis_scale  = 1:1:309;
plot(x_axis_scale,my_array,x_axis_scale(TF1),my_array(TF1),'r*')
hold on;
my_array2 = medfilt1(freq2,10);
TF2 = islocalmax(my_array2,'FlatSelection','first');
x_axis_scale  = 1:1:309;
plot(x_axis_scale,my_array2,x_axis_scale(TF2),my_array2(TF2),'r*')
yline(1209,'--r')
yline(1336,'--g')
yline(1477,'--b')
yline(697,'--c')
yline(770,'--m')
yline(852,'--y')
yline(941,'--k')

totals = [nnz(TF1),1];

next_idx = 1;
for i=1:length(TF1)
    if TF1(i) == 1
        totals(next_idx) = my_array(i);
        next_idx = next_idx+1;
    end
end

next_idx = 1;
for i=1:length(TF2)
    if TF2(i) == 1
        totals(next_idx) = totals(next_idx)+ my_array2(i);
        next_idx = next_idx+1;
    end
end

eps = 10;
result = zeros(1,length(totals));
for i=1:length(totals)
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '1';
    end
  
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '2';
    end
    
    if 0  + eps< totals(i) < 0 + eps
        result(i) = '3';  
        disp('hello');
    end
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '4';
    end
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '5';
    end
    if 0  + eps< totals(i) < 0 + eps
        result(i) = '6';
    end
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '7';
    end
    if 0  + eps< totals(i) < 0 + eps
        result(i) = '8';
    end
    if 0  + eps< totals(i) < 0 + eps
        result(i) = '9';
    end
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '*';
    end
    if 0 + eps < totals(i) < 0 + eps
        result(i) = '0';
    end
     if 0 + eps < totals(i) < 0 + eps
        result(i) = '#';
     end
       
end

totals
 result






% możliwe etykiety danych
labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];

