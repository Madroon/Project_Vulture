clc;
clear all;
close all;

Croot = 5;
bInner = 3;
bOuter = 10;
tInner = 0.5;
tOuter = 0.5;
SwInner = deg2rad(30);
SwOuter = deg2rad(30);

X(1) = Croot;
X(2) = bInner;
X(3) = bOuter;
X(4) = tInner;
X(5) = tOuter;
X(6) = SwInner;
X(7) = SwOuter;

X0 = X;

% WB1440_Solver
 % Script for the WB1440 assignment. 
 % Calculates the objective function on the basis of the design variables
 % Input:   X [1x7] Design variable vector
 % Output:  F scalar objective function
% [F] =  WB1440_Solver(X);

options = optimset('Display','iter', 'MaxIter', 6);
X = fminunc(@WB1440_Solver, X0, options);

WB1440_result(X)


