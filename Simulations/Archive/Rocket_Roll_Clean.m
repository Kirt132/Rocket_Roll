%Code for Spinning Things
%clear; %clear variables
clc; %clear command window

load DeSpin_Rocket.txt %load text file with de-spin slight sim data
%test_launch: time(s), height(ft), velocity(m/s)
load Atmosphere.txt %load atmospheric values comapared to sea level (average)
%atmosphere: height(m), temperature(*C), gravity(m/s^2),
%pressure(abs)(10^4N/m^2), density(kg/m^2), dynamic viscosity(10^-5N*s/m^2)

% d = dir;
% fn = {d.name};
% [indx,tf] = listdlg('PromptString','Select a file:','SelectionMode','single','ListString',fn);

rocket_flight=DeSpin_Rocket; %change evaluted simulated flight
%column 1 is time
%column 2 is height
%column 3 is velocity
%any other columns are unused by this program

%Variables:
degrees = 5; %angle of attack of fins in degrees
finheight = 5; %width of fin in in
finlength = 4; %length of fin in in
finbase = 10; %base of fin (in)
numfins = 3; %number of fins

%Constants:
inertia = 0.018; %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
timestep = 0.01; %timestep interval (0.01s)
height_atm = Atmosphere(:,1); %height from atmosphere values
density = Atmosphere(:,5); %define air density (1.225kg/m^3)

%Quasi-Variables;
[b,c] = max(rocket_flight(:,2)); %b=max height; c=index of max height
time_peak = floor(rocket_flight(c,1)); %time at which rocket reaches apogee (end of sim)
numberofsteps = time_peak/timestep; %defines number of time stamps
height_rocket = rocket_flight(:,2); %height of rocket (m)
rktdiam = 4.016; %rocket diameter inches (6in)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)

%Calculated Values:
finheightm = finheight*.0254; %convert fin width to m
finlengthm = finlength*.0254; %convert fin length to m
finbasem = finbase*.0254; %convert fin base to m
rktradiusm = rktdiam/2*.0254; %convert rocket diameter to its radius in m
speed = rocket_flight(:,3); %converts mach number to speed in m/s

%Other Initializations:
ohmega = zeros(1,numberofsteps+1); %initializes size for matrix
avg_ohmega = zeros(1,numberofsteps+1); %initializes size for matrix
moment = zeros(1,numberofsteps+1); %initializes size for matrix
alpha = zeros(1,numberofsteps+1); %initializes size for matrix
yvelmod = zeros(1,numberofsteps+1); %initializes size for matrix

cp=0.0544297;
finarea=0.0677418;
rktradiusm=0.102;
%values for de-spin rocket

momentrad = cp+rktradiusm; %calculate the radius that the moment is acting on
theta = degrees*pi/180; %find initial angle in radians
xvel = speed*cos(theta); %define x velocity
yvel = speed*sin(theta); %define y velocity
%The below term is not correct anymore???
%eqspinspd = abs(speedofsound*machno*sin(theta)/((momentrad+momentrad_2)/2)/2/pi); %spinspeed in Hz (converted via 2PI())
%eqspinspd = (xvel/momentrad)*tan(theta);


for n = 1:numberofsteps
    i = 1;
    [a,b] = min(abs((n*timestep)-rocket_flight(:,1))); %dummy; index of time closest to current iteration
    %height_atm(i) %sanity check
    %height_rocket(b) %sanity check
    while height_atm(i)<=height_rocket(b) %estimates current altitude's air density
        %height_atm(i) %sanity check
        %height_rocket(b) %sanity check
        airdensity = density(i)+((density(i+1)-density(i))/(height_atm(i+1)-height_rocket(i)))*(height_rocket(b)-height_atm(i));
        i = i+1;
    end
    cl = 2*pi*theta; %coeficient of lift for flat plate
    moment(n) = (cl*finarea*airdensity*speed(b)^2)/2 * momentrad; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    alpha(n) = moment(n)/inertia; %calculate angular acceleration in radians per second
    ohmega(n+1) = ohmega(n) + alpha(n) * timestep; %find the new spin speed by integrating numerically
    yvelmod(n) = yvel(b) - ohmega(n+1)*momentrad; %find modified y velocity due to the spin rate
    theta = atan(yvelmod(n)/xvel(b)); %recalculate the angle of attack based on spin speed
    if xvel(b)==0
        theta=0;
    end
end


%ohmega(numberofsteps) check for what the last value of rotation rate is


time = 0:timestep:numberofsteps*timestep; % provide an X axis for the graph
hold on
plot(time,ohmega) %provides roll rate for first set of fins
xlabel('Time (s)')
ylabel('Rotation Rate (rad/s)')
title('Rotation Rate Over Time')

ohmega(length(ohmega))/(2*pi)

