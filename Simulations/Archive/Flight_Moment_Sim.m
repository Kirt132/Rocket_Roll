clear %empty workspace variables
clc %clear command window
Ip=(63579.33769/144)/32.2; %pitch moment of inertia
Ir=(193.12587/144)/32.2; %roll moment of inertia lbf-ft-s^2
Sg=3.0; %required value for stability
Cla=14.32; %lift coefficient - may need to get from Table 1/rad
S=0.0872664; %reference area get from Solidworks - cross sectional area
Xcg=80.5905512/12; %get from Solidworks (from tip)
Xcp=86.124/12; %from file
M=1; %mach number
Po=629.712; %ambient pressure at altitude - add this to table lb/ft^2 (30,000ft)
q=0.7*Po*M^2; %calculate dynamic pressure
Ma=Cla*q*S*(Xcp-Xcg) %calculate turning moment
w=sqrt((Sg*4*Ma)/(Ip*((Ir/Ip)^2))); %radians per second
W=(w*57.2958)/360 %rotations per second
%%%Don't change the above variables; used as initial reference

Ip=(6357.933769/144)/32.2; %pitch moment of inertia        /(10/144/32.2)
Ir=(1931.2587/144)/32.2; %roll moment of inertia lbf-ft-s^2   *(10/144/32.2)
Sg=2; %required value for stability                -(1)
Cla=1.25; %lift coefficient - may need to get from Table 1/rad    (If Cla is actually 1.25)
S=0.0872664; %reference area get from Solidworks - cross sectional area
Xcg=80.5905512/12; %get from Solidworks (from tip)
Xcp=83.124/12; %from file       -(3/12)
M=3.61; %mach number
Po=629.712; %ambient pressure at altitude - add this to table lb/ft^2 (30,000ft)
q=0.7*Po*M^2; %calculate dynamic pressure
Ma=Cla*q*S*(Xcp-Xcg) %calculate turning moment
w=sqrt((Sg*4*Ma)/(Ip*((Ir/Ip)^2))); %radians per second
W=(w*0.1591549) %rotations per second


Ip=1; % pitch moment of inertia
Ir=0.5; %roll moment of inertia
Sg=3.0; % required value for stability
Cla=14.32; %lift coefficient - may need to get from table
S=3; %reference area get from solidworks
Xcg=70; %Get from solidworks (from tip)
Xcp=80; %from file
M=1; %Mach Number
Po=10; %ambient pressure at altitude - add this to table
q=0.7*Po*M^2; %Calculate Dynamic pressure
Ma=Cla*q*S*(Xcp-Xcg) %Calculate turning moment
w=sqrt((Sg*4*Ma)/(Ip*(Ir/Ip)^2));
W=(w*0.1591549) %rotations per second