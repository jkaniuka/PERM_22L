% Parametry systemu
Fs = 1000;     % Częstotliwość próbkowania [Hz]
T = 1/Fs;      % Okres próbkowania [s]
L = 2000;      % Długość sygnału (liczba próbek)
t = (0:L-1)*T; % Podstawa czasu

% Przygotowanie sygnału
N = 3;               % Liczba sinusoid w mieszaninie
A = [1.0   0.4  0.8] % Amplitudy kolejnych sinusoid
B = [ 15    27   83] % Częstotliwości kolejnych sygnałów [Hz]
C = [  0 -pi/3 pi/7] % Przesunięcia fazowe kolejnych sygnałów


x = zeros(size(t));
for i = 1:N
  x = x + A(i) * cos(2 * pi * B(i) * t + C(i));
end


% Dodanie szumu 
x = x + randn(size(t));

Y = fft(x);     % transformata Fouriera

A = abs(Y);     % amplituda sygnału
A = A/L;        % normalizacja amplitudy

A = A(1:L/2+1); % wycięcie istotnej części spektrum
A(2:end-1) = 2*A(2:end-1);

F = angle(Y);   % faza sygnału
F = F(1:L/2+1); % wycięcie istotnej części spektrum

f_step = Fs/L;     % zmiana częstotliwości
f = 0:f_step:Fs/2; % oś częstotliwości do wykresu

figure;
plot(f, A);        % wykres amplitudowy
figure;
plot(f, F);        % wykres fazowy


% Wektory na odzyskiwane parametry sygnałów
amplitudes = maxk(A,3); % odczytanie amplitud
frequences = zeros(1,N);
phases = zeros(1,N);

% Odczytanie częstotliwości
for i = 1:N
    idx = find(A == amplitudes(i));
    frequences(i) = f(idx);
end

% Odczytanie faz sygnałów
for i = 1:N
    idx = find(f == frequences(i));
    phases(i) = F(idx);
end

% Wykreślenie sygnału odzyskanego
x_recovered = zeros(size(t));
for i = 1:N
  x_recovered = x_recovered + ...
        amplitudes(i) * cos(2 * pi * frequences(i) * t + phases(i));
end

figure;
plot(x);
hold on;
plot(x_recovered);
legend('noisy', 'recovered');
xlabel('time [ms]');
ylabel('amplitude');

amplitudes 
frequences
phases






