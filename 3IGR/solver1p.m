# Preprocess

Vr_sample = V_t(2:2:samples);
[AVr5,BVr5] = separateFreq(n5,Vr_sample,stepNumber/2);
[AVr7,BVr7] = separateFreq(n7,Vr_sample,stepNumber/2);
[AVr11,BVr11] = separateFreq(n11,Vr_sample,stepNumber/2);

dVdtr_sample = dVdt_t(1:2:samples);
[AdVr5,BdVr5] = separateFreq(n5,dVdtr_sample,stepNumber/2);
[AdVr7,BdVr7] = separateFreq(n7,dVdtr_sample,stepNumber/2);
[AdVr11,BdVr11] = separateFreq(n11,dVdtr_sample,stepNumber/2);

Ig_sample = Ig_t(1:2:samples);
[AIg5,BIg5] = separateFreq(n5,Ig_sample,stepNumber/2);
[AIg7,BIg7] = separateFreq(n7,Ig_sample,stepNumber/2);
[AIg11,BIg11] = separateFreq(n11,Ig_sample,stepNumber/2);

t_sample = t(2:2:length(t));

A = [AVr5,  AdVr5
     BVr5,  BdVr5];
B = [AIg5; BIg5];
x5 = inv(A)*B;

A = [AVr7,  AdVr7
     BVr7,  BdVr7];
B = [AIg7; BIg7];
x7 = inv(A)*B;

A = [AVr11,  AdVr11
     BVr11,  BdVr11];
B = [AIg11; BIg11];
x11 = inv(A)*B;


result_R_5 = 1/x5(1);
result_C_5 = x5(2);
result_R_7 = 1/x7(1);
result_C_7 = x7(2);
result_R_11 = 1/x11(1);
result_C_11 = x11(2);

printf('    result\r\n');
printf(['R_5 : ' ,  num2str(result_R_5) , '\r\n']);
printf(['R_7 : ' ,  num2str(result_R_7) , '\r\n']);
printf(['R_11 : ' ,  num2str(result_R_11) , '\r\n']);
printf(['C_5 : ' ,  num2str(result_C_5) , '\r\n']);
printf(['C_7 : ' ,  num2str(result_C_7) , '\r\n']);
printf(['C_11 : ' ,  num2str(result_C_11) , '\r\n']);