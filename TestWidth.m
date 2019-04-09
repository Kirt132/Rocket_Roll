%%make a function for the roll momenet of the rocket
%variables
length = 6*0.0254; %chord 1
width = 4*.0254;
chordtip = 1 *.0254; %chord2
rho = 1.2;%air density
V = 343/2;%m/s
theta = 2*pi/180;
ohmega = 5*2*pi; %radians per second
r =.0254 %rocket radius m
intwidth = r:.001:width+r;
vofr = intwidth*ohmega
lengthint = -((length-chordtip)/width)*(intwidth-r)+length
plot(lengthint)
cl = 2*pi*theta
M = 3*cl*rho*sum(vofr.^2.*lengthint.*intwidth)

