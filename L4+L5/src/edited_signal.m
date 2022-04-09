clear all;

[sig, fs] = audioread('noised.wav');

BW=176.4; % szerokosc pasma przejsciowego w Hz
BW=BW/fs;

% czestotliwosci w HZ
f_cutoff_LP=8000;
f_cutoff_HP=1000;
f_cutoff_BP1=100;
f_cutoff_BP2=1500;


% czestotliwosci wyrazone jako ulamek fs
fc_LP=f_cutoff_LP/fs;
fc_HP=f_cutoff_HP/fs;
fc_BP1=f_cutoff_BP1/fs;
fc_BP2=f_cutoff_BP2/fs;




% [yLP,fLP]=lowpass(sig(:,1),fc_LP, BW);
% [yBP2,fBP2]=bandpass(sig(:,1),fc_BP1,fc_BP2, BW);
[yHP,fHP]=highpass(sig(:,1),fc_HP, BW);
[sig_out,imp_out]=bandstop(yHP,5531/fs,6938/fs, BW);
[sig_out2,imp_out2]=bandstop(sig_out,3375/fs,4500/fs, BW);
[sig_out3,imp_out3]=bandstop(sig_out2,1813/fs,2313/fs, BW);
[sig_out4,imp_out4]=lowpass(sig_out3,4000/fs, BW);
% [sig_out4,imp_out4]=bandstop(sig_out3,6781/fs,6969/fs, BW);
% [sig_out5,imp_out5]=lowpass(sig_out4,3200/fs, BW);
% [sig_out6,imp_out6]=bandstop(sig_out5,1344/fs,2094/fs, BW);
% [yBS2,fBS2]=bandstop(yHP,4000/fs,4188/fs, BW);
% [yBS2,fBS2]=bandstop(sig(:,1),fc_BP1,fc_BP2, BW);

output = sig_out4;
sound(5*output,16000);


win_len = 512;
win_overlap =256;
nfft = 512;

% figure;
% spectrogram(yLP, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
% t=sprintf('Sygnał przefiltrowany filtrem LP, fc=%dHz',f_cutoff_LP);
% title(t);



% figure;
% spectrogram(yBP2, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
% t=sprintf('Sygnał przefiltrowany filtrem BP, fc1=%dHz, fc2=%dHz',f_cutoff_BP1,f_cutoff_BP2);
% title(t);
% 
% figure;
% spectrogram(yHP, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
% t=sprintf('Sygnał przefiltrowany filtrem HP, fc=%dHz',f_cutoff_HP);
% title(t);



figure;
spectrogram(output, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany filtrem BS, fc1=%dHz, fc2=%dHz',f_cutoff_BP1,f_cutoff_BP2);
title(t);



