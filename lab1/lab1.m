%% ece470: robot modelling and control
%  lab1: fwd and inv kinematics for the PUMA560 manipulator robot
%  authors: Pranshu Malik and Varun Sampat
%  date: 9 February 2022

clc;
close all;
clearvars; 

%% set up DH Matrix for the PUMA560
% in order of theta_i, d_i, a_i, alpha_i

% syms theta_1 theta_2 theta_3 theta_4 theta_5 theta_6
thetas = zeros(6); % initialize all thetas to zero

link_1 = [thetas(1) 0.76    0       pi/2    ];
link_2 = [thetas(2) -0.2365 0.4323  0       ];
link_3 = [thetas(3) 0       0       pi/2    ];
link_4 = [thetas(4) 0.4318  0       -pi/2   ];
link_5 = [thetas(5) 0       0       pi/2    ];
link_6 = [thetas(6) 0.20    0       0       ];

DH = [link_1; link_2; link_3; link_4; link_5; link_6];

%% create the PUMA560 robot model

myrobot = mypuma560(DH);

% plot a sample trajectory
theta_1 = linspace(0, pi, 200)';
theta_2 = linspace(0, pi/2, 200)';
theta_3 = linspace(0, pi, 200)';
theta_4 = linspace(pi/4, 3*pi/4, 200)';
theta_5 = linspace(-pi/3, pi/3, 200)';
theta_6 = linspace(0, 2*pi, 200)';
q = [theta_1 theta_2 theta_3 theta_4 theta_5 theta_6];

%% calculate the forward kinematics

o = zeros(size(q,1), 3);
for i = 1:size(q, 1)  
    H_0_6   = forward(q(i, :)', myrobot); % end-effector pose relative to base
    o(i, :) = H_0_6(1:3, 4)';             % translation vector
end

% plot end-effector trajectory and robot motion to verify fwd kinematics function
figure
plot3(o(:,1),o(:,2),o(:,3),'r');
hold on;
plot(myrobot, q);

%% calculate inverse kinematics

H = [cos(pi/4) -sin(pi/4) 0  0.20; 
     sin(pi/4)  cos(pi/4) 0  0.23; 
     0          0         1  0.15; 
     0          0         0  1];
qtest = inverse(H, myrobot)

% follow trajectory to verify inverse kinematics function
p1 = [0.1; 0.23; 0.15];
p2 = [0.3; 0.3;  1];
t  = linspace(0, 1, 100);
d  = p1*(1-t) + p2*t;
R  = rotz(pi/4);

q  = zeros(size(t,2), 6); 
for i = 1:size(t, 2)
    Ht      = [R     d(:, i); 
               0 0 0      1];
    q(i, :) = inverse(Ht, myrobot);
end

figure
plot3(d(1,:),d(2,:),d(3,:),'r', 'LineWidth', 4);
hold on;
plot(myrobot, q);
