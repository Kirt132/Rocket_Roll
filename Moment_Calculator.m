[Moment] = Moment_Calculator(length, width, chordtip, rho, V, theta, ohmega, r, stepsize, finnum);
%%make a function for the roll momenet of the rocket
%variables
length = 6*0.0254; %chord 1
width = 4*.0254;
chordtip = 1 *.0254; %chord2
rho = 1.2;%air density
V = 343/2;%m/s
theta = 2*pi/180;
ohmega = 5*2*pi; %radians per second
r =.0254; %rocket radius m
stepsize = .001;
finnum = 3;

%%Magic Happens Here
intwidth = r:stepsize:width+r; %width at which to intergrate the moment over
vofr = intwidth*ohmega; %calculate anglar velocity across the fin
lengthint = -((length-chordtip)/width)*(intwidth-r)+length; %calculate the length in 1mm imcrements
cl = 2*pi*theta; %find the lift coefficient
M = finnumber*cl*rho*sum(vofr.^2.*lengthint.*intwidth); %find the moment based on the fins

