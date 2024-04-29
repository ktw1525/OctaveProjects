clear all;
clc;

Len = 300;
Period = 50;

input=makeInputDatas(Len, Period);
inputGraph = figure(1);
subplot(2,1,1);
plot(input.n, input.V1, 'r', input.n, input.V2, 'b',input.n, input.V3, 'g');
title('Voltage (V)');
subplot(2,1,2);
plot(input.n, input.I, 'b');
title('Current (A)');

printf("\r\nTrue Values\r\n");
printf("G1 = %f\r\n",input.G1(1));
printf("C1 = %f\r\n",input.C1(1));
printf("G2 = %f\r\n",input.G2(1));
printf("C2 = %f\r\n",input.C2(1));
printf("G3 = %f\r\n",input.G3(1));
printf("C3 = %f\r\n",input.C3(1));

printf("\r\nEstimated Values\r\n");
ret = rcmeter_vct(input.n, Period, input.V1, input.V2, input.V3, input.dV1dn, input.dV2dn, input.dV3dn, input.I);

printf("\r\nDeepLearning Start\r\n");
