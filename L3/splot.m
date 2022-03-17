t=0:0.001:0.999;
sig_1 = 0.5*sin(6*pi*t) + 0.1 * randn(1, 1000);
sig_2 = sign(0.5*sin(6*pi*t)) + 0.1 * randn(1, 1000);
figure;
plot(t, sig_1);
figure;
plot(t, sig_2);

[r1, lags] = xcorr(sig_1);
[r2, lags] = xcorr(sig_2);
% wycięcie jedynie dodatnich przesunięć
r1 = r1(lags >= 0);
r2 = r2(lags >= 0);
lags = lags(lags>=0);

figure;
plot(lags, r1);
figure;
plot(lags, r2);

[pks, loc] = findpeaks(r1, "MinPeakDistance", 10, "MinPeakProminence", 20);
fs = 1000;
% przesunięcie w sekundach
lag_s = loc(1) * 1/fs;
% częstotliwość bazowa
freq = 1/lag_s

