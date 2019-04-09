clear all
load Inertia_13_Degrees.txt
launch=Inertia_13_Degrees;
x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);
x_mag = launch(:,7);
y_mag = launch(:,8);
z_mag = launch(:,9);

[length,width]=size(x_accel);
log_time=(0:0.02:length/50)';

%find the launch window
launchtime=1;
%while z_accel(launchtime)<40

%    launchtime=launchtime+1;
%end

logstart = 3000;
logstop = 6000;
x_accel_short = x_accel(logstart:logstop);
y_accel_short = y_accel(logstart:logstop);
z_accel_short = z_accel(logstart:logstop);
x_roll_short = x_roll(logstart:logstop);
y_roll_short = y_roll(logstart:logstop);
z_roll_short = z_roll(logstart:logstop);
x_mag_short = x_mag(logstart:logstop);
y_mag_short = y_mag(logstart:logstop);
z_mag_short = z_mag(logstart:logstop);
short_launch_length = logstop - logstart;
short_launch_time = (0:.02:(short_launch_length)/50)';
z_roll_accel = gradient(z_roll_short/.02);
figure
hold on
plot(x_accel)
plot(y_accel)
plot(z_accel)
title ('Linear Acceleraton of the Rocket')
xlabel ('Time [s]')
ylabel('Potential [V]')
legend('X', 'Y', 'Z')
hold off

figure
hold on
plot(short_launch_time, z_roll_short)
%plot(short_launch_time, z_roll_accel)


title ('roll Acceleraton of the Rocket')
xlabel ('Time [s]')
ylabel('Potential [V]')
legend('X', 'Y', 'Z')
hold off

figure
hold on
plot(short_launch_time, x_mag_short)
%plot(short_launch_time, y_mag_short)
%plot(short_launch_time, z_mag_short)
title ('Mag Acceleraton of the Rocket')
xlabel ('Time [s]')
ylabel('Potential [V]')
legend('X', 'Y', 'Z')
hold off

figure
hold on
subplot(2,1,1)
plot(short_launch_time, z_accel_short)
subplot(2,2,1)
plot(short_launch_time, z_roll_short)
%plot(short_launch_time, x_mag_short)
title ('Linear Acceleraton of the Rocket')
xlabel ('Time [s]')
ylabel('Potential [V]')
%legend('Z Accel', 'Z Roll', 'Z Mag')
hold off

%%via graph find two points
x1 = [3.66 19.42 31.98];
x2 = [4.76 20.02 32.48];
y1 = [-25.97 -8.4 -14.14];
y2 = [2288 1553 1701];
angle = 13/180*pi;%slope angle
d = .0475; %rocket diameter in m
m = .65 +.06 %weight of rocket in kg
rollaccel = ((y2-y1)./(x2-x1))*pi/180
Izz = m*((9.81*sin(angle) - 0.0475/2.*rollaccel)./rollaccel)*(d/2) %calculate moment of inertia
Izz_Avg = mean(Izz)

%%via graph for 19 degrees
x1 = [10.12 17.34 24.16 30.22];
x2 = [10.48 17.9 24.68 30.78];
y1 = [96.01 -17.85 -6.58 -2.17];
y2 = [1904 2242 2159 2285];
angle = 19/180*pi;%slope angle
d = .0475; %rocket diameter in m
m = .65 +.06 %weight of rocket in kg
rollaccel19 = ((y2-y1)./(x2-x1))*pi/180
Izz19 = m*((9.81*sin(angle) - ((0.0475/2).*rollaccel19))./rollaccel19)*(d/2) %calculate moment of inertia
Izz19_Avg = mean(Izz)