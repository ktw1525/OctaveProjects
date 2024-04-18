function [P,Q,V,A,Ybus,EP,EQ]=powersys()
%Octave Start
pkg load io
%Octave End
clear all
clc
format long
%----------------초기값------------------
fprintf('<<<조류계산>>>\n');
Ofname = input('계통 어드미턴스 및 초기값 설정파일(ex:data\\Sample.xls) : ','s');

%----------설정된 초기값 읽어오기---------
init = xlsread(Ofname,1);
Vi = init(1:size(init,1),4);
Ai = init(1:size(init,1),5)*pi/180;
Pi = init(1:size(init,1),2);
Qi = init(1:size(init,1),3);
BusType = init(1:size(init,1),6)';
Ybus = Ygen(Ofname); % Ybus 생성.
SelectSolution = input('Gauss-Seidel법:1, Newton-Raphson법:2    > ','s');
if SelectSolution == '1' [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus); %Gauss-Seidel법
else [Po,Qo,Vo,Ao,EP,EQ,t]=NtRs(Vi,Ai,Pi,Qi,BusType,Ybus); %Newton-Raphson법
end
input('< Press ENTER KEY to continue >')
%-------------수렴속도 그래프-------------
Ao=(mod(Ao+pi,2*pi)-pi)*180/pi;
figure(1)
plot(t,[EP;EQ],'-o'); grid on; title('최대 상대오차율 수렴과정');
legend('P','Q'); xlabel('반복회수'); ylabel('상대오차율 최대 값(%)');
figure(2)
subplot(2,2,1); plot([0 t],Po,'-o'); grid on; title('<P값 수렴과정>');
xlabel('반복회수'); ylabel('P');
subplot(2,2,2); plot([0 t],Qo,'-o'); grid on; title('<Q값 수렴과정>');
xlabel('반복회수'); ylabel('Q');
subplot(2,2,3); plot([0 t],Vo,'-o'); grid on; title('<V값 수렴과정>');
xlabel('반복회수'); ylabel('V');
subplot(2,2,4); plot([0 t],Ao,'-o'); grid on; title('<θ값 수렴과정>');
xlabel('반복회수'); ylabel('θ');
%---------------결과 출력----------------
itN = length([0 t]);
fprintf('\n< 초기 설정 값 >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','θ')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Pi Qi Vi Ai].')
fprintf('\n< 결과 값 >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','θ')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
ResultF = fopen('data\Result.csv','w+');
fprintf(ResultF,'%s,%s,%s,%s,%s,%s\n','BusNum','Type','P','Q','V','θ');
fprintf(ResultF,'%d,%d,%f,%f,%f,%f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
fclose(ResultF);
fprintf('\n출력 저장 파일 : "data\\Result.csv"\n');
fclose('all');
if input('다시 계산?(Y) : ','s') == 'Y' powersys; end
P=Po;Q=Qo;V=Vo;A=Ao;
end
