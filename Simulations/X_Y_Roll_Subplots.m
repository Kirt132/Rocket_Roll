clc
load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_1_3.txt %0 degrees
load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_1_1.txt %2 degrees
load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_1_4.txt %4 degrees

figure(12)
set(gcf,'color','w');
subplot(3,1,1);
hold on
plot(Launch_1_3(:,4))
plot(Launch_1_3(:,5))
title('0 Degree Fin Cant')
legend('X-Roll Rate','Y-Roll Rate')
ylabel('Roll Rate (Hz)')
xlim([32100, 32600])
ylim([-0.25, 0.25]);
hold off

subplot(3,1,2);
hold on
plot(Launch_1_1(:,4))
plot(Launch_1_1(:,5))
title('2 Degree Fin Cant')
legend('X-Roll Rate','Y-Roll Rate')
ylabel('Roll Rate (Hz)')
xlim([30670, 31170])
ylim([-0.25, 0.25]);
hold off

subplot(3,1,3);
hold on
plot(Launch_1_4(:,4))
plot(Launch_1_4(:,5))
title('4 Degree Fin Cant')
legend('X-Roll Rate','Y-Roll Rate')
ylabel('Roll Rate (Hz)')
xlim([31142, 31642])
ylim([-0.25, 0.25]);
hold off


