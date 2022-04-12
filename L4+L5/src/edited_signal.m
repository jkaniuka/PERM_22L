clear all;

[sig, fs] = audioread('noised.wav');

[yHP,fHP]=highpass(sig(:,1), 1000/fs, 100/fs);
[sig_out,imp_out]=bandstop(yHP, 5775/fs, 6600/fs, 150/fs);
[sig_out2,imp_out2]=bandstop(sig_out, 3744/fs, 4538/fs, 150/fs);
[sig_out3,imp_out3]=bandstop(sig_out2, 1775/fs, 2413/fs, 150/fs);

sound(sig_out3,fs);

win_len = 512;
win_overlap =256;
nfft = 512;

figure;
spectrogram(sig_out3, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany');
title(t);

figure;
filtstat(imp_out3)



