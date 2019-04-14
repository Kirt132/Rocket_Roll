%% Pitch Roll Coupling Calculation
    %The goal of this to to be able to plot the pitching freqency of the
    %rocket next to the spin data to show the quick passby
    %define variables
    density = 1.2; %density in kg/m^3
    %velocity_mach = 343*[0:.1:1]; % get velocity from other script, for now it is mach 0-1 (m/s)
    velocity_mach = abs(rocket_flight(:,3)); %velocity from file (m/s)
    q = 1/2*density*velocity_mach.^2; %dynamic pressure, ideally get this from the other script
    Rocket_cd = 0.7;%Cd of the rocket based on RasAeroSims
    finwidth = finheightm; %width of fin (m)
    finthickness = 0.005; %thickness of fin (m)
    Stability_Margin = 2; %use data from the simulation here too
    d = 0.0472; %diameter of the rocket (m)
    Ixx = 0.2129;%the yaw and pitch moment of inertia of the rocket (kg*m*m)[estimate]
    Izz = 0.00041764;%the roll moment of the rocket, much smaller than Ixx (kg*m*m)
    C_m_alpha = -Rocket_cd*Stability_Margin*d/2; %calculating the moment
    %divided by the area) caused by a small angle sinx = x at small angles
    A_ref = pi*d + 3*finwidth*finthickness; %cross sectional area of the rocket

    pitchfreq = (sqrt(-q*A_ref*C_m_alpha/(Ixx-Izz)))/(2*pi);
    figure(48)
    hold on
    plot(velocity_mach,pitchfreq,'LineWidth',2)
    plot(yvelmod,ohmega/(2*pi),'LineWidth',2)
    xlabel('Velocity (m/s)')
    ylabel('Rotation Rate (Hz)')
    xlim([0 1])
    ylim([0 0.02])
    legend('Pitching Frequency','Rocket Spin Rate')
    title('Pitch Roll Coupling')
    set(gcf,'Color','w')
    hold off
    
%% Instability Caused by offcenter mass
   %The goal of this is to show the force caused by an unbalanced rocket
   %mass. This will lead to internal stresses in the rocket and has
   %potential to change the angle of attack of the rocket
   spinspeed = 20; %spin speed of rocket in radians per second
   w = spinspeed*2*pi;%spin speed of rocket in radians per second
   %borrows d from above
   m = .005; %offset mass (in kg)
   force = m*d/2*w^2