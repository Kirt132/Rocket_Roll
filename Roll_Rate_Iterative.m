%Code for Spinning Things
clear; %clear variables
clc; %clear command window

% %Variables:
% degrees = 1; %angle of attack of fins in degrees
% machno = 0.5; %machnumber of the flow at the instant
% finwidth = 6; %width of fin in in
% finlength = 12; %width of fin in in
% triangle = true; %specify fins as triangular (changes cp location)
degrees=input('At what angle should the fins be canted?\n');
machno=input('What is the rocket velocity (mach number)?\n');
finwidth=input('What width (outward) should the fins be (in)?\n');
finlength=input('What length (along body) should the fins be (in)?\n');
triangle=input('Rectangle configuration? [''Y''/''N'']: ');
if triangle=='Y'
    triangle=false;
else
    triangle=true;
end

%Quasi-Variables;
airdensity = 1.2; %define air density (1.225kg/m^3)
numberofsteps = 800; %defines timesteps (#/100 is seconds seen on graph)
rktdiam = 4; %rocket diameter (4in)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)

%Constants:
inertia = 0.317961677; %rocket inertia in kg*m^2 (0.317961677kg*m^2)
timestep = 0.01; %timestep interval (0.01s)

%Calculated Values:
finwidthm = finwidth*.0254; %convert fin width to m
finlengthm = finlength*.0254; %convert fin length to m
rktradiusm = rktdiam/2*.0254; %convert rocket diameter to its radius in m
speed = machno*speedofsound; %converts mach number to speed in m/s

%Other Initializations:
ohmega = zeros(1,numberofsteps+1); %initializes size for matrix


if triangle==true
    cp = finwidthm*1/3; %center of pressure of triangle
else
    cp = finwidthm*1/2; %center of pressure of rectangle
end
momentrad = cp+rktradiusm; %calculate the radius that the moment is acting on
theta = degrees*pi/180; %find initial angle in radians
xvel = speed*cos(theta); %define x velocity
yvel = speed*sin(theta); %define y velocity
eqspinspd = abs(speedofsound*machno*sin(theta)/momentrad/2/pi) %spinspeed in Hz (converted via 2PI()
finarea=3*finwidthm*finlengthm; %all area for calculating moment
ohmega(1) = 0; %initialize the spin at 0.
for n = 1:numberofsteps
    cd = 1.28*cos(theta); %cd of the plate for damping, will change
    cl = 2*pi*theta; %coeficient of lift for flat plate
    moment = (cl*finarea*airdensity*speed^2)/2 * momentrad; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    dampingmoment = (cd*finarea*airdensity*(ohmega(n)*momentrad)^2)/2 *momentrad; %moment caused by damping of the fins - this needs to be updated to include skin friction
    alpha = (moment-dampingmoment)/inertia; %calculate angular acceleration in radians per second
    ohmega(n+1) = ohmega(n) + alpha*timestep; %find the new spin speed by integrating numerically
    yvelmod= yvel - ohmega(n+1)*momentrad; %find modified y velocity due to the spin rate
    theta = atan(yvelmod/xvel); %recalculate the angle of attack based on spin speed
end

ohmega = ohmega/2/pi; %convert radians/s to Hz
ninetynine=0.99*eqspinspd;
for n=1:numberofsteps
    if ohmega(n)<=ninetynine
        ninetynine_pnt=n;
    end
end

fig=figure;
hax=axes;
time = 0:timestep:numberofsteps*timestep; % provide an X axis for the graph
hold on
plot(time, ohmega)%provide a Y axis for the graph
SP=ninetynine_pnt/100; %point at which equilibrium spin is at 99%
line([SP SP],get(hax,'YLim'),'Color',[1 0 0])
legend('Spin Rate')
xlabel('Time (s)')
ylabel('Rotation Rate (Hz)')
title('Rotation Rate Over Time')
