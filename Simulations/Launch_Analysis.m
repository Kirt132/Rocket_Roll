%Code for Analyzing Launch
%clear; %clear variables
clc; %clear command window

%Launches 1:1-2 degrees; 2-bad data; 3-0 degrees; 4-4 degrees
%Launches 2:1-2 degrees; 2-4 degrees; 3-no data; 4-0 degrees; 5-2 degrees

cd D:\MATLAB\Rockets\Launch_Profiles\Past_Launches
directory = dir;
load Launch_2_5.txt
launch=Launch_2_5;

% cd D:\MATLAB\Rockets\Other_Text_Files
% directory = dir;
% load Lathe_Test_Magnet.txt
% launch=Lathe_Test_Magnet;


[ee,ff]=size(launch);
x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);
if ff==9
    x_mag=launch(:,7);
    y_mag=launch(:,8);
    z_mag=launch(:,9);
end

if ff~=9
    i=1;
    while z_accel(i)<40
        i=i+1;
    end
end

[o,p]=size(x_accel);
log_time=(0:0.02:o/50)';
figure(14)

%All components plotted on same graph:
hold on
% plot(log_time(1:o,:),x_accel)
% plot(log_time(1:o,:),y_accel)
% plot(log_time(1:o,:),z_accel)
% plot(log_time(1:o,:),x_roll)
% plot(log_time(1:o,:),y_roll)
% plot(log_time(1:o,:),-z_roll)
plot(log_time(1:o,:),x_mag)
plot(log_time(1:o,:),y_mag)
plot(log_time(1:o,:),z_mag,'LineWidth',2)
% legend('x Acceleration','y Acceleration','z Acceleration','x Roll Rate','y Roll Rate','z Roll Rate')
% legend('Z-Axis Roll Rate')
legend('x-Mag','y-Mag','z-Mag')
xlabel('Time (s)')
ylabel('Roll Rate (Hz)')
title('Gryoscope Roll Reading')
hold off

% %Plotting simulated roll data (Rocket_Roll) against measured roll rate
% hold on
% plot(log_time(1:o,:),-z_roll/(2*pi))
% % plot(time+(i/50),ohmega/(2*pi))
% plot(time+470.5,ohmega/(2*pi))
% legend('Measured Roll Rate','Simulated Roll Rate')
% xlabel('Time (s)')
% ylabel('Rocket Roll Rate (Hz)')
% title('Actual vs. Simulated Roll Rate')
% % axis([i/50-1 i/50+100 -inf inf])
% axis([470 485 -inf inf])
% hold off

%Plot of the Lathe data (6 test speeds) [There was nowhere else for this
%code, so I tossed it here]
% load Lathe.txt
% Lathe=Lathe_Test_Magnet;
% hold on
% plot(Lathe(:,7),'LineWidth',2)
% plot(Lathe(:,8),'LineWidth',2)
% plot(Lathe(:,9),'LineWidth',2)
% legend('x Acceleration','y Acceleration','z Acceleration','x Roll Rate','y Roll Rate','z Roll Rate')
