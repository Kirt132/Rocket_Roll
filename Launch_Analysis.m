%Code for Analyzing Launch
%clear; %clear variables
clc; %clear command window
clear all;
load Launch_3.txt
launch=Launch_3;
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
%plot(log_time(1:o,:),-z_roll/(2*pi))
rx = .01;
ry = .001;
ohmega_x = sqrt(abs(x_accel/rx))*(1/(2*pi));
ohmega_y = sqrt(abs(y_accel/ry))*(1/(2*pi));
plot(log_time(1:o,:), ohmega_x);
plot(log_time(1:o,:), ohmega_y);
axis([i/50 i/50+10 0 15])
title('Estimated Roll Rate')
legend('ohmega_X','ohmega_Y')
hold off
%figure
%plot(log_time(1:o,:),x_accel)
%x_accel_fft = y_accel(i:i+250);
%P2 = abs(fft(x_accel_fft/250));
%P1 = P2(1:26);
%P1(2:end-1) = 2*P1(2:end-1);
%Fs = 50;
%f = Fs*(0:(50/2))/50;
%plot(log_time(1:o,:),y_accel)
%plot(log_time(1:o,:),z_accel)
%plot(time+(i/50),ohmega)
%legend('X_accel','Y_accel','Z_accel')
%xlabel('Time (s)')
%ylabel('Rocket Roll Rate (Hz)')
%title('Actual vs. Simulated Roll Rate')
%axis([i/50 i/50+5 -80 80])
%hold off
%figure
%plot(f,P1);