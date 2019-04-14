%Code for Spinning Things
%clear; %clear variables
clc; %clear command window


% Second rocket flights data: Base=11.43cm Height=7.08cm Length=4cm Moment
% of Inertia=0.00041764kg*m^2 Diameter=4.72cm Mass=0.71kg



%% Initialization
cd D:\MATLAB\Rockets\Launch_Profiles\Simulated_Launches %selects this file as current directory
directory = dir; %sets current directory as variable
file_list = {directory.name}; %accesses all file names and saves them as a list
file_index = listdlg('PromptString','Select simulation file:','SelectionMode','single','ListSize',[250,300],'InitialValue',3,'ListString',file_list);
%creates file list GUI and saves selection #
file = file_list{file_index}; %grabs file name from list
rocket_flight = load(file); %loads file under 'rocket_flight'
%data must be: time(s), height(m), velocity(m/s)
%any other columns are unused by this program

load D:\MATLAB\Rockets\Other_Text_Files\Atmosphere.txt %load atmospheric values comapared to sea level (average)
%atmosphere: height(m), temperature(*C), gravity(m/s^2),
%pressure(abs)(10^4N/m^2), density(kg/m^2), dynamic viscosity(10^-5N*s/m^2)

%%%%% Metric or US Standard %%%%%
measurement_list = {'Metric','US Standard'};
measurement_index = listdlg('PromptString','Select Measurement Type:','SelectionMode','single','ListSize',[200,100],'ListString',measurement_list);
if exist('measurement_index_old','var')==0
    measurement_index_old = 0;
end

%%%%% Fin shape selection %%%%%
fin_shape_list = {'Triangular','Rectangular','Trapezoidal'};
shape_index = listdlg('PromptString','Select Fin Shape:','SelectionMode','single','ListSize',[200,100],'ListString',fin_shape_list);

%% Change Variable Class
%%%%% Checks for saved values and converts to character array %%%%%
if exist('degrees','var')==0
    degrees='';
end
if exist('number_of_fins','var')==0
    number_of_fins='';
end
if exist('inertia','var')==0
    inertia='';
elseif measurement_index_old==1 && measurement_index==2 %if old metric and new US
    inertia=inertia*23.73036;
elseif measurement_index_old==2 && measurement_index==1 %if old US and new metric
    inertia=inertia/23.73036;
elseif measurement_index_old==measurement_index %if old and new are the same
    %Nothing
end
if exist('rocket_radius_m','var')==0
    rocket_radius_m='';
elseif measurement_index_old==1 && measurement_index==2 %if old metric and new US
    rocket_radius_m=2*rocket_radius_m*39.3701;
elseif measurement_index_old==2 && measurement_index==1 %if old US and new metric
    rocket_radius_m=2*rocket_radius_m/39.3701;
elseif measurement_index_old==1 && measurement_index==1 %if old metric and new metric
    rocket_radius_m=2*rocket_radius_m*100;
end
if exist('finbasem','var')==0
    finbasem='';
elseif measurement_index_old==1 && measurement_index==2 %if old metric and new US
    finbasem=finbasem*39.3701;
elseif measurement_index_old==2 && measurement_index==1 %if old US and new metric
    finbasem=finbasem/39.3701;
elseif measurement_index_old==1 && measurement_index==1 %if old metric and new metric
    finbasem=finbasem*100;
end
if exist('finheightm','var')==0
    finheightm='';
elseif measurement_index_old==1 && measurement_index==2 %if old metric and new US
    finheightm=finheightm*39.3701;
elseif measurement_index_old==2 && measurement_index==1 %if old US and new metric
    finheightm=finheightm/39.3701;
elseif measurement_index_old==1 && measurement_index==1 %if old metric and new metric
    finheightm=finheightm*100;
end
if exist('finlengthm','var')==0
    finlengthm=0;
elseif measurement_index_old==1 && measurement_index==2 %if old metric and new US
    finlengthm=finlengthm*39.3701;
elseif measurement_index_old==2 && measurement_index==1 %if old US and new metric
    finlengthm=finlengthm/39.3701;
elseif measurement_index_old==1 && measurement_index==1 %if old metric and new metric
    if ischar(finlengthm)==1
        finlengthm=str2double(finlengthm);
    end
    finlengthm=finlengthm*100;
end
if ischar(finlengthm)~=1
    finlengthm=num2str(finlengthm);
end
dummy={degrees,number_of_fins,inertia,rocket_radius_m,finbasem,finheightm,finlengthm};
finlengthm=str2double(finlengthm);
dummy=string(dummy);
dummy=cellstr(dummy);

%% User Input
measurement_index_old=measurement_index; %used for repeat of program
if measurement_index == 1 %for metric measurments
    if shape_index == 1 %triangle shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (kg*m^2)','Rocket Diameter (cm)','Base of Fin on Rocket Body (cm)','Height of Fin from Rocket Body (cm)'},'Rocket and Fin Parameters',[1 58],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3)); %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*str2double(matrix(4))/100; %rocket radius (m)
        finbasem = str2double(matrix(5))/100;
        finheightm = str2double(matrix(6))/100;
        finlengthm = finlengthm/100;
        cp = finheightm/3; %center of pressure from base
        finarea = 0.5*finbasem*finheightm*number_of_fins; %area of one side of one fin
    elseif shape_index == 2 %rectangle shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (kg*m^2)','Rocket Diameter (cm)','Base of Fin on Rocket Body (cm)','Height of Fin from Rocket Body (cm)'},'Rocket and Fin Parameters',[1 58],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3)); %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*str2double(matrix(4))/100; %rocket radius (m)
        finbasem = str2double(matrix(5))/100;
        finheightm = str2double(matrix(6))/100;
        finlengthm = finlengthm/100;
        cp = finheightm/2; %center of pressure from base
        finarea = finbasem*finheightm*number_of_fins; %area of one side of one fin
    elseif shape_index == 3 %trapezoid shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (kg*m^2)','Rocket Diameter (cm)','Base of Fin on Rocket Body (cm)','Height of Fin from Rocket Body (cm)','Length of Fin Opposite of Rocket Body (cm)'},'Fin and Rocket Parameters',[1 58],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3)); %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*str2double(matrix(4))/100; %rocket radius (m)
        finbasem = str2double(matrix(5))/100;
        finheightm = str2double(matrix(6))/100;
        finlengthm = str2double(matrix(7))/100;
        cp = (finheightm*(finbasem-2*finlengthm))/(3*(finbasem+finlengthm)); %center of pressure from base
        finarea = 0.5*finheightm*(finbasem+finlengthm)*number_of_fins; %area of one side of one fin
    else
        fprintf('ERROR!\nPlease de-bug!\n') %sanity check error message
    end
elseif measurement_index == 2 %for us standard measurments
    if shape_index == 1 %triangle shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (lbf*ft*s^2)','Rocket Diameter (in)','Base of Fin on Rocket Body','Height of Fin from Rocket Body'},'Rocket and Fin Parameters',[1 52],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3))*1.3558; %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*(str2double(matrix(4))*0.0254); %rocket radius (m)
        finbasem = str2double(matrix(5))*0.0254;
        finheightm = str2double(matrix(6))*0.0254;
        finlengthm = finlengthm/100;
        cp = finheightm/3; %center of pressure from base
        finarea = 0.5*finbasem*finheightm*number_of_fins; %area of one side of one fin
    elseif shape_index == 2 %rectangle shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (lbf*ft*s^2)','Rocket Diameter (in)','Base of Fin on Rocket Body (in)','Height of Fin from Rocket Body (in)'},'Rocket and Fin Parameters',[1 52],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3))*1.3558; %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*(str2double(matrix(4))*0.0254); %rocket radius (m)
        finbasem = str2double(matrix(5))*0.0254;
        finheightm = str2double(matrix(6))*0.0254;
        finlengthm = finlengthm/100;
        cp = finheightm/2; %center of pressure from base
        finarea = finbasem*finheightm*number_of_fins; %area of one side of one fin
    elseif shape_index == 3 %trapezoid shape
        matrix = inputdlg({'Cant Angle (degrees)','Number of Fins','Rocket Moment of Inertia (lbf*ft*s^2)','Rocket Diameter (in)','Base of Fin on Rocket Body (in)','Height of Fin from Rocket Body (in)','Length of Fin Opposite of Rocket Body (in)'},'Rocket and Fin Parameters',[1 52],dummy);
        degrees = str2double(matrix(1)); %angle of attack of fins in degrees
        number_of_fins = str2double(matrix(2)); %number of fins
        inertia = str2double(matrix(3))*1.3558; %rocket inertia in kg*m^2 (0.317961677kg*m^2 full scale)(0.018 for de-spin rocket)
        rocket_radius_m = 0.5*(str2double(matrix(4))*0.0254); %rocket radius (m)
        finbasem = str2double(matrix(5))*0.0254;
        finheightm = str2double(matrix(6))*0.0254;
        finlengthm = str2double(matrix(7))*0.0254;
        cp = (finheightm*(finbasem-2*finlengthm))/(3*(finbasem+finlengthm)); %center of pressure from base
        finarea = 0.5*finheightm*(finbasem+finlengthm)*number_of_fins; %area of one side of one fin
    else
        fprintf('ERROR!\nPlease de-bug!\n') %sanity check error message
    end
else
    fprintf('ERROR!\nPlease de-bug!\n')
end

%% WIP





%%%%% Add transonic and supersonic part of program & have it differentiate
%%%%% between the different velocities %%%%%







%% Other Constants/ Variables
%Constants:
timestep = 0.01; %timestep interval (0.01s)
height_atm = Atmosphere(:,1); %height from atmosphere values
density = Atmosphere(:,5); %define air density (1.225kg/m^3)
R=287.05; %Universal Gas Constant (J/kg*K)
thermal_cte=3055.556; %Thermal Constant (K) [5500*R]
g=9.81; %Earth's gravitational acceleration
e=2.71828; %mathematical constant e

%Quasi-Variables;
[b,c] = max(rocket_flight(:,2)); %b=max height; c=index of max height
time_peak = floor(rocket_flight(c,1)); %time at which rocket reaches apogee (end of sim)
numberofsteps = time_peak/timestep; %defines number of time stamps
height_rocket = rocket_flight(:,2); %height of rocket (m)
speedofsound = 343; %speed of sound at 20C dry air (343m/s)

%Calculated Values:
speed = rocket_flight(:,3); %converts mach number to speed in m/s

%Other Initializations:
ohmega = zeros(1,numberofsteps+1); %initializes size for matrix
avg_ohmega = zeros(1,numberofsteps+1); %initializes size for matrix
moment = zeros(1,numberofsteps+1); %initializes size for matrix
alpha = zeros(1,numberofsteps+1); %initializes size for matrix
yvelmod = zeros(1,numberofsteps+1); %initializes size for matrix
ohmega2 = zeros(1,numberofsteps+1); %initializes size for matrix
moment2 = zeros(1,numberofsteps+1); %initializes size for matrix
alpha2 = zeros(1,numberofsteps+1); %initializes size for matrix

moment_radius = cp+rocket_radius_m; %calculate the radius that the moment is acting on
theta = degrees*pi/180; %find initial angle in radians
xvel = speed*cos(theta); %define x velocity
yvel = speed*sin(theta); %define y velocity
%The below term is not correct anymore???
%eqspinspd = abs(speedofsound*machno*sin(theta)/((momentrad+momentrad_2)/2)/2/pi); %spinspeed in Hz (converted via 2PI())
%eqspinspd = (xvel/momentrad)*tan(theta);


%% Solver
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
    moment(n) = (cl*finarea*airdensity*speed(b)^2)/2 * moment_radius; %moment about the longitudinal axis of the rocket caused by the lift of the fins
    alpha(n) = moment(n)/inertia; %calculate angular acceleration in radians per second
    ohmega(n+1) = ohmega(n) + alpha(n) * timestep; %find the new spin speed by integrating numerically
    yvelmod(n) = yvel(b) - ohmega(n+1)*moment_radius; %find modified y velocity due to the spin rate
    theta = atan(yvelmod(n)/xvel(b)); %recalculate the angle of attack based on spin speed
    if xvel(b)==0
        theta=0;
    end
    moment2(n) = Moment_Calculator(finbasem, finheightm, finlengthm, airdensity, speed(b), degrees, ohmega2(n), rocket_radius_m, 0.0001, number_of_fins);%moment about the longitudinal axis of the rocket caused by the lift of the fins
    alpha2(n) = moment2(n)/inertia;
    ohmega2(n+1) = ohmega2(n)+ alpha2(n)*timestep;
end


%ohmega(numberofsteps) check for what the last value of rotation rate is


%% Output Plots
time = 0:timestep:numberofsteps*timestep; % provide an X axis for the graph
% hold on
% plot(time,ohmega/(2*pi)) %provides roll rate for first set of fins
% xlabel('Time (s)')
% ylabel('Rotation Rate (Hz)')
% title('Rotation Rate Over Time')

f=figure('Visible','off','ToolBar','none','MenuBar','none');
tgroup=uitabgroup('Parent',f,'Units','Normalized','Position',[0 0 1 1]);
tab1=uitab('Parent',tgroup,'Title','Rotation Rate');
tab2=uitab('Parent',tgroup,'Title','Comparative Roll Rate');
tab3=uitab('Parent',tgroup,'Title','');
tab4=uitab('Parent',tgroup,'Title','');
tab5=uitab('Parent',tgroup,'Title','Rocket Flight');

ax1_1=axes('Parent',tab1,'Units','Normalized','Position',[0.05 0.15 0.7 0.80]);
ax1_2=axes('Parent',tab2,'Units','Normalized','Position',[0.05 0.15 0.7 0.8]);
ax1_3=axes('Parent',tab3,'Units','Normalized','Position',[0.05 0.15 0.7 0.8]);
ax1_4=axes('Parent',tab4,'Units','Normalized','Position',[0.05 0.15 0.7 0.8]);
ax1_5=axes('Parent',tab5,'Units','Normalized','Position',[0.05 0.15 0.7 0.8]);
ax1_10=axes('Parent',tab1, 'Position',[0.01 0.25 0.2 0.1]);
% plot(ax1_10,0,0,'r-',0,0,'g-',0,0,'k-',0,0,'b-')
% legend(ax1_5,'Rocket Height (m)','Rocket Velocity (m/s)');
axis off

plot(ax1_1,time,ohmega/(2*pi),'b','LineWidth',2)
xlim(ax1_1,[0, time(length(time))*1.1]);
ylim(ax1_1,[0, (max(ohmega)/(2*pi))*1.1]);
legend(ax1_1,'Simulated Roll Rate');

load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_5_Roll_Rate.txt
clean_plot_max=Launch_5_Roll_Rate; %load file for measured gyro data for Launch_2_5
load D:\MATLAB\Rockets\Launch_Profiles\Simulated_Launches\Test_Launch_Curve_2.txt %file for OpenRockets simulated roll rate

plot(ax1_2,time,ohmega/(2*pi),'b',clean_plot_max(:,1)-0.48,clean_plot_max(:,2),'r',Test_Launch_Curve_2(:,1),Test_Launch_Curve_2(:,5)/360,time,ohmega2*2*pi/360,'m','LineWidth',2)
xlim(ax1_2,[0, time(length(time))*1.1]);
ylim(ax1_2,[0, (max(ohmega)/(2*pi))*1.1]);
legend(ax1_2,'Simulated Roll Rate','Experimental Roll Rate','OpenRocket Simulated Roll Rate','Skin Friction Inclusion');

% plot(ax1_3,time,time,'b')
% xlim(ax1_3,[0, time(length(time))*1.1]);
% ylim(ax1_3,[min(accelt)-10,max(accelt)+10]);
% 
% plot(ax1_4,time,time,'b')
% xlim(ax1_4,[0, time(length(time))*1.1]);
% ylim(ax1_4,[min(thetat)-0.1,max(thetat)+0.1]);

plot(ax1_5,rocket_flight(:,1),rocket_flight(:,2),'b',rocket_flight(:,1),rocket_flight(:,3),'k','LineWidth',2)
xlim(ax1_5,[0, rocket_flight(length(rocket_flight))*1.1]);
ylim(ax1_5,[min(rocket_flight(:,3))*1.1,max(rocket_flight(:,2))*1.1]);
legend(ax1_5,'Rocket Height (m)','Rocket Velocity (m/s)');

title(ax1_1,['Rotation Rate ',num2str(degrees),' Degree Cant']);
title(ax1_2,'Comparative Rotation Rate');
title(ax1_3,'');
title(ax1_4,'');
title(ax1_5,'Rocket Flight Path');

ylabel(ax1_1,'Rotation Rate (Hz)');
ylabel(ax1_2,'Rotation Rate (Hz)');
ylabel(ax1_3,'');
ylabel(ax1_4,'');
ylabel(ax1_5,'');

xlabel(ax1_1,'Time (s)');
xlabel(ax1_2,'Time (s)');
xlabel(ax1_3,'Time (s)');
xlabel(ax1_4,'Time (s)');
xlabel(ax1_5,'Time (s)');

ax3=axes('Parent',tab3,'Units','Normalized','Position',[0.3 0.05 0.65 0.9]);
axes(ax3);
axis off;
axis image;

% title(ax1_1,'Vertical Forces on Crankshaft');
% title(ax1_2,'Horizontal Forces on Crankshaft');
% title(ax1_3,'Piston Position');
% title(ax1_4,'Piston Velocity');
% title(ax1_5,'Piston Acceleration');
% 
% ylabel(ax1_1,'Vertical Forces on Crankshaft (N)');
% ylabel(ax1_2,'Horizontal Forces on Crankshaft (N)');
% ylabel(ax1_3,'Piston Position (m)');
% ylabel(ax1_4,'Piston Velocity (m/s)');
% ylabel(ax1_5,'Piston Acceleration (m/s^2)');
% 
% xlabel(ax1_1,'Time (s)');
% xlabel(ax1_2,'Time (s)');
% xlabel(ax1_3,'Time (s)');
% xlabel(ax1_4,'Time (s)');
% xlabel(ax1_5,'Time (s)');

set(gcf, 'Position', get(0, 'Screensize'));


final_rotation_at_apogee=ohmega(length(ohmega))/(2*pi) %final value of spin in Hz at apogee


%%% Danny's moment program integration (need to work on function)
% moment_other = Moment_Calculator(finbasem, finheightm, finlengthm, density, speed, degrees, ohmega, rocket_radius_m, timestep, number_of_fins);





