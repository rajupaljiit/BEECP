function [bestfit, averagefit,CHNum,STATISTICS]=start()

disp('Sensor Network Simulation starts.....');

[XMax, YMax, NumberOfNodes,OptimalElectionProbability,RoundMax] = InitializeWSN();

[Eo, ETX, ERX, Efs, Emp, EDA, do] = InitializeEnergyModel();

[Sensor,Sink] = SensorsDeployment();
[PopulationSize,MaxGen,Pc,Pm] = InitilizeEA();


%First Iteration

STATISTICS = [];
C = [];
X = [];
Y = [];

first_dead = -1;
Last_dead = -1;
flag_first_dead = 0;

StatisticCounter = 1;
RoundCounter = 0;
NetworkAlive = true;

bestfit = zeros(1,MaxGen);
averagefit = zeros(1,MaxGen);
CHNum = zeros(1,MaxGen);



while((RoundCounter <= RoundMax && NetworkAlive))
    
    RoundCounter
    
    figure(1);
    hold off;
    
    [STATISTICS, Sensor] = GetStatisticsOfWSN(Sensor, Sink, NumberOfNodes, ...
                                              STATISTICS,StatisticCounter, ...
                                              RoundCounter);
    
    %When the first node dies
    if (STATISTICS(StatisticCounter).DeadNodes >= 1)
        if(flag_first_dead == 0)
            first_dead = StatisticCounter; %  first_dead: the round where the first node died                   
            flag_first_dead = 1;
        end;
    end;
    
    
    if(STATISTICS(StatisticCounter).DeadNodes > 0)
            if(STATISTICS(StatisticCounter).DeadNodes == NumberOfNodes)
                  Last_dead = StatisticCounter; %  Last_dead: the round where the Last node died                   
                  NetworkAlive = false; %If all Nodes Died
            end;
    end;
        
    IsCluster = 0;  
    
    %Cluster-Head Election Phase
    [Sensor, STATISTICS,IsCluster,C, X, Y,bestfit,averagefit,CHNum] = ClusterHeadElection(PopulationSize,MaxGen,Pc,Pm,Sensor, Sink, ...
                                                        STATISTICS,StatisticCounter,IsCluster, ...
                                                        C, X, Y,...
                                                        NumberOfNodes, ...
                                                        OptimalElectionProbability, ...
                                                        ETX, ERX, Efs, Emp, EDA, do,RoundCounter,bestfit,averagefit,CHNum);
                                                    
    
    %Election of Associated Cluster Head for Normal Nodes %i.e. Connection
    %Establishment and Data Transmission phases (steady state phase)
     if(IsCluster == 1)
        [Sensor, STATISTICS] = ClusterHeadAssociation(Sensor, Sink, ...
                                                  STATISTICS, ...
                                                  StatisticCounter, ...
                                                  NumberOfNodes, ...
                                                  ETX, ERX, Efs, Emp, EDA, do, ...
                                                  C);
         for SensorCounter = 1:NumberOfNodes
             %Caliculation of Total Remaining Energy
             STATISTICS(StatisticCounter).RemainingEnergy = STATISTICS(StatisticCounter).RemainingEnergy + Sensor(SensorCounter).Energy;
         end;
    
    end;
    STATISTICS(StatisticCounter).RemainingEnergy
    hold on;
    %DrawVoronoiCell(X,Y, XMax, YMax);
    
    if(IsCluster == 1) 
        StatisticCounter = StatisticCounter+1;
    end 
    RoundCounter = RoundCounter + 1; 
end;
%save('m=0.2\STATISTIC_WSN15.mat','STATISTICS');
%save('m=0.2\FirsetDead_LastDead_WSN15.mat','first_dead','Last_dead');
%save('m=0.2','STATISTICS');
%save('m=0.2,'first_dead','Last_dead');

first_dead
len=length(STATISTICS);
len
Last_dead
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for r =1:1:len
%      deads(r) = STATISTICS(r).DeadNodes;
%      deadN(r) = STATISTICS(r).DeadNormalNodes;
%      deadA(r) = STATISTICS(r).DeadAdvancedNodes;
%      numCHS(r) = STATISTICS(r).ClusterHeads;
%      packettoCH(r) = STATISTICS(r).PACKETS_TO_CH ;
%      packettoBS(r) = STATISTICS(r).PACKETS_TO_BS;
%      energydissipat(r) = STATISTICS(r).DissipationEnergy;
%      residualenergy(r) = STATISTICS(r).RemainingEnergy;
% end;   
% %PLOT Statistics
% figure(2)
% r = 1:len ;
% subplot(2,2,1);
% plot(r,deads(r),'-r');
% legend('Jin et al',4)
% xlabel('no. of rounds');    
% ylabel('nodes dead');
% subplot(2,2,2);
% plot(r,deadN(r),'-r');
% legend('Jin et al',4);
% xlabel('no. of rounds');    
% ylabel('normal nodes dead');
% subplot(2,2,3);
% plot(r,deadA(r),'-r');
% legend('Jin et al',4);
% xlabel('no. of rounds');    
% ylabel('Advanced nodes dead');
% subplot(2,2,4);
% plot(r, numCHS(r),'-r');
% legend('Jin et al');
% xlabel('no. of rounds');    
% ylabel('cluster heads');
% 
% figure(3)
% r = 1:len ;
% subplot(2,2,1);
% plot(r,packettoCH(r),'-r');
% legend('Jin et al',4)
% xlabel('no. of rounds');    
% ylabel('Packets to CH');
% subplot(2,2,2);
% plot(r,packettoBS(r),'-r');
% legend('Jin et al',4);
% xlabel('no. of rounds');    
% ylabel('Packets to BS');
% subplot(2,2,3);
% plot(r, energydissipat(r) ,'-r');
% legend('Jin et al',4);
% xlabel('no. of rounds');    
% ylabel('Energy Dissipated');
% subplot(2,2,4);
% plot(r,  residualenergy(r),'-r');
% legend('Jin et al');
% xlabel('no. of rounds');    
% ylabel('Residual Energy');
% 
% figure(4)
% gen = 1:MaxGen;
% subplot(2,2,1);
% plot(gen,bestfit(gen),'-g');
% legend('HCR',4);
% xlabel('number of generations');    
% ylabel('bestfit');
% subplot(2,2,2);
% plot(gen,averagefit(gen),'-g');
% legend('HCR',4);
% xlabel('number of generations');    
% ylabel('averagefit');
% subplot(2,2,3);
% plot(gen,mindistance(gen),'-r');
% legend('HCR',4);
% xlabel('number of generations');    
% ylabel('Minimum Distance');
% subplot(2,2,4);
% plot(gen,CHNum(gen),'-r');
% legend('HCR',4);
% xlabel('number of generations');    
% ylabel('Number of CHS');
% 
% figure(5)
% gen = 1:MaxGen;
% %subplot(2,2,1);
% %plot(gen,sd_hcr(gen),'-g');
% %legend('HCR',4);
% %xlabel('number of generations');    
% %ylabel('Standard Deviation(minimum)');
% subplot(2,2,1);
% plot(gen,totenergy_hcr(gen),'-g');
% legend('HCR',4);
% xlabel('number of generations');    
% ylabel('Total Energy(Minimum)');

