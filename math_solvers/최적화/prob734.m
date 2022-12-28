function prob734
ad=[45:5:135];
a=ad*pi/180;
for i=1:length(a)
    [t,Lmin(i)]=fminsearch(@(x) 2/sin(x)+2/sin(pi-a(i)-x),0.3);
end
plot(ad,Lmin)
end