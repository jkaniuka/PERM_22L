[sig, fs] = audioread('noised.wav');
win_len = 512;
win_overlap =256;
nfft = 512;

figure;
plot(sig);
title("Zarejestrowany sygnał");

figure;
spectrogram(sig(:,1), win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
title("Spektrogram zarejestrowanego sygnału");