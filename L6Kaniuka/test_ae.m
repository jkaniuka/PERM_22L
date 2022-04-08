clear all;
[x, fs] = audioread("aeiouy.wav");
x = x / max(x);



f0_arr = [];
f_max = 300;
lag_min = fs / f_max;
f0_win_size = 1600;
t = linspace(0, length(x)/fs, length(x));
t2 = linspace(0, (length(x)-f0_win_size)/fs, length(x)-f0_win_size);

x = x - mean(x);
x = x / max(x);


win = round(fs * 0.2);
ste = conv(x.^2, ones(1,win), 'same');
ste = ste / max(ste);
str = sqrt(ste);

str_th = 0.015;

for i=1:length(x)
    if str(i) < str_th
        x(i) = 0;
    end
end




for i=1:length(x)-f0_win_size
    crop_signal = x( (i) : f0_win_size+i );
    [c, lags] = xcorr(crop_signal, "normalized");
    c = c(lags > lag_min);
    lags = lags(lags > lag_min);
    if str(i) < str_th
        f0_arr(end+1) = 0;  
    else 
        [M,I] = max(c);
        idx = lags(I);
        f0_win = fs/idx;
        f0_arr(end+1) = f0_win;  
    end
  


end

figure;
to_plot = medfilt1(f0_arr,1601)
plot(t2,to_plot);
ylim([0 200]);