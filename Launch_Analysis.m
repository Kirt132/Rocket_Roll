%Code for Analyzing Launch
%clear; %clear variables
clc; %clear command window

load Launch_1.txt
launch=Launch_1;
x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);

i=1;
while z_accel(i)<40
    i=i+1;
end

[o,p]=size(x_accel);
log_time=(0:0.02:o/50)';

% hold on
% plot(log_time(1:o,:),x_accel)
% plot(log_time(1:o,:),y_accel)
% plot(log_time(1:o,:),z_accel)
% plot(log_time(1:o,:),x_roll)
% plot(log_time(1:o,:),y_roll)
% plot(log_time(1:o,:),z_roll)
% legend('x Acceleration','y Acceleration','z Acceleration','x Roll Rate','y Roll Rate','z Roll Rate')
% xlabel('Time (s)')
% ylabel('Rocket Avionics Data')
% title('Rocket Flight Data')
% hold off

hold on
plot(log_time(1:o,:),-z_roll/(2*pi))
plot(time+(i/50),ohmega)
legend('Measured Roll Rate','Simulated Roll Rate')
xlabel('Time (s)')
ylabel('Rocket Roll Rate (Hz)')
title('Actual vs. Simulated Roll Rate')
axis([i/50-1 i/50+100 -inf inf])
hold off