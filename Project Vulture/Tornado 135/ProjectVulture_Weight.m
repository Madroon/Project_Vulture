% Project Vulture - Weight estimator function
 function [mTotal] =  ProjectVulture_Weight(X)
 
%% Input constants
ProjectVulture_Inputs;

%% Remove scaling
X = X.*I;

%% Deconstruct input vector for easy reading
Croot   = X(1);
bInner  = X(2);
bOuter  = X(3);
tInner  = X(4);
tOuter  = X(5);
SwInner = X(6);
SwOuter = X(7);
dihedralOuter = X(8); 
state.alpha = X(9);

%% Calculate the volume (weight)

% Open the airfoil file
airfoilPoints = importdata(['aircraft/airfoil/' airfoil_wing],' ',3);

% Area inner wing
Aroot = polyarea((airfoilPoints.data(:,1).*Croot),(airfoilPoints.data(:,2).*Croot));

% Area transition point
Ctrans = Croot * tInner;
Atrans = polyarea((airfoilPoints.data(:,1).*Ctrans),(airfoilPoints.data(:,2).*Ctrans));

% Area wing tip
Ctip = Ctrans * tOuter;
Atip =  polyarea((airfoilPoints.data(:,1).*Ctip),(airfoilPoints.data(:,2).*Ctip));

% Volume fuselage
vFuselage = bInner * 2 * ((Aroot + Atrans)/2);

% Volume wing
vWing = bOuter * 2 * ((Atrans + Atip)/2);

% Total volume
vTotal = vFuselage + vWing;
mWing = vTotal * rho;
mTotal = mWing + mPayload;