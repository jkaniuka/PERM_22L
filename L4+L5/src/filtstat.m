function filtstat(f)
    nfft = 1000;
    fs = 1000;
    
    f_ex = zeros(1, nfft);
    f_ex(1:size(f, 2)) = f;
    
    y=fft(f_ex);
    f_base = linspace(0, fs/2, nfft/2+1);
    amp = abs(y(1:nfft/2+1));
    plot(16*f_base, amp, 'LineWidth',1.5);
    grid on;
    xlabel('Hz');
    ylabel('Wzmocnienie');
end