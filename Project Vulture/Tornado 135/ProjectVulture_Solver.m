 function [F] =  ProjectVulture_Solver(X)
 % WB1440_Solver
 % Script for the WB1440 assignment. 
 % Calculates the objective function on the basis of the design variables
 %
 % Input:   X [1x9] Design variable vector
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
 % Output:  F scalar objective function

 %% Input constants
ProjectVulture_Inputs;

%% Calculate weight
mTotal = ProjectVulture_Weight(X);

%% Calculate Aerodynamics
results = ProjectVulture_Aero(X);

%% Calculate output
glideRatio = (results.CD+CD_viscous) / results.CL;

%% Calculate objective function
mass = (mTotal / mRef);
glide = ((glideRatio / glideRef));
F = w1*glide + w2 * mass;

end