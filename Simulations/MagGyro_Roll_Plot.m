clc %clear window

% load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_1_Roll_Rate.txt
% plottable_1=Launch_1_Roll_Rate;
% load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_2_Roll_Rate.txt
% plottable_2=Launch_2_Roll_Rate;
% load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_4_Roll_Rate.txt
% plottable_4=Launch_4_Roll_Rate;
load D:\MATLAB\Rockets\Launch_Profiles\Past_Launches\Launch_5_Roll_Rate.txt
plottable_5=Launch_5_Roll_Rate;
clean_plot_max=plottable_5;


% figure(1)
% hold on
% plot(plottable_1,'*')
% plot(clean_plot_1)
% legend('Plot 1','Plot 2','Clean Plot')
% figure(2)
% hold on
% plot(plottable_2,'*')
% plot(clean_plot_2)
% legend('Plot 1','Plot 2','Clean Plot')
% figure(3)
% hold on
% plot(plottable_4,'*')
% plot(clean_plot_4)
% legend('Plot 1','Plot 2','Clean Plot')
% figure(4)
% hold on
% plot(plottable_5,'*')
% plot(clean_plot_5)
% plot(clean_plot_5(2068:3300))
% plot(clean_plot_5(2068:2069+600))
% legend('Plot 1','Plot 2','Clean Plot')




% % clean_plot_max=zeros(1,length(plottable_5));
% temp_time=0;
% temp_rate=-0.01;
% n=1;
% for i=1:length(plottable_5)
%     current_time=plottable_5(i,1);
%     if current_time==temp_time
%         if plottable_5(i,2)>temp_rate
%             temp_rate=plottable_5(i,2);
%         end
%     elseif current_time>temp_time
%         clean_plot_max(n,1)=temp_time;
%         clean_plot_max(n,2)=temp_rate;
%         n=n+1;
%         temp_rate=plottable_5(i,2);
%         temp_time=current_time;
%     else
%         fprintf('ERROR!\nPlease de-bug!\n') %sanity check error message
%     end
% end
% clean_plot_max


















