
function [Sensor,Sink] = SensorsDeployment()
disp('SensorsDeployment')
%Load the WSN From The Corresponding Path
%load('m=0.1\WSN_0.1\WSN1', 'Sensor');
m =0.1;%percentage of advanced nodes
n =100; %number of nodes
Eo=0.5;
a=1;
for i=1:1:100
    Sensor(i).X=rand(1,1)*n;
   % XR(i)=S(i).xd;
    Sensor(i).Y=rand(1,1)*n;
   % YR(i)=S(i).yd;
    Sensor(i).G=0;
    %initially there are no cluster heads only nodes
   Sensor(i).type='N';
   
    temp_rnd0=i;
    %Random Election of Normal Nodes
    if (temp_rnd0>=m*n+1) 
        Sensor(i).Energy=Eo;
        Sensor(i).EnergyType=0;
        %plot(S(i).xd,S(i).yd,'o');
        %hold on;
    end
    %Random Election of Advanced Nodes
    if (temp_rnd0<m*n+1)  
        Sensor(i).Energy=Eo*(1+a);
        Sensor(i).EnergyType=1;
        %plot(S(i).xd,S(i).yd,'+');
        %hold on;
    end
end
Sink.X = 50;
Sink.Y = 50;