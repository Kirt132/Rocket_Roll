clear
close all
load('flutterfiles.mat')
figure (1)
hold on
plot(simulatedrocketAltitudem,V_fms,'linewidth' , 3,'color', [0,0,1])
plot(simulatedrocketAltitudem,simulatedVerticalvelocityms,'linewidth' , 3,'color', [1,0,0])
title ('Fin Flutter Velocity')
xlabel ('Simulated Altitude (m)')
ylabel('Velocity (m/s)')
legend('Fin Flutter Velocity','Simulated Rocket Velocity')
axis([0,400, 0, max(V_fms)+20])
saveas(gcf,'flutter.png')
set(gcf,'color','w')
hold off
