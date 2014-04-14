% Project Vulture
%
% Main

%% Clear workspace
clc;
clear all;
close all;

%% Input constants
ProjectVulture_Inputs;

%% Initial design point
X0 = ones(10,1);

%% Bounds of the problem
%       Croot bInner  bOuter  tInner  tOuter   SwInner  SwOuter dihedralOuter
<<<<<<< HEAD
lb = [  0.2,  0.5,    0.5,    0.3,    0.1,     0.1,     0.1,    1.0  1   0.1];
ub = [  2.0,  1.0,    1.0,    1.0,    1.0,     2.0,     1.0,    1.0  6  3.0];
=======
lb = [  0.2,  0.1,    0.1,    0.3,    0.1,     0.1,     0.1,    1.0  1   0.1];
ub = [  2.0,  1.5,    0.3,    1.0,    1.0,     0.6,     0.7,    1.0  6  5.0];
>>>>>>> d42bc0c2534d262441f076a60bec509593393763

%% Set up the options
options = optimset('Display','iter');
options = optimset(options,'Algorithm', 'interior-point');
options = optimset(options,'DiffMinChange', 0.1);
<<<<<<< HEAD
=======
options = optimset(options,'TolFun',1e-4);
>>>>>>> d42bc0c2534d262441f076a60bec509593393763

%% Run the optimizer

[X,fval,exitflag,output, lambda] = fmincon(@ProjectVulture_Solver,X0,[],[],[],[],lb,ub,@ProjectVulture_Con,options);

design(:,1) = X0;
design(:,2) = X;
design(:,3) = X0.*I;
design(:,4) = X.*I;
design(6:9,3:4) = design(6:9,3:4) .* 180/pi;

%% Plot result
[results] = ProjectVulture_Result(X);


