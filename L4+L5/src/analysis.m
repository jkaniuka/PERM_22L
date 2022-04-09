clear all;

[sig, fs] = audioread('noised.wav');

BW=176.4; % szerokosc pasma przejsciowego w Hz
BW=BW/fs;

% czestotliwosci w HZ
f_cutoff_LP=3000;
f_cutoff_HP=200;
f_cutoff_BP1=1500;
f_cutoff_BP2=3500;


% czestotliwosci wyrazone jako ulamek fs
fc_LP=f_cutoff_LP/fs;
fc_HP=f_cutoff_HP/fs;
fc_BP1=f_cutoff_BP1/fs;
fc_BP2=f_cutoff_BP2/fs;




[yLP,fLP]=lowpass(sig(:,1),fc_LP, BW);
[yHP,fHP]=highpass(sig(:,1),fc_HP, BW);
[yBP2,fBP2]=bandpass(sig(:,1),fc_BP1,fc_BP2, BW);
[yBS2,fBS2]=bandstop(sig(:,1),fc_BP1,fc_BP2, BW);



win_len = 512;
win_overlap =256;
nfft = 512;

figure;
spectrogram(yLP, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany filtrem LP, fc=%dHz',f_cutoff_LP);
title(t);

figure;
spectrogram(yHP, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany filtrem HP, fc=%dHz',f_cutoff_HP);
title(t);


figure;
spectrogram(yBP2, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany filtrem BP, fc1=%dHz, fc2=%dHz',f_cutoff_BP1,f_cutoff_BP2);
title(t);

figure;
spectrogram(yBS2, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis');
t=sprintf('Sygnał przefiltrowany filtrem BS, fc1=%dHz, fc2=%dHz',f_cutoff_BP1,f_cutoff_BP2);
title(t);

figure;
plot(fLP);
title("Odp.imp. filtru LP");
figure;
plot(fHP);
title("Odp.imp. filtru HP");

filtstat(fBP2);


