clear
%Create variables. This is just so that the if statements work later.
Launch_2_1 = 0;
Launch_2_2 = 0;
Launch_2_3 = 0;
Launch_2_4 = 0;
Launch_2_5 = 0;
%load data. Just change the number of the launch in both lines below
load('Launch_2_4.txt')
launch=Launch_2_4;

%make column vectors out of the table of data
x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);
x_mag=launch(:,7);
y_mag=launch(:,8);
z_mag=launch(:,9);


%create time vector. Assume logger writes at 50 hz. 
[length,width]=size(x_accel);
i= 1:1:length;
time = i*.02;

%find the launch window. Each launch has various accelerations before
%ignition which means there needs to be a different threshold in order to
%actually detect it. Also, launches 4 and 5 used a different set of
%electronics which use different units. These if statements also adjust for
%the magnitude of the frequencies on the spectrogram.
launchframe=1;

if (launch == Launch_2_1) | (launch == Launch_2_2)
    while z_accel(launchframe)<40
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/(2*pi);
    x_roll = -1*x_roll/(2*pi);
    y_roll = -1*y_roll/(2*pi);
    minThresh = 0;
    pos = 'last';
    powerCutoff = 3;
elseif (launch == Launch_2_4)
    while z_accel(launchframe)<120
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/360;
    x_roll = -1*x_roll/360;
    y_roll = -1*y_roll/360;
    minThresh = -30;
    pos = 'first';
    powerCutoff = .005;
elseif (launch == Launch_2_5)
    while z_accel(launchframe)<40
    launchframe=launchframe+1;
    end
    z_roll = -1*z_roll/360;
    x_roll = -1*x_roll/360;
    y_roll = -1*y_roll/360;
    minThresh = -37;
    pos = 'last';
    powerCutoff = .0025;
else
    minThresh = 0;
    justwork = 'Didnt work'
    pos = 'last';
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
    'MinThreshold',minThresh, ...
    'Reassign',reassignFlag);
[P, F, T] = pspectrum(x_mag_ROI,timeValues, ...
    'spectrogram', ...
    'FrequencyLimits',frequencyLimits, ...
    'Leakage',leakage, ...
    'TimeResolution',timeResolution, ...
    'OverlapPercent',overlapPercent, ...
    'MinThreshold',minThresh, ...
    'Reassign',reassignFlag);
figure('Name', 'Acceleration and Roll','NumberTitle','off')

%Plot Acceleration
ax1 = subplot(3,1,1);
hold on
plot(timeValues,z_accel_processed)
plot(timeValues,y_accel_processed)
plot(timeValues,x_accel_processed)
axis([0 launchstop-launchstart (min(z_accel_processed)-.1*(max(z_accel_processed)-min(z_accel_processed))) (max(z_accel_processed)+.1*(max(z_accel_processed)-min(z_accel_processed)))])
xlabel('Time(s)')
ylabel('Acceleration(g)')
title('Acceleration vs Time')

ax2 = subplot(3,1,2);
[length,width]=size(z_accel_processed);
velocity = zeros(length,1);
velocity(1) = 0;
for i = 2:length
    velocity(i) = z_accel_processed(i-1)*9.8 * .02 + velocity(i-1);
end

plot(timeValues,velocity)
xlabel('Time(s)')
ylabel('Velocity (m/s)')
title('Velocity vs Time')

%Plot Roll
ax3 = subplot(3,1,3);
hold on
plot(timeValues,z_roll_processed)
plot(timeValues,y_roll_processed)
plot(timeValues,x_roll_processed)
axis([0 launchstop-launchstart (min(z_roll_processed)-.1*(max(z_roll_processed)-min(z_roll_processed))) (max(z_roll_processed)+.1*(max(z_roll_processed)-min(z_roll_processed)))])
xlabel('Time(s)')
ylabel('Gyro Roll Rate (Hz)')
title('Roll Rate vs Time')

x=1;
[lengthp, widthp] = size(P);
for j =1:widthp
    for i =1:lengthp
        if P(i,j) > powerCutoff
            ov(x,1) = T(j);
            ov(x,2) = F(i);
            x=x+1;
        end
    end
end

%ai is the index of the unique time values, sorted by last. Somehow this
%code works although I'm not positive how it works. I'm not questioning it
[nv1, ai] = unique(ov(:,1), pos)
figure('name', 'Spectrogram Roll Rate', 'NumberTitle','off')
plot(ov(ai,1),ov(ai,2))
xlabel('Time(s)')
ylabel('Roll Rate (Hz)')
title('Roll Rate vs Time')


%signalAnalyzer

