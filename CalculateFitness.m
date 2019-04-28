
function [Chromosome,Fitness,NumofCH,Totenergy]=CalculateFitness(PopulationSize,NumberOfNodes,Chromosome,Fitness,Sensor,Sink,ETX,ERX,Efs,Emp,EDA,do,NumofCH,Totenergy)

for IndividualCounter = 1:1:PopulationSize
    
    CHcount = 0;
    for SensorCounter = 1:1:NumberOfNodes 
         %Obtaining Total Direct Distance
        if(Chromosome(IndividualCounter,SensorCounter) ~= -1)
            if(Chromosome(IndividualCounter,SensorCounter) == 1)
                CHcount = CHcount + 1;
                TempCH(CHcount).X = Sensor(SensorCounter).X;
                TempCH(CHcount).Y = Sensor(SensorCounter).Y;
                TempCH(CHcount).ID = SensorCounter;
                TempCH(CHcount).CHDistance = 0;
                TempCH(CHcount).CH2BSDist =sqrt((Sensor(SensorCounter).X - Sink.X)^2 + (Sensor(SensorCounter).Y - Sink.Y)^2 );
                TempCH(CHcount).IndividualClustDist = 0;
           end;
        end;
        TempSensor(SensorCounter).AggEnergy = 0;
        TempSensor(SensorCounter).SendEnergy = 0;
    end;
    
%Obtaining J2 (Compactness)(Distance NCH to CH)
    Compactness = 0;
    Energy_NCH2CH = 0;
    Energy_Aggregation = 0;
    Transmissions = 0;
    for SensorCounter = 1:1:NumberOfNodes
        if(Chromosome(IndividualCounter,SensorCounter) == 0)  
            MinDistance = 100000000;
            
            ClusterOfMinDistance = 0;
            ID = 0;
            for TempCHCount = 1:1:CHcount
                temp = sqrt((Sensor(SensorCounter).X - TempCH(TempCHCount).X)^2 + (Sensor(SensorCounter).Y - TempCH(TempCHCount).Y)^2 );
                if (temp < MinDistance)
                MinDistance = temp;
                ClusterOfMinDistance = TempCHCount;
                 ID = TempCH(TempCHCount).ID;
                end;    
            end; 
                Compactness = Compactness + MinDistance; 
            
            if (CHcount>0)
              TempCH(ClusterOfMinDistance).CHDistance =  TempCH(ClusterOfMinDistance).CHDistance+MinDistance;
              
            end;    
             if(CHcount > 0)
                if (MinDistance > do)
                    TempEnergy_NCH2CH = ( ETX*(4000) + Emp*4000*( MinDistance^4));
                    Energy_NCH2CH = Energy_NCH2CH + TempEnergy_NCH2CH;
                else % (MinDistance <= do)
                    TempEnergy_NCH2CH = ( ETX*(4000) + Efs*4000*( MinDistance^2));
                    Energy_NCH2CH = Energy_NCH2CH + TempEnergy_NCH2CH;
                end; 
                if(Sensor(SensorCounter).Energy - TempEnergy_NCH2CH < 0)
                    Transmissions = Transmissions + 1;
                end;
               if(MinDistance > 0)
             %  if((CHcount > 0) && (MinDistance > 0))
                    Energy_Aggregation = Energy_Aggregation + ( (ERX + EDA)*4000 );
                    TempSensor(ID).AggEnergy = TempSensor(ID).AggEnergy + ( (ERX + EDA)*4000 );
                end;
            end;
        end;     
    end;
    
    
 
        
    %Obtaining CH Distance (Distance CH to Sink)
    CHDistance = 0;
    Energy_CH2Sink = 0;
   
    for SensorCounter = 1:1:NumberOfNodes 
        if(Chromosome(IndividualCounter,SensorCounter) == 1)
            Distance2BS = sqrt((Sensor(SensorCounter).X - Sink.X)^2 + (Sensor(SensorCounter).Y - Sink.Y)^2 );
            CHDistance = CHDistance + Distance2BS;
            if (Distance2BS > do)
                Energy_CH2Sink = Energy_CH2Sink + ((ETX+EDA)*(4000) + Emp*4000 *( Distance2BS ^ 4));
                TempSensor(SensorCounter).SendEnergy = ((ETX+EDA)*(4000) + Emp*4000 *( Distance2BS ^ 4));
            else
                Energy_CH2Sink = Energy_CH2Sink + ((ETX+EDA)*(4000)  + Efs*4000 *( Distance2BS ^ 2 )); 
                TempSensor(SensorCounter).SendEnergy = ((ETX+EDA)*(4000)  + Efs*4000 *( Distance2BS ^ 2 ));
            end;
            if(Sensor(SensorCounter).Energy - (TempSensor(SensorCounter).SendEnergy + TempSensor(SensorCounter).AggEnergy) < 0)
                Transmissions = Transmissions + 1;
            end;
        end;  
    end;
    

    
    TempCHDistanceCounter = 1;
    if (CHcount <= 1)
        Separation = 1;
    else
        for i = 1:1:CHcount - 1
            for j = i + 1:1:CHcount
                TempCHDistance(TempCHDistanceCounter) = sqrt((TempCH(i).X - TempCH(j).X)^2 + (TempCH(i).Y - TempCH(j).Y)^2 );
                TempCHDistanceCounter = TempCHDistanceCounter + 1;
            end;
        end;
       Separation = min(TempCHDistance);
    end
    %Obtaining Total Energy
    TotalEnergy = Energy_NCH2CH + Energy_Aggregation + Energy_CH2Sink;
    
%Fitness Calculation
Fitness(IndividualCounter) = Compactness / Separation ;%+ CHcount;
     NumofCH(IndividualCounter) = CHcount;
     Totenergy(IndividualCounter) =  TotalEnergy;
       
end;
