%[Moment] = Moment_Calculator(length, width, chordtip, rho, V, theta, ohmega, r, stepsize, finnum);
%%make a function for the roll momenet of the rocket
%variables, comment out for actual code usage
length = 6*0.0254; %chord 1
width = 4*.0254;
chordtip = 6 *.0254; %chord2
rho = 1.2;%air density
V = 343/2;%m/s
theta = 2*pi/180;
Vy = sin(theta)*V;
ohmega = 11*2*pi; %radians per second
r =.0254; %rocket radius m
stepsize = .001;
finnum = 3;

%%Magic Happens Here, Cool to compare to Cp estimates 
intwidth = r:stepsize:width+r; %width at which to intergrate the moment over
vofr = intwidth*ohmega; %calculate anglar velocity across the fin
calcvel = Vy - vofr; %oncoming fin velocity
thetafull = atan(calcvel./V); %angle of attack for each fin portion
lengthint = -((length-chordtip)/width)*(intwidth-r)+length; %calculate the length in 1mm imcrements
cl = 2*pi*thetafull; %find the lift coefficient
M = 1/2*finnum*rho*sum(cl.*V^2.*lengthint.*stepsize.*intwidth) %find the moment based on the fins

