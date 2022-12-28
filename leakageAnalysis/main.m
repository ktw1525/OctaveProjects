close all;
clear all;
clc;
pkg load statistics

Igr_mu1 = 1.580949;
Igr_sig1 = 7.80735;
Igo_mu1 = 3.738155;
Igo_sig1 = 11.301066;

Igr_mu2 = 0.718212;
Igr_sig2 = 1.1289;
Igo_mu2 = 3.316296;
Igo_sig2 = 4.308552;

Igr_mu3 = 0.867885;
Igr_sig3 = 6.194801;
Igo_mu3 = 1.908831;
Igo_sig3 = 9.587354;

Igr_mu4 = 0.364843;
Igr_sig4 = 0.251799;
Igo_mu4 = 1.381927;
Igo_sig4 = 1.865216;


Igr1 = 0:0.1:30;
perc1 = normpdf(Igr1,Igr_mu1,Igr_sig1);
perc10 = normpdf(Igr1,Igo_mu1,Igo_sig1);

Igr2 = 0:0.1:30;
perc2 = normpdf(Igr2,Igr_mu2,Igr_sig2);
perc20 = normpdf(Igr2,Igo_mu2,Igo_sig2);

Igr3 = 0:0.1:30;
perc3 = normpdf(Igr3,Igr_mu3,Igr_sig3);
perc30 = normpdf(Igr3,Igo_mu3,Igo_sig3);

Igr4 = 0:0.1:30;
perc4 = normpdf(Igr4,Igr_mu4,Igr_sig4);
perc40 = normpdf(Igr4,Igo_mu4,Igo_sig4);

figure(1);
subplot(4,1,1);
plot(Igr1,perc1,'r',Igr1,perc10,'b');
subplot(4,1,2);
plot(Igr2,perc2,'r',Igr2,perc20,'b');
subplot(4,1,3);
plot(Igr3,perc3,'r',Igr3,perc30,'b');
subplot(4,1,4);
plot(Igr4,perc4,'r',Igr4,perc40,'b');


