%Program using Prandtl-Meyer Angle and Shock Expansion Theorem and the
%simplfied model using a variable angle of attack for a single mach number
clear
clc
%The following values are constants and should not be changed
R=287.05; %Universal Gas Constant (J/kg*K)
theta=3055.556; %Thermal Constant (K) [5500*R]
PI=3.14159265359; %mathematical constant pi
g=9.81; %Earth's gravitational acceleration
e=2.71828; %mathematical constant e


T=300; %temperature (K)
P=101325; %pressure (Pa) or (N/m^2) or (kg/m*s^2)
cv=718; %specific heat capacity of air at sea level and 300K (J/kg*K)
    %this values should be calculated separately based on temperature and
    %pressure; this value does not change much relative to pressure (<0.05%
    %change between 1atm and 0.01atm) but DOES change relative to
    %temperature (23% change between 200K and 1500K); needs to be
    %re-evaluated iteratively for each temperature

gam_ideal=1+(R/cv); %ideal capital gamma value (before plate flow) [unitless]
%alpha_deg=10; %incoming angle (degrees); angle > 6.022; (38.6)
%alpha_rad=alpha_deg*(PI/180); %calculated incoming angle (radians)
M=3.6; %velocity (mach #) [unitless value]
rho=P/(R*T); %density of air (kg/m^3)
%gamma=rho*g; %specific weight of air (kg/m^2*s^2) or (Pa/m); not needed

comp=zeros(1,4000);
simp=zeros(1,4000); %used simply to increase performance time

for q=1:0.1:436
alpha_deg=q*0.1+1.4;
alpha_rad=alpha_deg*(PI/180);
%Begin of actual calculations:
gam=(1+((gam_ideal-1)/(1+(gam_ideal-1)*((theta/T)^2*((e^(theta/T))/((e^(theta/T)-1)^2))))));
    %gam is the capital gamma seen in the other equations and represents
    %the ratio of specific heats once the air is in flow around the plate

a=atan(1/(tan(alpha_rad)*((((gam+1)*M^2)/(2*M^2*(sin(alpha_rad))^2-1))-1)));
    %a is the deflection angle through the shock (radians)

M_2_sqr=(((gam-1)*M^2*(sin(alpha_rad))^2+2)/(2*gam*M^2*(sin(alpha_rad))^2-(gam-1)))/((sin(alpha_rad-a))^2);
    %M2^2 is the mach flow of the air above the plate; this value is used
    %in one other equation (mach #) [unitless]

beta_deg_vec=10:0.01:66;
beta_rad_vec=beta_deg_vec.*(PI/180);
diff=abs(((2.*(M.^2.*(sin(beta_rad_vec)).^2-1))./((tan(beta_rad_vec)).*(2+M.^2.*(gam+cos(2.*beta_rad_vec)))))-(tan(alpha_rad)));
%hold on
%plot(beta_deg,(2.*(M.^2.*(sin(beta_rad)).^2-1))./((tan(beta_rad)).*(2+M.^2.*(gam+cos(2.*beta_rad)))))
%plot(beta_deg,tan(alpha_rad),'o')
%plot(beta_deg,diff)
%hold off
z=min(diff);
for i=1:1:5601
    if diff(i)>z
        diff(i)=0;
    end
end
y=find(diff);
beta_deg=y*0.01+9.99;
beta_rad=beta_deg*(PI/180);
    %This function calculates the a by which the flow is deflected due to
    %the shock

Pu_Pinf=((1+((gam-1)/2)*M^2)/(1+((gam-1)/2)*M_2_sqr))^(gam/(gam-1));
    %P(u)/P(inf) is the ratio between the pressure above the plate compared
    %to P infinity (ahead of the plate) [unitless]

Pl_Pinf=1+((2*gam)/(gam+1))*(((M*sin(beta_rad))^2)-1);
    %P(l)/P(inf) is the ratio between the pressure below the plate compared
    %to P infinity (ahead of the plate) [unitless]

Cl=((Pl_Pinf-Pu_Pinf)/((gam/2)*M^2))*cos(alpha_rad);
    %Cl is the actual coefficient of lift [unitless]

n=int32(q*10-9);
comp(n)=Cl;
simp(n)=(4*alpha_rad)/((M^2-1)^(1/2));
end

alpha_deg=1.5:0.01:45;
hold on
plot(alpha_deg,comp,'*')
plot(alpha_deg,simp,'x')
xlabel('Angle of Attack (Degrees)')
ylabel('Coefficient of Lift')
title('Lift Coefficient Based on Two Different Models')
legend('Prandtl-Meyer/ Shock Expansion Theory','Simplified Model')
hold off
%fprintf('The coefficient of lift is %1.3f .\n',Cl)
%fprintf('The C.O.L. using simplified model is %1.3f .\n',(4*alpha_rad)/((M^2-1)^(1/2)))


%L_A1=(Pl_Pinf-Pu_Pinf)*P*cos(alpha_rad);
%L_A2=Cl*rho*(M*343)^2*0.5;
    %these two values are the lift per unit area using the two different
    %lift equations

%fprintf('The lift per unit area is approximately %1.2fN/m^2.\n',(L_A1+L_A2)/2)