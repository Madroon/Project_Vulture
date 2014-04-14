function [C_in,C_eq] = ProjectVulture_Con(X)  
% Computation of scaled constraints
% Design variables not scaled.
% Input:
%   x  : [8x1] vector of design variables
%          X(1) = Croot
%          X(2) = bInner
%          X(3) = bOuter
%          X(4) = tInner
%          X(5) = tOuter
%          X(6) = SwInner
%          X(7) = SwOuter
%          X(8) = dihedralOuter
%          X(9) = alpha_star
%          X(10)= mWing
% Output:
%   g  : inequality constraint values
%   h  : equality constraint values

%% Constants for the solver
ProjectVulture_Inputs;

%% Analyze the design
mTotal =  ProjectVulture_Weight(X);
results = ProjectVulture_Aero(X);

%% Remove scaling
X = X.*I;

% g - inequality constraints
C_in(1) = results.Cm_a;
%C_in = [];

% h-vector
C_eq(1) = (mTotal*g)-results.L;
C_eq(2) = X(10)-(mTotal - mPayload);

% % Nominal valve area:
% Av = Dv^2*pi/4;
% 
% % Analysis of current valve spring design.
% [svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
%     spranal1(D,d,L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
%     
% % Scaled length constraint
% g(1) = Lmin/L2 - 1;
%     
% % Scaled lowest force constraint
% F1min = Av * p1;
% g(2) = 1 - F1/F1min;
%     
% % Scaled highest force constraint
% F2min = Av * p2;
% g(3) = 1 - F2/F2min;
%     
% % Scaled shear stress constraint
% Tau12max = 600*10^6;
% g(4) = Tau2/Tau12max - 1;
%     
% % Scaled frequency constraint
% freq1lb = ncamfac * nm/2;
% g(5) = 1 - freq1/freq1lb;
% 
% % Equality constraints
% h = [];
% 
% %end of sprcon2.m
% 