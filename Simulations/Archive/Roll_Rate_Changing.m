%Code for Spinning Things
clear; %clear variables
clc; %clear command window
%Variables:
degrees = 3; %angle of attack of fins in degrees
%machno = 0.5; %machnumber of the flow at the instant
finwidth = 6; %width of fin in in
finlength = 12; %width of fin in in
triangle = true;%specify fins as triangular (changes cp location)
% Variables for second set of fins (second stage of rocket with straight
% fins)
degrees_2 = 0;
finwidth_2 = 3;
finlength_2 = 6;
triangle_2 = true;

load Test_Launch_Curve.txt

%Quasi-Variables;
airdensity = 1.2; %define air density (1.225kg/m^3)
numberofsteps = 8000; %defines timesteps (#/200 is seconds seen on graph)
rktdiam = 6; %rocket diameter (6in)
rktdiam_2 = 4; %second stage diameter (4in)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)
%speed = [0, 0.2, 0.8, 2, 6, 13, 29, 55];
speed = Test_Launch_Curve(:,3);
machno = speed./speedofsound;
%time_flight = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7];
time_flight = Test_Launch_Curve(:,1);


%Constants:
inertia = 0.317961677; %rocket inertia in kg*m^2 (0.317961677kg*m^2)
timestep = 0.005; %timestep interval (0.005s)

%Calculated Values:
finwidthm = finwidth*.0254; %convert fin width to m
finlengthm = finlength*.0254; %convert fin length to m
rktradiusm = rktdiam/2*.0254; %convert rocket diameter to its radius in m
finwidthm_2 = finwidth_2*.0254; %convert fin width to m
finlengthm_2 = finlength_2*.0254; %convert fin length to m
rktradiusm_2 = rktdiam_2/2*.0254; %convert rocket diameter to its radius in m

%Other Initializations:
ohmega = zeros(1,ceil(max(time_flight)/timestep)); %initializes size for matrix


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

m=0;
q=0;
eqspinspd = zeros(1,ceil(max(time_flight)/timestep));
for i=1:length(speed)
    while time_flight(i)>timestep*m
        m = m+1;
        xvel = speed(i)*cos(theta); %define x velocity
        yvel = speed(i)*sin(theta); %define y velocity
        %The below term is not correct anymore.
        eqspinspd(m+1) = abs(speedofsound*machno(i)*sin(theta)/momentrad/2/pi); %spinspeed in Hz (converted via 2PI())
        cd = 1.28*cos(theta); %cd of the plate for damping, will change
        cl = 2*pi*theta; %coeficient of lift for flat plate
        moment = (cl*finarea*airdensity*speed(i)^2)/2 * momentrad; %moment about the longitudinal axis of the rocket caused by the lift of the fins
        dampingmoment = (cd*finarea*airdensity*(ohmega(m)*momentrad)^2)/2 *momentrad; %moment caused by damping of the fins - this needs to be updated to include skin friction
        alpha = (moment-dampingmoment)/inertia; %calculate angular acceleration in radians per second
        %alpha = (moment(i)+moment_2(i)-dampingmoment-dampingmoment_2)/inertia; %calculate angular acceleration in radians per second
        ohmega(m+1) = ohmega(m) + alpha*timestep; %find the new spin speed by integrating numerically
        yvelmod= yvel - ohmega(m+1)*momentrad; %find modified y velocity due to the spin rate
        theta = atan(yvelmod/xvel); %recalculate the angle of attack based on spin speed
    end
    q=time_flight(i);
end

ohmega = ohmega/2/pi; %convert radians/s to Hz
% ninetynine=0.99*eqspinspd;
% for n=1:m
%     if ohmega(n)<=ninetynine
%         ninetynine_pnt=n;
%     end
% end

%ohmega(numberofsteps) check for what the last value of rotation rate is

fig=figure;
hax=axes;
time = 0:timestep:m*timestep; % provide an X axis for the graph
hold on
plot(time, ohmega)%provide a Y axis for the graph
plot(time, eqspinspd)
%SP=ninetynine_pnt/100; %point at which equilibrium spin is at 99%
%line([SP SP],get(hax,'YLim'),'Color',[1 0 0])
legend('Spin Rate')
xlabel('Time (s)')
ylabel('Rotation Rate (Hz)')
title('Rotation Rate Over Time')