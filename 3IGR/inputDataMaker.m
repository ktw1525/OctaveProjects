clear all
clc

#Condition

R_r = 0.4*10^6;
C_r = 66*10^-9;
R_s = 0.5*10^6;
C_s = 10*10^-9;
R_t = 0.8*10^6;
C_t = 22*10^-9;

reducer_V60 = 0.0;

######################################
#Configure

V_max = 220 * sqrt(2);
f = 60;
w = 2*pi*f;
n5 = 5;
n7 = 7;
n11 = 11;
w5 = w*n5;
w7 = w*n7;
w11 = w*n11;
p = 0.01;

amp5_r = p*rand();
amp7_r = p*rand();
amp11_r= p*rand();
amp5_s = p*rand();
amp7_s = p*rand();
amp11_s= p*rand();
amp5_t = p*rand();
amp7_t = p*rand();
amp11_t= p*rand();

stepNumber = 30000;
tstep = 1/f/stepNumber;
cycleNumber = 1;
tfinish = 1/60*cycleNumber;
t = 0:tstep:tfinish;
snr = 0.001;

#Make Datas

  V_t_r = reducer_V60 * V_max * sin(w * t);
  V_t_r = V_t_r + ...
  V_max * amp5_r * sin(w5*t) + ...
  V_max * amp7_r * sin(w7*t) + ...
  V_max * amp11_r * sin(w11*t);


  dVdt_r = reducer_V60 * V_max * w * cos(w * t);
  dVdt_r = dVdt_r + ...
  V_max * amp5_r * w5 * cos(w5*t) + ...
  V_max * amp7_r * w7 * cos(w7*t) + ...
  V_max * amp11_r * w11 * cos(w11*t);

  V_t_s = reducer_V60 * V_max * sin(w * t + pi*2/3);
  V_t_s = V_t_s + ...
  V_max * amp5_s * sin(w5*t + pi*2/3) + ...
  V_max * amp7_s * sin(w7*t + pi*2/3) + ...
  V_max * amp11_s * sin(w11*t + pi*2/3);

  dVdt_s = reducer_V60 * V_max * w * cos(w * t + pi*2/3);
  dVdt_s = dVdt_s + ...
  V_max * amp5_s * w5 * cos(w5*t + pi*2/3) + ...
  V_max * amp7_s * w7 * cos(w7*t + pi*2/3) + ...
  V_max * amp11_s * w11 * cos(w11*t + pi*2/3);
  

  V_t_t = reducer_V60 * V_max * sin(w * t - pi*2/3);
  V_t_t = V_t_t + ...
  V_max * amp5_t * sin(w5*t - pi*2/3) + ...
  V_max * amp7_t * sin(w7*t - pi*2/3) + ...
  V_max * amp11_t * sin(w11*t - pi*2/3);

  dVdt_t = reducer_V60 * V_max * w * cos(w * t - pi*2/3);
  dVdt_t = dVdt_t + ...
  V_max * amp5_t * w5 * cos(w5*t - pi*2/3) + ...
  V_max * amp7_t * w7 * cos(w7*t - pi*2/3) + ...
  V_max * amp11_t * w11 * cos(w11*t - pi*2/3);
  
Ig = V_t_r/R_r + dVdt_r * C_r + ...
    V_t_s/R_s + dVdt_s * C_s + ...
    V_t_t/R_t + dVdt_t * C_t;

figure(1);
subplot(2,1,1);
plot(t,V_t_r,t,V_t_s,t,V_t_t);
title('Input Signal (V)');
subplot(2,1,2);
plot(t,Ig);
title('Input Signal (Ig)');

printf('         condition   \r\n');
printf(['R_r : ' , num2str(R_r) , '\r\n']);
printf(['R_s : ' , num2str(R_s) , '\r\n']);
printf(['R_t : ' , num2str(R_t) , '\r\n']);
printf(['C_r : ' , num2str(C_r) , '\r\n']);
printf(['C_s : ' , num2str(C_s) , '\r\n']);
printf(['C_t : ' , num2str(C_t) , '\r\n']);

clear R_r R_s R_t C_r C_s C_t
clear amp11_r amp11_s amp11_t
clear amp5_r amp5_s amp5_t
clear amp7_r amp7_s amp7_t
clear V_max
clear f p reducer_V60 snr tfinish w w11 w7 w5
