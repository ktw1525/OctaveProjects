close all;
clear all;
clc;
# https://tomeko.net/online_tools/hex_to_file.php?lang=en
fid = fopen('/home/ktw/cutecom.log','r');
data0 = fread(fid);

data = 1:1:(length(data0)/2);
for i = 1:1:length(data)
  data(i) = data0(2*i-1) + data0(2*i)*256;    
  if(data(i)==(256*256-1)) 
    data(i) = 0;
  endif  
endfor


t = 1:1:(length(data)/3);
V = 1:1:(length(data)/3);
C = 1:1:(length(data)/3);
Z = 1:1:(length(data)/3);

period = 0;
for i = 1:1 :(length(data)/3)
   V(i) = data(i*3-2);
   C(i) = data(i*3-1);
   Z(i) = data(i*3);
   if(i!=1)
     if(((V(i)-V(1))*(V(i-1)-V(1)) < 0) &&(period ==0)) 
        period = i;
     end   
   end
endfor

figure(1);
plot(t, V,'b.',t, C,'r.',t, Z,'g.');
