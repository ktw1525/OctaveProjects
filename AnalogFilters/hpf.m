
fc = 120;
R1 = 100000;
R2 = 1000;

C = 1/fc/2/pi/R2;


f0 = 60;
f1 = 180;

%% Vi / (-j*1/2/pi/f/C + R2) = Vo / R1;
G0 = R1 / (-i*1/2/pi/f0/C + R2); % Vo/Vi

G1 = R1 / (-i*1/2/pi/f1/C + R2); % Vo/Vi

Gr = (-i*1/2/pi/f0/C + R2)/(-i*1/2/pi/f1/C + R2);

amp = abs(Gr**8);
theta = angle(Gr**8);

%n = log(100)/log(amp);