close all
clear all
clc

trigger_enable = "1";
trigger_channel = "0";
trigger_mode = "1";
trigger_level = "2048";
trigger_offset = "50";
trigger_freqency = "7";

[stat, output] = system(["adb shell /data/app/MRM4-1P-100A --debugWave ", ...
                  trigger_enable, " ", ...
                  trigger_channel, " ", ...
                  trigger_mode, " ", ...
                  trigger_level, " ", ...
                  trigger_offset, " ", ...
                  trigger_freqency]);
s = strfind(output,"start");
e = strfind(output,"end");

datas = eval(["[" , substr(output,s+5,e-s-5) , "]"]);

plot(datas(:,2));

length = 153;
voltage = 0;
for i=1:1:length
  voltage = voltage + datas(i,2)*datas(i,2)/length;
end
voltage = sqrt(voltage);
