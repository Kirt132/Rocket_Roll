%Program using Prandtl-Meyer Angle and Shock Expansion Theorem using the
%launch profile of the full scale rocket to determine lift and drag
clc

rot=transpose(zeros(1,15171)); %intial rotational rate (rad/s); 0rad/s initially


%subsonic/ transonic= <=1.3M (442.377m/s)
%supersonic= >1.3M (442.377m/s)
ang_accel=transpose(zeros(1,15171));


for i=2:1:b(1)
    if M(i)<=1.3
        ang_accel(i)=((rho(i)*area*(OD/2+geo_center))/(2*I))*((2*PI*alpha_rad*(velocity(i)*velocity(i)))-(1.28*sin(alpha_rad))*(((OD/2+geo_center)*(rot(i-1)))^2));
    end
    if M(i)>1.3
        ang_accel(i)=((rho(i)*area*(OD/2+geo_center))/(2*I))*((((2*(Pl_Pinf(i)-Pu_Pinf(i)))/(gam(i)*M(i)))*cos(alpha_rad)*(velocity(i)*velocity(i)))-(1.28*sin(alpha_rad))*(((OD/2+geo_center)*(rot(i-1)))^2));
    end
    rot(i)=ang_accel(i)*(time(i)-time(i-1))+rot(i-1);
end


%Fdrag_sub;
%Fdrag_sup;


hold on
%plot(full_scale_data(1:15171,1),ang_accel(1:15171),'b-');
plot(altitude(:),rot(:),'r-');
xlabel('Rocket Height (m)')
ylabel('Rotation Rate (rad/s)')
title('Rotation Rate of Full Rocket')
legend('Simplified Model')
hold off




