 function [F] =  WB1440_Solver(X)
 % WB1440_Solver
 % Script for the WB1440 assignment. 
 % Calculates the objective function on the basis of the design variables
 %
 % Input:   X [1x7] Design variable vector
 %          X(1) = Croot 
 %          X(2) = bInner
 %          X(3) = bOuter
 %          X(4) = tInner
 %          X(5) = tOuter
 %          X(6) = SwInner
 %          X(7) = SwOuter
 % Output:  F scalar objective function
 
% Deconstruct input vector for easy reading
Croot   = X(1);
bInner  = X(2);
bOuter  = X(3);
tInner  = X(4);
tOuter  = X(5);
SwInner = X(6);
SwOuter = X(7);

%% Constants for the solver

% Airfoils to be used
airfoil = 'N23018.dat';

% Weights for the multi-objective function
w1 = 1;
w2 = 1;

% Volume density
rho = 200; % [kg/m^3] 'density' of the volume, note 2700 [kg/m^3] density of general purpose aluminium

% g
g = 9.816;

% Lattice for the solver 1 = standard horseshoe
latticetype = 1;

%% Calculate the volume (weight)

% Open the airfoil file
airfoilPoints = importdata(['aircraft/airfoil/' airfoil],' ',3);

% Area fuselage root
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
mTotal = vTotal * rho;

%% Dimension calculations
Sinner = ((Croot + Ctrans)/2) * bInner;
Souter = ((Ctrans + Ctip)/2) * bOuter;
Stotal = Sinner + Souter;

%% Positions of the reference points

COG = 0.25; %Reference center of gravity position
ACx = 0.33; %Aerodynamic center x position (along chord)


%% Geometry definition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

geo.nwing=         1;               %Number of wings in the design, determines the number of ROWS in the geometry variables
geo.nelem=        [2];              %Number of partitions in the design, Determines the number of COLUMNS in the geometry variables
geo.ref_point=    [ACx 0 0];        %Position of the reference point in the aircraft coordinate system, moments are taken around this point
geo.CG=           [COG 0 0];        %Position of the center of gravity in the aircraft coordinate system. Rotations are made about this point
geo.c=            [Croot];          %Root chord of each wing
geo.b=            [bInner bOuter];  %Semispan of each partition of each wing
geo.symetric=     [1];              %Symmetry bit for each wing
geo.startx=       [0];              %X coordinate of each wing apex
geo.starty=       [0];              %Y coordinate of each wing apex
geo.startz=       [0];              %Z coordinate of each wing apex
geo.dihed=        [0 0];            %Dihedral of each partition of each wing [rad]                
geo.T=            [tInner tOuter];            %Taper ratio of each partition.
geo.SW=           [SwInner SwOuter];          %c/4 sweep of each partition. [rad]  
geo.TW(:,:,1)=    [0 0];         %Twist of partition inboard section
geo.TW(:,:,2)=    [0 0];          %Twist of partition outboard section

geo.nx=        [2 2];           %Number of panels in the X direction of each partiton
geo.ny=        [1 1];         %Number of panels in the Y direction of each partiton

geo.flapped=    [0 0];         %Partition flap bit. 1 for trailing edge flap (1 for trailing edge flap, 0 if no flap)
geo.fnx=        [0 0];          %Number of panels in the X direction of the flap of each partiton
geo.fsym=       [1 1];          %Control surface deflect symmetrically bit
geo.fc=         [0 0];          %Part of chord that is flapped of %each partition
geo.flap_vector= [0 0];         %Flap deflection, [rad] right hand positive outboard   

geo.foil(:,:,1)= [{airfoil} {airfoil}];     %Airfoil file inboard profile      
geo.foil(:,:,2)= [{airfoil} {airfoil}];      %Airfoil file outboard profile
               
geo.meshtype=    [1 1];                 %Type of mesh to be used          

%% Define the state %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state.AS=       10;        %Airspeed m/s
state.alpha = 0;            %Angle of attack, radians
state.betha=       0;         %Angle of sideslip, radians
state.P=       0;         %Rollrate, rad/s
state.Q=       0;         %pitchrate, rad/s
state.R=       0;         %yawrate, rad/s
state.adot=    0;         %Alpha time derivative rad/s
state.bdot=    0;         %Betha time derivative rad/s
state.ALT=       0;         %Altitude, m
state.rho=       1.225;     %Desity, kg/m^3
state.pgcorr=       1;         %Apply prandtl glauert compressibility correction

%% Determine required lift coefficient
CL_target = (2*mTotal*g)/(state.rho*(state.AS^2)*Stotal);

%% Run Tornado
[results,alpha]=fFindAlphaAtCL(geo,state,latticetype,CL_target);
    
%% Calculate objective function

F = w1*(results.CD / results.CL) + w2 * mTotal;


end