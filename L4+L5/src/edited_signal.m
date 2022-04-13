clear all;

[sig_in, fs] = audioread('noised.wav');

[highpass_out, kernel_HP]=highpass(sig_in(:,1), 700/fs, 100/fs);
[BS_1_out, kern_BS1]=bandstop(highpass_out, 5775/fs, 6600/fs, 150/fs);
[BS_2_out, kern_BS2]=bandstop(BS_1_out, 3744/fs, 4538/fs, 150/fs);
[BS_3_out, kern_BS3]=bandstop(BS_2_out, 1775/fs, 2413/fs, 150/fs);

filtered_signal = BS_3_out;
sound(filtered_signal, fs);

figure;
win_len = 512;
win_overlap =256;
nfft = 512;
spectrogram(BS_3_out, win_len, win_overlap, nfft, fs, ...
    'MinThreshold', -100, 'yaxis');
title(sprintf('Sygnał przefiltrowany'));
% 
% figure;
% filtstat(kernel_BS3)
% matlab2tikz('BS3_gain.tex')


