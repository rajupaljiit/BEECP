
function [Eo, ETX, ERX, Efs, Emp, EDA, do] = InitializeEnergyModel()
% disp('InitializeEnergyModel')
%Energy Model (all values in Joules)
%Initial Energy 
Eo = 0.5;

%Eelec=Etx=Erx
ETX = 50 * 0.000000001;
ERX = 50 * 0.000000001;

%Transmit Amplifier types
Efs = 10 * 0.000000000001;
Emp = 0.0013 * 0.000000000001;

%Data Aggregation Energy
EDA = 5 * 0.000000001;

%Computation of do % short distance
do = sqrt(Efs / Emp);