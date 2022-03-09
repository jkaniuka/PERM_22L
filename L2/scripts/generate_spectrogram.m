[x, fs] = audioread('dtmf.wav');
win_len = 512;     % wielkość okna do analizy
win_overlap = 256; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT

spectrogram(x, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis')