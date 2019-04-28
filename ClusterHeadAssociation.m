function [Sensor, STATISTICS] = ClusterHeadAssociation(Sensor, Sink, ...
                                                  STATISTICS, ...
                                                  StatisticCounter, ...
                                                  NumberOfNodes, ...
                                                  ETX, ERX, Efs, Emp, EDA, do, ...
                                                  C)
%        disp('ClusterHeadAssociation');                                       
for SensorCounter = 1:NumberOfNodes
    if (Sensor(SensorCounter).Type == 'N' && Sensor(SensorCounter).Energy > 0 && (STATISTICS(StatisticCounter).ClusterHeads) >= 1)
        MinDistance = sqrt( (Sensor(SensorCounter).X -  Sink.X)^2 + (Sensor(SensorCounter).Y -  Sink.Y)^2 );
        ClusterOfMinDistance = 1;
        for ClusterCounter = 1:STATISTICS(StatisticCounter).ClusterHeads
            Temp = min(MinDistance, sqrt((Sensor(SensorCounter).X - C(ClusterCounter).X)^2 + (Sensor(SensorCounter).Y - C(ClusterCounter).Y)^2 ));
            if (Temp < MinDistance)
                MinDistance = Temp;
                ClusterOfMinDistance = ClusterCounter;
            end;
        end;
        if (MinDistance > do)
                Sensor(SensorCounter).Energy = Sensor(SensorCounter).Energy - ( ETX*(4000) + Emp*4000*( MinDistance^4)); 
                STATISTICS(StatisticCounter).DissipationEnergy = STATISTICS(StatisticCounter).DissipationEnergy +( ETX*(4000) + Emp*4000*( MinDistance^4));
        
        else % (MinDistance <= do)
                Sensor(SensorCounter).Energy = Sensor(SensorCounter).Energy - ( ETX*(4000) + Efs*4000*( MinDistance^2)); 
                STATISTICS(StatisticCounter).DissipationEnergy = STATISTICS(StatisticCounter).DissipationEnergy +( ETX*(4000) + Efs*4000*( MinDistance^2));
        end;
        if(MinDistance > 0)
           Sensor(C(ClusterOfMinDistance).ID).Energy = Sensor(C(ClusterOfMinDistance).ID).Energy - ( (ERX + EDA)*4000 );
           STATISTICS(StatisticCounter).DissipationEnergy = STATISTICS(StatisticCounter).DissipationEnergy +( (ERX+EDA)*4000 );         
        end;

        Sensor(SensorCounter).MinDistance = MinDistance;
        Sensor(SensorCounter).ClusterOfMinDistance = ClusterOfMinDistance;
    end;
end;
STATISTICS(StatisticCounter).PACKETS_TO_CH = NumberOfNodes - STATISTICS(StatisticCounter).DeadNodes - STATISTICS(StatisticCounter).ClusterHeads;
                                              
                                              
