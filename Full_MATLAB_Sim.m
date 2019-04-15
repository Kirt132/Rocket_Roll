%Code for Spinning Things
clear; %clear variables
clc; %clear command window

load arreaux_loaded.txt %load in text file with flight data
%test_launch: time(s), height(ft), velocity(m/s)
load Atmosphere.txt %load atmospheric values comapared to sea level (average)
%atmosphere: height(m), temperature(*C), gravity(m/s^2),
%pressure(abs)(10^4N/m^2), density(kg/m^2), dynamic viscosity(10^-5N*s/m^2)

%Variables:
degrees = 1; %angle of attack of fins in degrees
%machno = 0.5; %machnumber of the flow at the instant
finwidth = 2; %width of fin in in
finlength = 3.75; %length of fin in in
numfins = 3; %number of fins
triangle = true; %specify fins as triangular (changes cp location)
% Variables for second set of fins (second stage of rocket with straight fins)
degrees_2 = 0;
finwidth_2 = 3;
finlength_2 = 6;
numfins_2 = 3;
triangle_2 = true;

%Constants:
inertia = 0.317961677; %rocket inertia in kg*m^2 (0.317961677kg*m^2)
timestep = 0.01; %timestep interval (0.01s)
height_atm = Atmosphere(:,1); %height from atmosphere values
density = Atmosphere(:,5); %define air density (1.225kg/m^3)

%Quasi-Variables;
[b,c] = max(Test_Launch_Curve(:,2)); %b=max height; c=index of max height
time_peak = floor(Test_Launch_Curve(c,1)); %time at which rocket reaches apogee (end of sim)
numberofsteps = time_peak/timestep; %defines number of time stamps
height_rocket = Test_Launch_Curve(:,2)/3.281; %height of rocket (m)
rktdiam = 2.25; %rocket diameter (6in)
rktdiam_2 = 4; %second stage diameter (4in)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)

%Calculated Values:
finwidthm = finwidth*.0254; %convert fin width to m
finlengthm = finlength*.0254; %convert fin length to m
rktradiusm = rktdiam/2*.0254; %convert rocket diameter to its radius in m
finwidthm_2 = finwidth_2*.0254; %convert fin width to m
finlengthm_2 = finlength_2*.0254; %convert fin length to m
rktradiusm_2 = rktdiam_2/2*.0254; %convert rocket diameter to its radius in m
speed = Test_Launch_Curve(:,3); %converts mach number to speed in m/s
machno = speed/speedofsound;

%Other Initializations:
ohmega = zeros(1,numberofsteps+1); %initializes size for matrix
moment = zeros(1,numberofsteps+1); %initializes size for matrix
dampingmoment = zeros(1,numberofsteps+1); %initializes size for matrix
alpha = zeros(1,numberofsteps+1); %initializes size for matrix
yvelmod = zeros(1,numberofsteps+1); %initializes size for matrix

if triangle==true
    cp = finwidthm*1/3; %center of pressure of triangle
    finarea=numfins/2*finwidthm*finlengthm;%all area for calculating moment
else
    cp = finwidthm*1/2; %center of pressure of rectangle
    finarea=numfins*finwidthm*finlengthm;%all area for calculating moment
end
if triangle_2==true
    cp_2 = finwidthm_2*1/3; %center of pressure of triangle
    finarea_2=numfins_2/2*finwidthm_2*finlengthm_2;%all area for calculating moment
else
    cp_2 = finwidthm_2*1/2; %center of pressure of rectangle
    finarea_2=numfins_2*finwidthm_2*finlengthm_2;%all area for calculating moment
end

momentrad = cp+rktradiusm; %calculate the radius that the moment is acting on
momentrad_2 = cp_2+rktradiusm_2;
theta = degrees*pi/180; %find initial angle in radians
theta_2 = degrees_2*pi/180;
xvel = speed*cos(theta); %define x velocity
yvel = speed*sin(theta); %define y velocity
xvel_2 = speed*cos(theta_2); %define x velocity
yvel_2 = speed*sin(theta_2); %define y velocity
%The below term is not correct anymore???
%eqspinspd = abs(speedofsound*machno*sin(theta)/((momentrad+momentrad_2)/2)/2/pi); %spinspeed in Hz (converted via 2PI())
%eqspinspd = (xvel/momentrad)*tan(theta);


for n = 1:numberofsteps
    i = 1;
    [a,b] = min(abs((n*timestep)-Test_Launch_Curve(:,1))); %dummy; index of time closest to current iteration
    %height_atm(i) %sanity check
    %height_rocket(b) %sanity check
    while height_atm(i)<height_rocket(b) %estimates current altitude's air density
        %height_atm(i) %sanity check
        %height_rocket(b) %sanity check
        airdensity = density(i)+((density(i+1)-density(i))/(height_atm(i+1)-height_rocket(i)))*(height_rocket(b)-height_atm(i));
        i = i+1;
    end
    cl = 2*pi*theta; %coeficient of lift for flat plate
    %cl_2 = 2*pi*theta_2;
    moment(n) = (cl*finarea*airdensity*speed(b)^2)/2 * momentrad; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    %moment_2 = (cl_2*finarea_2*airdensity*speed(b)^2)/2 * momentrad_2; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    %alpha = (moment+moment_2)/inertia; %calculate angular acceleration in radians per second
    alpha(n) = moment(n)/inertia; %calculate angular acceleration in radians per second
    ohmega(n+1) = ohmega(n) + alpha(n) * timestep; %find the new spin speed by integrating numerically
    yvelmod(n) = yvel(b) - ohmega(n+1)*momentrad; %find modified y velocity due to the spin rate
    %yvelmod_2 = yvel_2 - ohmega(n+1)*momentrad_2;
    theta = atan(yvelmod(n)/xvel(b)); %recalculate the angle of attack based on spin speed
    %theta_2 = atan(yvelmod_2/xvel_2);
end


%ohmega(numberofsteps) check for what the last value of rotation rate is


time = 0:timestep:numberofsteps*timestep; % provide an X axis for the graph
hold on
plot(time,ohmega) %provide a Y axis for the graph
%plot(time,moment)
[o,p]=size(time);
%plot(time,zeros(1,p))
%plot(time,alpha)
%plot(time,yvelmod)
%plot(Test_Launch_Curve(:,1),eqspinspd)
legend('Spin Rate','Moment','Zero','Alpha','YVelMod','~Equilibrium Spin Rate')
xlabel('Time (s)')
ylabel('Rotation Rate (Hz)')
title('Rotation Rate Over Time')
