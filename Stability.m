%% Pitch Roll Coupling Calculation
    %The goal of this to to be able to plot the pitching freqency of the
    %rocket next to the spin data to show the quick passby
    %define variables
    density = 1.2; %density in kg/m^3
    velocity = 343*[0:.1:1]; % get velocity from other script, for now it is mach 0-1
    q = 1/2*density*velocity.^2; %dynamic pressure, ideally get this from the other script
    Rocket_cd = 0.7;%Cd of the rocket based on RasAeroSims
    finwidth = 3*0.0254;
    finthickness = .005;
    Stability_Margin = 2; %use data from the simulation here too
    d = 2; %diameter of the rocket in in
    Ixx = 30;%the yaw and pitch moment of interita of the rocket
    Izz = .1;%the roll moment of the rocket, much smaller than Ixx
    C_m_alpha = -Rocket_cd*Stability_Margin*d*0.0254/2; %calculating the moment
    %divided by the area) caused by a small angle sinx = x at small angles
    A_ref = pi*0.0254*d + 3*finwidth*finthickness; %cross sectional area of the rocket

    pitchfreq = (sqrt(-q*A_ref*C_m_alpha/(Ixx-Izz)))/(2*pi);
    plot(velocity, pitchfreq)
    
%% Instability Caused by offcenter mass
   %The goal of this is to show the force caused by an unbalanced rocket
   %mass. This will lead to internal stresses in the rocket and has
   %potential to change the angle of attack of the rocket
   spinspeed = 20; %spin speed of rocket in radians per second
   w = spinspeed*2*pi;%spin speed of rocket in radians per second
   %borrows d from above
   m = .005; %offset mass (in kg)
   force = m*d/2*w^2