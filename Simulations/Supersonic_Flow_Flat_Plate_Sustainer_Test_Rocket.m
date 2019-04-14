%Program using Prandtl-Meyer Angle and Shock Expansion Theorem using the
%launch profile of the sustainer rocket
clear
clc
%The following values are constants and should not be changed
R=287.05; %Universal Gas Constant (J/kg*K)
theta=3055.556; %Thermal Constant (K) [5500*R]
PI=3.14159265359; %mathematical constant pi
g=9.81; %Earth's gravitational acceleration
e=2.71828; %mathematical constant e
load AIAA_Sustainer.txt

alpha_deg=8; %incoming angle (degrees); angle > 6.022; (38.6)
alpha_rad=alpha_deg*(PI/180); %calculated incoming angle (radians)

T=AIAA_Sustainer(:,2); %temperature (K)
P=AIAA_Sustainer(:,3); %pressure (Pa) or (N/m^2) or (kg/m*s^2)
M=AIAA_Sustainer(:,4); %velocity (mach #) [unitless value]
cv=(-1.2914.*10.^(-10).*T.^3+3.231.*10.^(-7).*T.^2-4.7034.*10.^(-5).*T+0.7047).*1000;
gam_ideal=1+(R./cv); %ideal capital gamma value (before plate flow) [unitless]
rho=P./(R.*T); %density of air (kg/m^3)


%Begin of actual calculations:
gam=(1+((gam_ideal-1)./(1+(gam_ideal-1).*((theta./T).^2.*((e.^(theta./T))./((e.^(theta./T)-1).^2))))));
    %gam is the capital gamma seen in the other equations and represents
    %the ratio of specific heats once the air is in flow around the plate

a=atan(1./(tan(alpha_rad).*((((gam+1).*M.^2)./(2.*M.^2.*(sin(alpha_rad)).^2-1))-1)));
    %a is the deflection angle through the shock (radians)

M_2_sqr=(((gam-1).*M.^2.*(sin(alpha_rad)).^2+2)./(2.*gam.*M.^2.*(sin(alpha_rad)).^2-(gam-1)))./((sin(alpha_rad-a)).^2);
    %M2^2 is the mach flow of the air above the plate; this value is used
    %in one other equation (mach #) [unitless]

beta_deg_vec=10:0.01:70;
beta_rad_vec=beta_deg_vec.*(PI/180);
diff=abs(((2.*(M.^2.*(sin(beta_rad_vec)).^2-1))./((tan(beta_rad_vec)).*(2+M.^2.*(gam+cos(2.*beta_rad_vec)))))-(tan(alpha_rad)));
m=diff';
b=size(diff);
u=zeros(1,5525);
for i=1:1:b(1)
    percent_complete=i./(b(1))*100
    c=delaunayn(m(:,i));
    u(i)=dsearchn(m(:,i),c,0);
end
%u
beta_deg=u*0.01+9.99;
beta_rad=beta_deg*(PI/180);
    %This function calculates the a by which the flow is deflected due to
    %the shock

Pu_Pinf=((1+((gam-1)./2).*M.^2)./(1+((gam-1)./2).*M_2_sqr)).^(gam./(gam-1));
    %P(u)/P(inf) is the ratio between the pressure above the plate compared
    %to P infinity (ahead of the plate) [unitless]

Pl_Pinf=1+((2.*gam)./(gam+1)).*(((M.*sin((beta_rad'))).^2)-1);
    %P(l)/P(inf) is the ratio between the pressure below the plate compared
    %to P infinity (ahead of the plate) [unitless]

Cl=((Pl_Pinf-Pu_Pinf)./((gam./2).*M.^2)).*cos(alpha_rad);
    %Cl is the actual coefficient of lift [unitless]

Cl_simp=(4.*alpha_rad)./((M.^2-1).^(1/2));
    %Simplified model for coefficient of lift; does not plot properly when
    %mach # is less than 1


hold on
plot(AIAA_Sustainer(210:2600,1),Cl(210:2600),'b-')
plot(AIAA_Sustainer(210:2600,1),Cl_simp(210:2600),'r-')
plot(AIAA_Sustainer(1:3000,1),AIAA_Sustainer(1:3000,4),'m:')
xlabel('Rocket Height (m)')
ylabel('Coefficient of Lift/ Mach Number')
title('Coefficient of Lift at Supersonic Rocket Velocity with Test Rocket')
legend('Implicit Model','Simplified Model','Mach Velocity')
hold off

L_A1=(Pl_Pinf-Pu_Pinf).*P.*cos(alpha_rad);
L_A2=Cl.*rho.*(M.*343).^2.*0.5;
    %these two values are the lift per unit area using the two different
    %lift equations

fprintf('The lift per unit area is approximately %1.2fN/m^2.\n',(L_A1+L_A2)/2)



