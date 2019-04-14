function [Moment] = Moment_Calculator_2(length_value, width, chordtip, rho, V, theta, ohmega, r, stepsize, finnum);
%%make a function for the roll momenet of the rocket
%variables, comment out for actual code usage
%(length = 6*0.0254; %chord 1
%width = 4*.0254;
%chordtip = 6 *.0254; %chord2
%rho = 1.2;%air density
%V = 343/2;%m/s
%theta = 2*pi/180;
Vy = sin(theta)*V;
%ohmega = 10.9*2*pi; %radians per second
%r =.0254; %rocket radius m
%stepsize = .0001;
finnum = 3;
theta = theta*pi/180; %converts to radians
%%Magic Happens Here, Cool to compare to Cp estimates 
intwidth = r:stepsize:width+r; %width at which to intergrate the moment over
intwidth2 = intwidth+stepsize/2; %location of the center of pressure
vofr = intwidth2*ohmega; %calculate anglar velocity across the fin
calcvel = Vy - vofr; %oncoming fin velocity
if V==0
    V=0.000001;
end
thetafull = atan(calcvel./V); %angle of attack for each fin portion
lengthint = -((length_value-chordtip)/width)*(intwidth-r)+length_value; %calculate the length in 1mm imcrements
cl = 2*pi*thetafull; %find the lift coefficient
M = 1/2*finnum*rho*sum(cl.*V^2.*lengthint.*stepsize.*intwidth2); %find the moment based on the fins

%% Skin Friction Moment
l = 1;%length of the rocket in m  
mu = 18e-6; %viscosity of air
Re = rho*r*ohmega*r/mu;
if Re==0
    Re=0.000001;
end
Cf = 0.027/(Re^(1/7)); %skin friction coefficient
Fd = Cf*rho*r^3*ohmega^2*l*pi;
DampingMoment = Fd*r;

%%Subtract skin friction from the initial moment
Moment = M-DampingMoment;

end