clear all
clc

#Condition

R_t = 0.4*10^6;
C_t = 66*10^-9;

######################################
#Configure
reducer_V60 = 0;
V_max = 220 * sqrt(2);
f = 60;
w = 2*pi*f;
n5 = 5;
n7 = 7;
n11 = 11;
w5 = w*n5;
w7 = w*n7;
w11 = w*n11;


stepNumber = 1000;
tstep = 1/f/stepNumber;
cycleNumber = 1;
samples = stepNumber*cycleNumber;
tfinish = 1/60*cycleNumber;
t = 0:tstep:tfinish;
idx = 1:samples;
snr = 0.001;

#Make Datas

V_t = reducer_V60 * V_max * sin(w * t);
V_t = V_t + V_max*snr*rand(1,length(V_t));
dVdt_t = diff(V_t)/tstep;
V_t = V_t(idx);
t = t(idx);
Ig_t = V_t/R_t + dVdt_t * C_t;

figure(1);
subplot(2,1,1);
plot(t, V_t);
title('Input Signal (V)');
subplot(2,1,2);
plot(t, Ig_t);
title('Input Signal (Ig)');

printf('         condition   \r\n');
printf(['R_true : ' , num2str(R_t) , '\r\n']);
printf(['C_true : ' , num2str(C_t) , '\r\n']);

clear R_t C_t
clear amp11_r amp11_s amp11_t
clear amp5_r amp5_s amp5_t
clear amp7_r amp7_s amp7_t
clear V_max
clear f p reducer_V60 snr tfinish w w11 w7 w5
