# Preprocess

Vr_sample = V_t_r(2:2:length(V_t_r));
[AVr5,BVr5] = separateFreq(n5,Vr_sample,stepNumber/2);
[AVr7,BVr7] = separateFreq(n7,Vr_sample,stepNumber/2);
[AVr11,BVr11] = separateFreq(n11,Vr_sample,stepNumber/2);

Vs_sample = V_t_s(2:2:length(V_t_s));
[AVs5,BVs5] = separateFreq(n5,Vs_sample,stepNumber/2);
[AVs7,BVs7] = separateFreq(n7,Vs_sample,stepNumber/2);
[AVs11,BVs11] = separateFreq(n11,Vs_sample,stepNumber/2);

Vt_sample = V_t_t(2:2:length(V_t_t));
[AVt5,BVt5] = separateFreq(n5,Vt_sample,stepNumber/2);
[AVt7,BVt7] = separateFreq(n7,Vt_sample,stepNumber/2);
[AVt11,BVt11] = separateFreq(n11,Vt_sample,stepNumber/2);

dVdtr_sample = (V_t_r(3:2:length(V_t_r)) - V_t_r(1:2:length(V_t_r)-2))/tstep/2;
[AdVr5,BdVr5] = separateFreq(n5,dVdtr_sample,stepNumber/2);
[AdVr7,BdVr7] = separateFreq(n7,dVdtr_sample,stepNumber/2);
[AdVr11,BdVr11] = separateFreq(n11,dVdtr_sample,stepNumber/2);

dVdts_sample = (V_t_s(3:2:length(V_t_s)) - V_t_s(1:2:length(V_t_s)-2))/tstep/2;
[AdVs5,BdVs5] = separateFreq(n5,dVdts_sample,stepNumber/2);
[AdVs7,BdVs7] = separateFreq(n7,dVdts_sample,stepNumber/2);
[AdVs11,BdVs11] = separateFreq(n11,dVdts_sample,stepNumber/2);

dVdtt_sample = (V_t_t(3:2:length(V_t_t)) - V_t_t(1:2:length(V_t_t)-2))/tstep/2;
[AdVt5,BdVt5] = separateFreq(n5,dVdtt_sample,stepNumber/2);
[AdVt7,BdVt7] = separateFreq(n7,dVdtt_sample,stepNumber/2);
[AdVt11,BdVt11] = separateFreq(n11,dVdtt_sample,stepNumber/2);

Ig_sample = Ig(2:2:length(Ig)-1);
[AIg5,BIg5] = separateFreq(n5,Ig_sample,stepNumber/2);
[AIg7,BIg7] = separateFreq(n7,Ig_sample,stepNumber/2);
[AIg11,BIg11] = separateFreq(n11,Ig_sample,stepNumber/2);

t_sample = t(2:2:length(t)-1);

#figure(2);
#subplot(3,1,1);
#plot(t_sample,Vr_sample,t_sample,Vs_sample,t_sample,Vt_sample);
#subplot(3,1,2);
#plot(t_sample,dVdtr_sample,t_sample,dVdts_sample,t_sample,dVdtt_sample);
#subplot(3,1,3);
#plot(t_sample,Ig_sample);

# AIg5  = Avr5*Gr  + AdVr5*Cr  + Avs5*Gs  + AdVs5*Cs  + Avt5*Gt  + AdVt5*Ct;
# AIg7  = Avr7*Gr  + AdVr7*Cr  + Avs7*Gs  + AdVs7*Cs  + Avt7*Gt  + AdVt7*Ct;
# AIg11 = Avr11*Gr + AdVr11*Cr + Avs11*Gs + AdVs11*Cs + Avt11*Gt + AdVt11*Ct;
# BIg5  = Bvr5*Gr  + BdVr5*Cr  + Bvs5*Gs  + BdVs5*Cs  + Bvt5*Gt  + BdVt5*Ct;
# BIg7  = Bvr7*Gr  + BdVr7*Cr  + Bvs7*Gs  + BdVs7*Cs  + Bvt7*Gt  + BdVt7*Ct;
# BIg11 = Bvr11*Gr + BdVr11*Cr + Bvs11*Gs + BdVs11*Cs + Bvt11*Gt + BdVt11*Ct;

# Solver01
# Ax = B, x = inv(A)*B
A = [AVr5,  AdVr5,  AVs5,  AdVs5,  AVt5,  AdVt5;
     AVr7,  AdVr7,  AVs7,  AdVs7,  AVt7,  AdVt7;
     AVr11, AdVr11, AVs11, AdVs11, AVt11, AdVt11;
     BVr5,  BdVr5,  BVs5,  BdVs5,  BVt5,  BdVt5;
     BVr7,  BdVr7,  BVs7,  BdVs7,  BVt7,  BdVt7;
     BVr11, BdVr11, BVs11, BdVs11, BVt11, BdVt11;];
B = [AIg5;AIg7;AIg11;BIg5;BIg7;BIg11;];
x = inv(A)*B;

#Ig= V/R + C*dVdt

result_R_r = 1/x(1);
result_C_r = x(2);
result_R_s = 1/x(3);
result_C_s = x(4);
result_R_t = 1/x(5);
result_C_t = x(6);

Ig_pr=Vr_sample/result_R_r + result_C_r*dVdtr_sample;
Ig_ps=Vs_sample/result_R_s + result_C_s*dVdts_sample;
Ig_pt=Vt_sample/result_R_t + result_C_t*dVdtt_sample;

figure(2);
subplot(3,1,1);
plot(t_sample,Vr_sample,t_sample,Vs_sample,t_sample,Vt_sample);
title('Ouput Signals (V)');
subplot(3,1,2);
plot(t_sample,Ig_pr,t_sample,Ig_ps,t_sample,Ig_pt);
title('Ouput Signals (Ig)');
subplot(3,1,3);
plot(t_sample,Ig_sample);
title('Sum of Signal (Ig)');

printf('    result\r\n');
printf(['R_r : ' ,  num2str(result_R_r) , '\r\n']);
printf(['R_s : ' ,  num2str(result_R_s) , '\r\n']);
printf(['R_t : ' ,  num2str(result_R_t) , '\r\n']);
printf(['C_r : ' ,  num2str(result_C_r) , '\r\n']);
printf(['C_s : ' ,  num2str(result_C_s) , '\r\n']);
printf(['C_t : ' ,  num2str(result_C_t) , '\r\n']);