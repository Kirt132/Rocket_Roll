%%This is the actual simualtion of our little rocket. This is because kurt
%%can't find the issue in his code.
%Initialize for the moment solver script

%%load the file with velocity profile and time here
lengths = .1143; %chord 1
width = .0707;
chordtip = .040005; %chord2
rho = 1.2;%air density
V = 343/2;%m/s
theta = 2*pi/180;
ohmega = 16*2*pi; %radians per second
r =.0472/2; %rocket radius m
stepsize = .0001;
finnum = 3;
inertia = .00041764;
time = arreauxloaded(:,1);
time = time(5:end-5);
numberofsteps = 448;
timestep = zeros(1,numberofsteps);
velocity = arreauxloaded(:,3);
velocity = velocity(5:end-5);
for n = 1:numberofsteps-1
   timestep(n) = time(n+1) - time (n);
end

ohmega2 = zeros(1,numberofsteps+1); %initializes size for matrix
moment2 = zeros(1,numberofsteps+1); %initializes size for matrix
alpha2 = zeros(1,numberofsteps+1); %initializes size for matrix

for n = 1:448
    ohmega2(n+1) = ohmega2(n);
    for i = 1:100
moment2(n) = Moment_Calculator_2(lengths, width, chordtip, rho, velocity(n), theta, ohmega2(n+1), r, stepsize, finnum);
alpha2(n) = moment2(n)/inertia;
ohmega2(n+1) = ohmega2(n+1)+ alpha2(n)*timestep(n)/100;
    end
end
ohmega2 = ohmega2/2/pi;
figure
time(449) = 12;
plot(time(1:286), ohmega2(1:286));