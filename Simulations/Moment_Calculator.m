function [moment_other]=Moment_Calculator(finbasem, finheightm, finlengthm, airdensity, speed, degrees, ohmega2, rocket_radius_m, timestep, number_of_fins)
% make a function for the roll momenet of the rocket
% variables, comment out for actual code usage

% length = 6*0.0254; %chord 1
length_ = finbasem;
% width = 4*.0254;
width = finheightm;
% chordtip = 6 *.0254; %chord2
chordtip = finlengthm;
% rho = 1.2;%air density
rho = airdensity;
% V = 343/2;%m/s
V = speed;
% theta = 2*pi/180;
theta = degrees;
Vy = sin(theta)*V;
% ohmega = 11*2*pi; %radians per second
% ohmega2 = ohmega2;
% r =.0254; %rocket radius m
r = rocket_radius_m;
% stepsize = .0001;
% stepsize = timestep/100;
stepsize=timestep;
% finnum = 3;
finnum = number_of_fins;

%%Magic Happens Here, Cool to compare to Cp estimates 
intwidth = r:stepsize:width+r; %width at which to intergrate the moment over
vofr = intwidth'*ohmega2; %calculate anglar velocity across the fin
[nn,mm]=size(vofr);
abc=sum(vofr(1:nn,:))/nn;
% calcvel = Vy - vofr; %oncoming fin velocity
calcvel = Vy' - abc(1:length(Vy));
thetafull = atan(calcvel/V); %angle of attack for each fin portion
% thetafull(1,1) = 0; %fix the NAN that destroys the rest of the program
lengthint = -((length_-chordtip)/width)*(intwidth-r)+length_; %calculate the length in 1mm imcrements
cl = 2*pi*thetafull; %find the lift coefficient
moment_other = 1/2*finnum*rho*sum(cl*(V.^2)*lengthint*stepsize*(intwidth')); %find the moment based on the fins

if isnan(moment_other)==1
    moment_other=0;
end

end