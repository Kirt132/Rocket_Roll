%Code for Spinning Things
clear; %clear variables
clc; %clear command window
%Variables:
degrees = 3; %angle of attack of fins in degrees
machno = 0.5; %machnumber of the flow at the instant
finwidth = 6; %width of fin in in
finlength = 12; %width of fin in in
triangle = true;%specify fins as triangular (changes cp location)
% Variables for second set of fins (second stage of rocket with straight
% fins)
degrees_2 = 0;
finwidth_2 = 3;
finlength_2 = 6;
triangle_2 = true;
%degrees=input('At what angle should the fins be canted?\n');
%machno=input('What is the rocket velocity (mach number)?\n');
%finwidth=input('What width (outward) should the fins be (in)?\n');
%finlength=input('What length (along body) should the fins be (in)?\n');
%triangle=input('Rectangle configuration? [Y/N]: ');
%if triangle=='Y'
%    triangle=false;
%else
%    triangle=true;
%end

%Quasi-Variables;
airdensity = 1.2; %define air density (1.225kg/m^3)
numberofsteps = 8000; %defines timesteps (#/100 is seconds seen on graph)
rktdiam = 6; %rocket diameter (6in)
rktdiam_2 = 4; %second stage diameter (4in)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)

%Constants:
inertia = 0.317961677; %rocket inertia in kg*m^2 (0.317961677kg*m^2)
timestep = 0.01; %timestep interval (0.01s)

%Calculated Values:
finwidthm = finwidth*.0254; %convert fin width to m
finlengthm = finlength*.0254; %convert fin length to m
rktradiusm = rktdiam/2*.0254; %convert rocket diameter to its radius in m
finwidthm_2 = finwidth_2*.0254; %convert fin width to m
finlengthm_2 = finlength_2*.0254; %convert fin length to m
rktradiusm_2 = rktdiam_2/2*.0254; %convert rocket diameter to its radius in m
speed = machno*speedofsound; %converts mach number to speed in m/s

%Other Initializations:
ohmega = zeros(1,numberofsteps+1); %initializes size for matrix


if triangle==true
    cp = finwidthm*1/3; %center of pressure of triangle
    finarea=3/2*finwidthm*finlengthm;%all area for calculating moment
else
    cp = finwidthm*1/2; %center of pressure of rectangle
    finarea=3*finwidthm*finlengthm;%all area for calculating moment
end
if triangle_2==true
    cp_2 = finwidthm_2*1/3; %center of pressure of triangle
    finarea_2=3/2*finwidthm_2*finlengthm_2;%all area for calculating moment
else
    cp_2 = finwidthm_2*1/2; %center of pressure of rectangle
    finarea_2=3*finwidthm_2*finlengthm_2;%all area for calculating moment
end

momentrad = cp+rktradiusm; %calculate the radius that the moment is acting on
momentrad_2 = cp_2+rktradiusm_2;
theta = degrees*pi/180; %find initial angle in radians
theta_2 = degrees_2*pi/180;
xvel = speed*cos(theta); %define x velocity
yvel = speed*sin(theta); %define y velocity
xvel_2 = speed*cos(theta_2); %define x velocity
yvel_2 = speed*sin(theta_2); %define y velocity
%The below term is not correct anymore.
eqspinspd = abs(speedofsound*machno*sin(theta)/momentrad/2/pi) %spinspeed in Hz (converted via 2PI())
eqspinspd = abs(speedofsound*machno*sin(theta)/momentrad_2/2/pi)
eqspinspd = abs(speedofsound*machno*sin(theta)/((momentrad+momentrad_2)/2)/2/pi)


ohmega(1) = 0; %initialize the spin at 0.
for n = 1:numberofsteps
    cd = 1.28*cos(theta); %cd of the plate for damping, will change
    cd_2 = 1.28*cos(theta_2);
    cl = 2*pi*theta; %coeficient of lift for flat plate
    cl_2 = 2*pi*theta_2;
    moment = (cl*finarea*airdensity*speed^2)/2 * momentrad; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    moment_2 = (cl_2*finarea_2*airdensity*speed^2)/2 * momentrad_2; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    dampingmoment(n) = (cd*finarea*airdensity*(ohmega(n)*momentrad)^2)/2 *momentrad; %moment caused by damping of the fins - this needs to be updated to include skin friction
    dampingmoment_2(n) = (cd_2*finarea_2*airdensity*(ohmega(n)*momentrad_2)^2)/2 *momentrad_2;
    alpha = (moment+moment_2-dampingmoment(n)-dampingmoment_2(n))/inertia; %calculate angular acceleration in radians per second
    ohmega(n+1) = ohmega(n) + alpha*timestep; %find the new spin speed by integrating numerically
    yvelmod= yvel - ohmega(n+1)*momentrad; %find modified y velocity due to the spin rate
    yvelmod_2 = yvel_2 - ohmega(n+1)*momentrad_2;
    theta = atan(yvelmod/xvel); %recalculate the angle of attack based on spin speed
    theta_2 = atan(yvelmod_2/xvel_2);
end

ohmega = ohmega/2/pi; %convert radians/s to Hz
ninetynine=0.99*eqspinspd;
for n=1:numberofsteps
    if ohmega(n)<=ninetynine
        ninetynine_pnt=n;
    end
end

%ohmega(numberofsteps) check for what the last value of rotation rate is

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