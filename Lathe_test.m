clear all
load Launch_2_5.txt
launch=Launch_2_5;
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
while z_accel(launchtime)<40
    launchtime=launchtime+1;
end
logstart = launchtime -.5/.02;
logstop = launchtime + 12/.02;
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
figure
hold on
plot(short_launch_time, x_accel_short)
plot(short_launch_time, y_accel_short)
plot(short_launch_time, z_accel_short)
title ('Linear Acceleraton of the Rocket')
xlabel ('Time [s]')
ylabel('Potential [V]')
legend('X', 'Y', 'Z')
hold off

figure
hold on
plot(short_launch_time, x_roll_short)
plot(short_launch_time, y_roll_short)
plot(short_launch_time, z_roll_short)
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
