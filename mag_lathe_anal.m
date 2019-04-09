clear
%load data
Launch_2_1 = 0;
Launch_2_2 = 0;
Launch_2_3 = 0;
Launch_2_4 = 0;
Launch_2_5 = 0;
load('Launch_2_4.txt')
launch=Launch_2_4;

x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);
x_mag=launch(:,7);
y_mag=launch(:,8);
z_mag=launch(:,9);


%create time vector
[length,width]=size(x_accel);
for i= 1:1:length
    time(i) = i*.02;
end

%find the launch window
launchframe=1;
%Launch start is when z acceleration is > 40 m/s/s
if (launch == Launch_2_1) | (launch == Launch_2_2)
    while z_accel(launchframe)<40
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/(2*pi);
    x_roll = -1*x_roll/(2*pi);
    y_roll = -1*y_roll/(2*pi);
elseif (launch == Launch_2_4)
    while z_accel(launchframe)<120
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/360;
    x_roll = -1*x_roll/360;
    y_roll = -1*y_roll/360;
elseif (launch == Launch_2_5)
    while z_accel(launchframe)<40
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/360;
    x_roll = -1*x_roll/360;
    y_roll = -1*y_roll/360;
else
    justwork = 'Didnt work'
end
%launch window start is 0.5 s before launch frame and 13 s after. Find it
%by frame and correlate to time
logstart = launchframe -.5/.02;
logstop = launchframe + 13/.02;
launchstart = time(logstart);
launchstop = time(logstop);

%variables for the spectrogram controls
frequencyLimits = [0 25]; % Hz
leakage = 0.8;
timeResolution = 0.75; % seconds
overlapPercent = 99;
reassignFlag = true;

% Index into signal time region of interest
x_mag_ROI = x_mag(:);
timeValues = time;
minIdx = timeValues >= launchstart;
maxIdx = timeValues <= launchstop;

%Trim time frame and convert to proper units
x_mag_ROI = x_mag_ROI(minIdx&maxIdx);
timeValues = timeValues(minIdx&maxIdx);

z_accel_processed = z_accel(minIdx&maxIdx)/9.8;
x_accel_processed = x_accel(minIdx&maxIdx)/9.8;
y_accel_processed = y_accel(minIdx&maxIdx)/9.8;

z_roll_processed = z_roll(minIdx&maxIdx);
x_roll_processed = x_roll(minIdx&maxIdx);
y_roll_processed = y_roll(minIdx&maxIdx);

timeValues = timeValues - launchstart;

% Compute spectral estimate
%Plot the x magnetometer and spectrogram on the same plot
figure('Name', 'X Magnetometer Spectrogram','NumberTitle','off')
ax1 = subplot(2,1,1);
plot(timeValues, x_mag_ROI)
%scale axis
axis([0 launchstop-launchstart (min(x_mag_ROI)-.1*(max(x_mag_ROI)-min(x_mag_ROI))) (max(x_mag_ROI)+.1*(max(x_mag_ROI)-min(x_mag_ROI)))])
xlabel('Time(s)')
ax2 = subplot(2,1,2);
pspectrum(x_mag_ROI,timeValues, ...
    'spectrogram', ...
    'FrequencyLimits',frequencyLimits, ...
    'Leakage',leakage, ...
    'TimeResolution',timeResolution, ...
    'OverlapPercent',overlapPercent, ...
    'MinThreshold',0, ...
    'Reassign',reassignFlag);

figure('Name', 'Acceleration and Roll','NumberTitle','off')

%Plot Acceleration
ax1 = subplot(2,1,1);
hold on
plot(timeValues,z_accel_processed)
plot(timeValues,y_accel_processed)
plot(timeValues,x_accel_processed)
axis([0 launchstop-launchstart (min(z_accel_processed)-.1*(max(z_accel_processed)-min(z_accel_processed))) (max(z_accel_processed)+.1*(max(z_accel_processed)-min(z_accel_processed)))])
xlabel('Time(s)')
ylabel('Acceleration(g)')
title('Acceleration vs Time')


%Plot Roll
ax2 = subplot(2,1,2);
hold on
plot(timeValues,z_roll_processed)
plot(timeValues,y_roll_processed)
plot(timeValues,x_roll_processed)
axis([0 launchstop-launchstart (min(z_roll_processed)-.1*(max(z_roll_processed)-min(z_roll_processed))) (max(z_roll_processed)+.1*(max(z_roll_processed)-min(z_roll_processed)))])
xlabel('Time(s)')
ylabel('Gyro Roll Rate (Hz)')
title('Roll Rate vs Time')


signalAnalyzer

