% Project Vulture
%
% Main

%% Clear workspace
clc;
clear all;
close all;

%% Initial design point
Croot  = 0.5;
bInner = 0.5;
bOuter = 0.5;
tInner = 0.5;
tOuter = 0.5;
SwInner = 5*pi/180;
SwOuter = 5*pi/180;
dihedralOuter = 90*pi/180;

X(1) = Croot;
X(2) = bInner;
X(3) = bOuter;
X(4) = tInner;
X(5) = tOuter;
X(6) = SwInner;
X(7) = SwOuter;
X(8) = dihedralOuter;

X0 = X;

%% Bounds of the problem
%       Croot  bInner  bOuter  tInner  tOuter   SwInner    SwOuter    dihedralOuter
lb = [  0.20,  0.5,    0.1,    0.5,    0.1,     5*pi/180,  5*pi/180,  90*pi/180 ];
ub = [  0.50,  1.0,    0.2,    1.0,    1.0,    45*pi/180, 60*pi/180,  90*pi/180 ];

%% Run the optimizer
options = optimset('Display','iter','Algorithm', 'interior-point' );
[X,fval,exitflag,output, lambda] = fmincon(@ProjectVulture_Solver,X0,[],[],[],[],lb,ub,@ProjectVulture_Con,options);


%% Plot result
[results] = ProjectVulture_Result(X);


