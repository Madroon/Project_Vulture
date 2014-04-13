 function [F] =  ProjectVulture_Solver(X)
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
 %          X(8) = dihedralOuter
 % Output:  F scalar objective function
 
% Deconstruct input vector for easy reading
Croot   = X(1);
bInner  = X(2);
bOuter  = X(3);
tInner  = X(4);
tOuter  = X(5);
SwInner = X(6);
SwOuter = X(7);
dihedralOuter = X(8);

%% Input constants
ProjectVulture_Inputs;

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

%% Dimension calculations
Sinner = ((Croot + Ctrans)/2) * bInner;
Souter = ((Ctrans + Ctip)/2) * bOuter;
Stotal = Sinner + Souter;

%% Viscous drag prediction
D_viscous = 0.5 * CD_viscous * state.rho * Stotal * state.AS^2; 


%% Geometry definition

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
geo.dihed=        [0 dihedralOuter];            %Dihedral of each partition of each wing [rad]                
geo.T=            [tInner tOuter];            %Taper ratio of each partition.
geo.SW=           [SwInner SwOuter];          %c/4 sweep of each partition. [rad]  
geo.TW(:,:,1)=    [0 0];         %Twist of partition inboard section
geo.TW(:,:,2)=    [0 0];          %Twist of partition outboard section

geo.nx=        [3 3];           %Number of panels in the X direction of each partiton
geo.ny=        [3 3];         %Number of panels in the Y direction of each partiton

geo.flapped=    [0 0];         %Partition flap bit. 1 for trailing edge flap (1 for trailing edge flap, 0 if no flap)
geo.fnx=        [0 0];          %Number of panels in the X direction of the flap of each partiton
geo.fsym=       [1 1];          %Control surface deflect symmetrically bit
geo.fc=         [0 0];          %Part of chord that is flapped of %each partition
geo.flap_vector= [0 0];         %Flap deflection, [rad] right hand positive outboard   

geo.foil(:,:,1)= [{airfoil_wing} {airfoil_wing}];     %Airfoil file inboard profile      
geo.foil(:,:,2)= [{airfoil_wing} {airfoil_wing}];      %Airfoil file outboard profile
               
geo.meshtype=    [1 1];                 %Type of mesh to be used          


%% reposition the cog and reference

[lattice,ref]=fLattice_setup2(geo,state,latticetype);  
ACx = ref.mac_pos(1) + ACx * ref.C_mac;
COG = ref.mac_pos(1) + COG * ref.C_mac;

geo.ref_point=    [ACx 0 0];        %Position of the reference point in the aircraft coordinate system, moments are taken around this point
geo.CG=           [COG 0 0];        %Position of the center of gravity in the aircraft coordinate system. Rotations are made about this point

%% Determine required lift coefficient
CL_target = (2*mTotal*g)/(state.rho*(state.AS^2)*Stotal);

%% Run Tornado
[results,alpha]=fFindAlphaAtCL(geo,state,latticetype,CL_target);


%% Calculate objective function
mass = abs(1 - (mWing / mRef));
glide = abs(1 - (((results.CD+CD_viscous) / results.CL) / glideRef));
F = w1*glide + w2 * mass;


end