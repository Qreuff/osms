close all;
A = 3;
f = 12;
phi = pi/8;
T = 1/f; 
t = 0 : T/1000 : 2*T; 
y = A * sin(2 * pi * f * t + phi);

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
sd = 1/Fd;
vt = 0 : sd : time - sd;
n = length(vt);

ydis = A * sin(2 * pi * f * vt + phi);
fprintf('4)' , n);

%5
N = length(ydis);
Y_dft = zeros(1, N);

for k = 0:N-1
    summ = 0;
    for m = 0:N-1
        summ = summ + ydis(m+1) * exp(-1i*2*pi*k*m/N);
    end
    Y_dft(k+1) = summ;
end

fur = Y_dft;
df  = Fd / n;
memoryb = n * 4;% float

f_os = (0:n-1) * df;
figure;
stem(f_os, abs(fur)/n, "filled");
grid on;
xlabel('frequency, hz');
ylabel('amplitude');

%6
t_aft = 0 : 0.0001 : 1;
y_aft = A * sin(2 * pi * f * t_aft + phi);
figure;
plot(t_aft, y_aft); hold on;
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

y1 = downsample(y, 10); 
zvuk = audioplayer(y1, Fs/10); 
play(zvuk);
plot(y1);

%12
y_short  = downsample(y(1 : min(48000, length(y))), 10);
y1_short = downsample(y1(1 : min(4800,  length(y1))), 10); 

N1 = length(y_short);
Y1 = zeros(1, N1);
for k = 0:N1-1
    summ = 0;
    for m = 0:N1-1
        summ = summ + y_short(m+1) * exp(-1i*2*pi*k*m/N1);
    end
    Y1(k+1) = summ;
end

P1 = abs(Y1(1 : floor(N1/2) + 1));
f1 = (Fs/10) * (0 : floor(N1/2)) / N1;

N2 = length(y1_short);
Y2 = zeros(1, N2);
for k = 0:N2-1
    summ = 0;
    for m = 0:N2-1
        summ = summ + y1_short(m+1) * exp(-1i*2*pi*k*m/N2);
    end
    Y2(k+1) = summ;
end

P2 = abs(Y2(1 : floor(N2/2) + 1));
f2 = (Fs/100) * (0 : floor(N2/2)) / N2;

figure;
subplot(2,1,1);
plot(f1, P1);
title('original');
xlabel('frequency, Hz');
ylabel('magnitude');
grid on;

subplot(2,1,2);
plot(f2, P2, 'm');
title('after');
xlabel('frequency, Hz');
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
