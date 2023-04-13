clc;
clear;
close all;
%波形生成
Fs=25e6;
f=1e6;
t=0:1/Fs:199/Fs;
wave_sin=sin(2*pi*f*t);
wave_square=square(2*pi*f*t);
wave_sawtooth=sawtooth(2*pi*f*t,0.5);
[w_sin,Y_sin]=bilateral_fft(wave_sin,Fs,200);
[w_square,Y_square]=bilateral_fft(wave_square,Fs,512);
[w_sawtooth,Y_sawtooth]=bilateral_fft(wave_sawtooth,Fs,512);
figure();
subplot(2,1,1);
plot(t,wave_sin);
xlabel('t');
ylabel('sin(t)');
title('正弦波波形');
subplot(2,1,2);
plot(w_sin,Y_sin);
xlabel('f(Hz)');
ylabel('H(e^{jw})');
title('正弦波频谱');

figure();
subplot(2,1,1);
plot(t,wave_square);
xlabel('t');
ylabel('square(t)');
title('方波波形');
axis([0 8e-6 -1.1 1.1]);
subplot(2,1,2);
plot(w_square,Y_square);
xlabel('f(Hz)');
ylabel('H(e^{jw})');
title('方波频谱');

figure();
subplot(2,1,1);
plot(t,wave_sawtooth);
xlabel('t');
ylabel('sawtooth(t)');
title('三角波波形');
subplot(2,1,2);
plot(w_sawtooth,Y_sawtooth);
xlabel('f(Hz)');
ylabel('H(e^{jw}');
title('三角波频谱');
%滤波器设计
b=[1 1 1 1 1 1 1 1];
a=1;
[H,w]=freqz(b,a);
dbH=20*log10(abs(H)/max(abs(H)));
figure();
subplot(2,1,1);
plot(w/(2*pi)*Fs,dbH);
xlabel('f/Hz');
ylabel('dB');
title('滤波器相对频率特性');
subplot(2,1,2);
plot(w/(2*pi)*Fs,angle(H)/pi*180)
xlabel('f/Hz');
ylabel('\phi');
title('滤波器相位特性');

%滤波后信号观察
fir_sin=filter(b,a,wave_sin);
fir_square=filter(b,a,wave_square);
fir_sawtooth=filter(b,a,wave_sawtooth);
[w_sin,Y_sin]=bilateral_fft(fir_sin,Fs,200);
[w_square,Y_square]=bilateral_fft(fir_square,Fs,512);
[w_sawtooth,Y_sawtooth]=bilateral_fft(fir_sawtooth,Fs,512);
figure();
subplot(2,1,1);
plot(t,fir_sin);
xlabel('t');
ylabel('sin(t)');
title('滤波后正弦波波形');
subplot(2,1,2);
plot(w_sin,Y_sin);
xlabel('f(Hz)');
ylabel('H(e^{jw})');
title('滤波后正弦波频谱');

figure();
subplot(2,1,1);
plot(t,fir_square);
xlabel('t');
ylabel('square(t)');
title('滤波后方波波形');
subplot(2,1,2);
plot(w_square,Y_square);
xlabel('f(Hz)');
ylabel('H(e^{jw})');
title('滤波后方波频谱');

figure();
subplot(2,1,1);
plot(t,fir_sawtooth);
xlabel('t');
ylabel('sawtooth(t)');
title('滤波后三角波波形');
subplot(2,1,2);
plot(w_sawtooth,Y_sawtooth);
xlabel('f(Hz)');
ylabel('H(e^{jw})');
title('滤波后三角波频谱');

function [f,Y]=bilateral_fft(y,Fs,L)%fft的单边谱
    %f为对应频率点
    %y为输入的信号
    %Fs为信号采样频率
    yw=fftshift(fft(y,L));
    Y = abs(yw/L);
    f = Fs*(-L/2:L/2-1)/L;
end