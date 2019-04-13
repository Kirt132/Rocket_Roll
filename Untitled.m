clear
%Create variables. This is just so that the if statements work later.
Launch_2_1 = 0;
Launch_2_2 = 0;
Launch_2_3 = 0;
Launch_2_4 = 0;
Launch_2_5 = 0;
%load data. Just change the number of the launch in both lines below
load('Lathe_Test_Magnet.txt')
launch=Lathe_Test_Magnet;

%make column vectors out of the table of data
x_accel=launch(:,1);
y_accel=launch(:,2);
z_accel=launch(:,3);
x_roll=launch(:,4);
y_roll=launch(:,5);
z_roll=launch(:,6);
x_mag=launch(:,7);
y_mag=launch(:,8);
z_mag=launch(:,9);

[length,width]=size(x_accel);
i= 1:1:length;
time = i*.02;

signalAnalyzer