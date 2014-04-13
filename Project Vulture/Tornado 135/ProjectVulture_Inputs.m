% Project Vulture - Inputs

%% 

% Airfoils to be used
airfoil_wing = 'EPP662.DAT';

% Weights and reference for the multi-objective function
w1 = 1;
w2 = 1;
mRef = 0.75;
glideRef = 1/10;

% Weight of the aircraft
rho = 1050; % [kg/m^3] 'density' of the volume, note density styrofoam = 1000 [kg/m^3]
mPayload = 0.3; % 300 gram payload

% Gravitational constant
g = 9.816;

% Lattice for the solver 1 = standard horseshoe
latticetype = 1;

% Positions of the reference points
COG = 0.1; %Reference center of gravity position
ACx = 0.25; %Aerodynamic center x position (along chord)

% Viscous drag prediction
CD_viscous = 0.02;

%% Scalings/Initial design point
I(1) = 0.5;
I(2) = 0.5;
I(3) = 0.1;
I(4) = 0.5;
I(5) = 0.5;
I(6) = 30*pi/180;
I(7) = 50*pi/180;
I(8) = 90*pi/180;
I(9) = 1*pi/180; 
I = I';

%% Define the state %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state.AS=       20;        %Airspeed m/s
state.betha=       0;         %Angle of sideslip, radians
state.P=       0;         %Rollrate, rad/s
state.Q=       0;         %pitchrate, rad/s
state.R=       0;         %yawrate, rad/s
state.adot=    0;         %Alpha time derivative rad/s
state.bdot=    0;         %Betha time derivative rad/s
state.ALT=       0;         %Altitude, m
state.rho=       1.225;     %Desity, kg/m^3
state.pgcorr=       1;         %Apply prandtl glauert compressibility correction