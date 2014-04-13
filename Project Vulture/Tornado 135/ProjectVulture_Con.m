function [g,h] = ProjectVulture_Con(X)  
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
% Output:
%   g  : inequality constraint values
%   h  : equality constraint values

% Deconstruct input vector for easy reading
Croot   = X(1);
bInner  = X(2);
bOuter  = X(3);
tInner  = X(4);
tOuter  = X(5);
SwInner = X(6);
SwOuter = X(7);
dihedralOuter = X(8);

% Analyze the current design
ProjectVulture_Analyzer;

% g - inequality constraints
g(1) = results.Cm_a;

% h-vector

h = [];

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