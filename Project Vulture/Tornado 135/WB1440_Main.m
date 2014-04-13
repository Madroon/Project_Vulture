%% WB1440 Student project
%
% Optimisation of a blended wing body concept aircraft using a VLM solver
%
% Last update:  18-3-201
% By:           Nick
% Changes:      Adapted below from studentbatch.m

%% Clear workspace
clc;
close all;
clear all;

%% Predefine design variables

Croot = 6; %Root chord of the aircraft

bInner = 1; %Inboard semispan
bOuter = 4; %Outboard semispan 

Tinner = 0.6;  %Inboard taper ratio
Touter = 0.5;   %Outboard taper ratio

SwInner = deg2rad(10);  %c/4 sweep of the inboard section
SwOuter = deg2rad(30);  %c/4 sweep of the outboard section


%% Call Solver
[geo,state] =  WB1440_Solver(COG,Croot,bInner,bOuter,Tinner,Touter,SwInner,SwOuter);

%% Tornado Computation


%  Plot the geometry
geometryplot(lattice,geo,ref);
% bodyplot(body);

% Compute skin friction of wing system
[CD0_wing, results.Re, results.Swet, results.Vol,]=zeroliftdragpred(Mach,state.ALT,geo,ref);

% Summing up viscous drag
CD0 = sum(CD0_wing);
results.CD0=CD0;

% computing induced drag
  [results]=solver9(results,state,geo,lattice,ref);
  [results]=coeff_create3(results,lattice,state,ref,geo);
  CDi=results.CD;
  
  

  %% TRIMMING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trimaxis=2;     %Trim in pitch
% trimwing=2;     %Trim with stabiliser
% trimrudder=0;   %Dont trim with elevator
% solvertype=1;   %Standard VLM
% weight=100;     %Aircraft weight
% 
% 
% 
% [results,rudderangle,state,engine,converged]=fTrimCLconstEW(geo,state,trimaxis,trimwing,trimrudder,solvertype,engine,weight,results)
  
            
     
 
     
 