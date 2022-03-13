clear all;
win_len = 512;     % wielkość okna do analizy
win_overlap = 256; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT

% x - wektor próbek audio
% fs - częstotliwość próbkowania
[x, fs] = audioread('testwav.wav');
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
filtered_freq2 = medfilt1(freq2,6);
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


lower_freq = [nnz(TF1),1];
higher_freq = [nnz(TF1),1];

for i=1:nnz(TF1)
    if max_freq1(i) < 1025
        lower_freq(i) = max_freq1(i);
    end
    if max_freq1(i) > 1025
        higher_freq(i) = max_freq1(i);
    end
    if max_freq2(i) < 1025
        lower_freq(i) = max_freq2(i);
    end
    if max_freq2(i) > 1025
        higher_freq(i) = max_freq2(i);
    end
end
% 
% max_freq1
% max_freq2
% lower_freq
% higher_freq

[rownum,colnum]=size(lower_freq);

low_ref_freq = [697, 770, 852, 941];
high_ref_freq = [1209, 1336, 1477];

out= ""


for i=1:colnum
    [val_low,idx_low]=min(abs(low_ref_freq-lower_freq(i)));
     closest_low=low_ref_freq(idx_low);
     [val_high,idx_high]=min(abs(high_ref_freq-higher_freq(i)));
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
        else closest_high == 1477
            out = append(out,'# ');
        end
    end
end

 out


% możliwe etykiety danych
labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
