% Project Vulture - Aerodynamic solver

function [results] =  ProjectVulture_Aero(X)

%% Input constants
ProjectVulture_Inputs;
results = [];

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
mWing = X(10);

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
COG = ((ref.mac_pos(1) + COG * ref.C_mac)*mWing + mPayload*xPayload*Croot)/(mWing + mPayload);

geo.ref_point=    [ACx 0 0];        %Position of the reference point in the aircraft coordinate system, moments are taken around this point
geo.CG=           [COG 0 0];        %Position of the center of gravity in the aircraft coordinate system. Rotations are made about this point


%% Computing viscous drag
%Sinner = ((Croot + Ctrans)/2) * bInner;
%Souter = ((Ctrans + Ctip)/2) * bOuter;
%Stotal = Sinner + Souter;
%D_viscous = 0.5 * CD_viscous * state.rho * Stotal * state.AS^2;

%% computing induced drag
  [results]=solver9(results,state,geo,lattice,ref);
  [results]=coeff_create3(results,lattice,state,ref,geo);
