% Project Vulture - Inputs

%% 

% Airfoils to be used
airfoil_wing = 'EPP662.DAT';

% Weights and reference for the multi-objective function
w1 = 4; %importance of glide ratio
w2 = 1; %importance of weight
mRef = 2.5;
glideRef = 1/10;

% Weight of the aircraft
rho = 1100; % [kg/m^3] 'density' of the volume, note density styrofoam = 1000 [kg/m^3]
mPayload = 2.50; % kg payload
xPayload = 0.25; % payload position measured from the nose % of root chord

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
I(1) = 1.0;
I(2) = 1.0;
I(3) = 1.0;
I(4) = 1.0;
I(5) = 1.0;
I(6) = 90*pi/180;
I(7) = 90*pi/180;
I(8) = 90*pi/180;
I(9) = 1*pi/180; 
I(10) = 1.0;
I = I';

%% Define the state %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
state.AS=       25;        %Airspeed m/s
state.betha=       0;         %Angle of sideslip, radians
state.P=       0;         %Rollrate, rad/s
state.Q=       0;         %pitchrate, rad/s
state.R=       0;         %yawrate, rad/s
state.adot=    0;         %Alpha time derivative rad/s
state.bdot=    0;         %Betha time derivative rad/s
state.ALT=       0;         %Altitude, m
state.rho=       1.225;     %Desity, kg/m^3
state.pgcorr=       1;         %Apply prandtl glauert compressibility correction