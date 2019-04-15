
function [Moment] = Moment_Calculator_No_Skin_Friction(lengths, width, chordtip, rho, V, theta, ohmega, r, stepsize, finnum);
%%make a function for the roll momenet of the rocket

%%variables, comment out for actual code usage
% lengths = .1143; %chord 1
% width = .0707;
% chordtip = .040005; %chord2
% rho = 1.2;%air density
% V = 343/2;%m/s
% theta = 2*pi/180;
% ohmega = 16*2*pi; %radians per second
% r =.0472/2; %rocket radius m
% stepsize = .0001;
% finnum = 3;
%%correcting the units
V = abs(V);
if V==0
    V=0.0000000001;
end
if ohmega==0
    ohmega=0.0000000001;
end
Vy = sin(theta)*abs(V);
%theta = theta*pi/180; %converts to radians if entered in degrees
%%Magic Happens Here, Cool to compare to Cp estimates 
intwidth = r:stepsize:width+r; %width at which to intergrate the moment over
intwidth2 = intwidth+stepsize/2; %location of the center of pressure
vofr = intwidth2*ohmega; %calculate anglar velocity across the fin
calcvel = Vy - vofr; %oncoming fin velocity
thetafull = atan(calcvel./V); %angle of attack for each fin portion
lengthint = -((lengths-chordtip)/width)*(intwidth-r)+lengths; %calculate the length in 1mm imcrements
cl = 2*pi*thetafull; %find the lift coefficient
Moment = 1/2*finnum*rho*sum(cl.*V^2.*lengthint.*stepsize.*intwidth2); %find the moment based on the fins
end