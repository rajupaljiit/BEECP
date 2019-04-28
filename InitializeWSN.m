
function [XMax, YMax, NumberOfNodes, OptimalElectionProbability, RoundMax] = InitializeWSN()

% disp('netowrk parameters initialized')
%Field Dimensions - X and Y maximum (in meters)
YMax = 100;
XMax = 100;

%Number of Nodes in the field
NumberOfNodes = 100;

%The optimal number of constructed clusters
Kopt = sqrt(NumberOfNodes / (2 * pi))*(2 / 0.765);

%Optimal Election Probability of a node to become cluster head
OptimalElectionProbability = (Kopt / NumberOfNodes);

%maximum number of rounds
RoundMax = input('Input Nomber of Rounds   ');