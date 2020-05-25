% [x2,fs]=audioread('F:\录音1117\7.m4a');
clear;
[x2,fs]=audioread('test13.wav');
load jieguo_test11
delta_length_1_test=delta_length_1;
delta_length_2_test=delta_length_2;
delta_length_3_test=delta_length_3;
delta_length_4_test=delta_length_4;

noise=noise_filter;
noise=noise.Numerator;
Num=low_pass;
Num=Num.Numerator;
cicDecim=dsp.CICDecimator(16,17,3);
x= filter(noise,1,x2);

for i=1:length(x)
   x1(i,1)=x(i,1)*cos(2*pi*20000*i/fs);          %R(t)*cos(2*pi*f*t)
end
for i=1:length(x)
   x3(i,1)=-x(i,1)*sin(2*pi*20000*i/fs);          %R(t)*sin(2*pi*f*t)
end

y = fft(x);
N=length(y);
n=1:length(y);
f=n*fs/length(y);



%x4 = filter(Num,1,x1);                            %低通滤波器，Num为filter designer设计的FIR滤波器export的参数，该滤波器可用filter designer打开附加的Iow_pass.fda得到
%x5 = filter(Num,1,x3);
x4=cicDecim(x1);
x5=cicDecim(x3);
y2=fft(x4);
y3=fft(x5);
n2=1:length(y2);
f2=n2*fs/length(y2);
bbb1=abs(y2);


x4_down=downsample(x4,1);
x5_down=downsample(x5,1);
x4_pinhua=smooth(x4_down,10,'lowess');
x5_pinhua=smooth(x5_down,10,'lowess');
%对声音信号处理，裁去前后的突变段
x_p_c=signal_process(x4_pinhua);
x_p_o=signal_process(x5_pinhua);

%计算static component
std_signal_c=std(x4(round(0.04*length(x4)):round(0.06*length(x4))));
std_signal_o=std(x5(round(0.04*length(x5)):round(0.06*length(x5))));
Thr_c=3*std_signal_c;
Thr_o=3*std_signal_o;
E_try_c=LEVD(x_p_c,Thr_c);
x_static_c=LEVD_s(x_p_c,Thr_c);
E_try_o=LEVD(x_p_o,Thr_o);
x_static_o=LEVD_s(x_p_o,Thr_o);
x_real_c=x_p_c-x_static_c;
x_real_o=x_p_o-x_static_o;

%求得LEVD
std_signal1_c=std(x_real_c(round(0.01*length(x_real_c)):round(0.02*length(x_real_c))));
Thr1_c=3*std_signal1_c;
E_test_c=LEVD(x_real_c,Thr1_c);
std_signal1_o=std(x_real_o(round(0.01*length(x_real_o)):round(0.02*length(x_real_o))));
Thr1_o=3*std_signal1_o;
E_test_o=LEVD(x_real_o,Thr1_o);
[TP,TP1]= TPI(E_test_c,E_test_o);
[delta_length_1,delta_length_2]=phase_change(x_real_c(1:TP(1,3)),x_real_o(1:TP(1,3)));
[delta_length_3,delta_length_4]=phase_change(x_real_c(TP(2,3):TP(3,3)),x_real_o(TP(2,3):TP(3,3)));

S1=1-sqrt((delta_length_1-delta_length_1_test)^2+(delta_length_2-delta_length_2_test)^2)/(sqrt(delta_length_1^2+delta_length_2^2)+sqrt(delta_length_1_test^2+delta_length_2_test^2));
S2=1-sqrt((delta_length_3-delta_length_3_test)^2+(delta_length_4-delta_length_4_test)^2)/(sqrt(delta_length_3^2+delta_length_3^2)+sqrt(delta_length_4_test^2+delta_length_4_test^2));
if (S1>0.7)&&(S2>0.7)
    imshow('锁频图案.png')
end
%save jieguo_test13 delta_length_1 delta_length_2 delta_length_3 delta_length_4