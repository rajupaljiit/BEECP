
function [STATISTICS, Sensor] = GetStatisticsOfWSN(Sensor, Sink, NumberOfNodes, ...
                                                   STATISTICS,StatisticCounter, ...
                                                   RoundCounter)
% disp('GetStatisticsOfWSN');
%Counter For Dead nodes ,dead advanced nodes, and dead normal nodes
STATISTICS(StatisticCounter).DeadNodes = 0;
STATISTICS(StatisticCounter).DeadAdvancedNodes = 0;
STATISTICS(StatisticCounter).DeadNormalNodes = 0;

%Number of Cluster Heads:Normal Cluster Heads,Advanced Cluster Heads
STATISTICS(StatisticCounter).ClusterHeads = 0;
STATISTICS(StatisticCounter).NormalClusterHeads = 0;
STATISTICS(StatisticCounter).AdvancedClusterHeads = 0;

%counter for packets transmitted to Bases Station and to Cluster Heads 
%per round
STATISTICS(StatisticCounter).PACKETS_TO_CH = 0;
STATISTICS(StatisticCounter).PACKETS_TO_BS = 0;

%Counter For Total Dissipated and Remaining Energy
STATISTICS(StatisticCounter).DissipationEnergy = 0;
STATISTICS(StatisticCounter).RemainingEnergy = 0;

for SensorCounter = 1:NumberOfNodes
    %checking if there is a dead node
    if (Sensor(SensorCounter).Energy <= 0)
        STATISTICS(StatisticCounter).DeadNodes = STATISTICS(StatisticCounter).DeadNodes + 1;
        if (Sensor(SensorCounter).EnergyType == 1)
            plot (Sensor(SensorCounter).X, Sensor(SensorCounter).Y, '+r');%Dead Advanced Nodes

            STATISTICS(StatisticCounter).DeadAdvancedNodes = STATISTICS(StatisticCounter).DeadAdvancedNodes + 1;
        end;
        if (Sensor(SensorCounter).EnergyType == 0)
            plot (Sensor(SensorCounter).X, Sensor(SensorCounter).Y, 'vr');%Dead Normal Nodes

            STATISTICS(StatisticCounter).DeadNormalNodes = STATISTICS(StatisticCounter).DeadNormalNodes + 1;
        end;
        hold on; 
    else  % (Sensor(SensorCounter).Energy > 0)
        Sensor(SensorCounter).Type = 'N';
        if (Sensor(SensorCounter).EnergyType == 1)
            plot (Sensor(SensorCounter).X, Sensor(SensorCounter).Y, '+k');%Alive Advanced Node
        else % if (Sensor(SensorCounter).EnergyType == 0)
            plot (Sensor(SensorCounter).X, Sensor(SensorCounter).Y, '^g');%Alive Normal Node
        end;
        hold on; 
    end;
    
end;
 plot(Sink.X,Sink.Y,'ob','MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',6);%Sink
 hold on;
 