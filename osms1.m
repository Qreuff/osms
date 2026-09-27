A = 3; % амплитуда
f = 12; % частота (2п. МАКСИМАЛЬНАЯ ЧАСТОТА - 12)
phi = pi/8; % начальная фаза
T = 1/f; % период сигнала
t = 0 : T/1000 : 2*T; % шаг дискретизации
y = A * sin(2 * pi * f * t + phi); % сигнал

figure;
plot(t, y);
grid on;
xlabel('time, sec');
ylabel('amplitude');
ylim([-4, 4]);

% по теореме котельникова
% частота дискритизации в 2 раза больше частоты сигнала
% 12 * 2 = 24

Fd = f * 4 * 4;
%4
time = 1;
sd = 1/Fd; % шаг дискретизации (шаг дискретизации)
vt = 0 : sd : time; % (вектор времени для отсчетов)
n = length(vt); % кол-во отсчетов

ydis = A * sin(2 * pi * f * vt + phi);
fprintf('4)' , n);

%5
fur = fft(ydis);
df  = Fd / n;
memoryb = n * 4; %float

f_os = (0:n-1) * df; % ось частот
figure;
stem(f_os, abs(fur)/n, "filled");
grid on;
xlabel('frequency, ghz');
ylabel('amplitude');

%6
t_aft = 0 : 0.0001 : 1;
y_aft = A * sin(2 * pi * f * t_aft + phi);
figure;
plot(t_aft, y_aft); hold on; % 2 графика на 1 окне
plot(vt, ydis, 'ro-', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
grid on;

xlabel('time, sec');
ylabel('amplitude');

%9
voicename = 'voice1.wav';
[y, Fs] = audioread(voicename);
fprintf('frequency sample = %d ghz\n', Fs);
fprintf('num of counts = %d\n', length(y));

%10

% 172800 / 3.6 = 48000 
% cходится

%11

y1 = downsample(y, 10); % берется каждый 10 элемент 
zvuk = audioplayer(y1, Fs/10); % уменьшение частоты дискретизации 
play(zvuk);
plot(y1);

%12

Y1 = fft(y);
P1 = abs(Y1(1 : length(y) / 2 + 1));
f1 = Fs * (0 : (length(y) / 2)) / length(y);

Y2 = fft(y1);
P2 = abs(Y2(1 : length(y1) / 2 + 1));
f2 = (Fs / 10) * (0 : (length(y1) / 2)) / length(y1);

figure;

subplot(2,1,1);
plot(f1, P1);
title('original');
xlabel('frequency, hz');
ylabel('magnitude');
grid on;

subplot(2,1,2);
plot(f2, P2, 'm');
title('after');
xlabel('frequency, hz');
ylabel('magnitude');
grid on;

%13

t13 = 0 : T / 1000 : T * 2;
yclean = A * sin(2 * pi * f * t13 + phi);
figure;

for okrug = 3:6;
    maxvalue = 2 ^ okrug - 1;
    yqual = round((yclean + A) / (A * 2) * maxvalue) / maxvalue * A * 2 - A;
    Y = fft(yqual);
    P = abs(Y(1 : floor(length(yqual) / 2) + 1));
    error = mean(abs(yclean - yqual));
    fprintf('razryzdnost %d bit, max value = %d, err = %.5d\n', okrug, maxvalue, error);

    aa = okrug - 2;
    subplot(4, 1, aa);
    plot(P);
    ylabel('P');
    grid on;
end;
xlabel('num of counts');
