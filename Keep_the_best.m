function [Chromosome,Fitness] = Keep_the_best(PopulationSize, NumberOfNodes, Fitness, Chromosome)
Fitness(PopulationSize) = 1000000;
cur_best = 1;
for i=1:1:PopulationSize-1
    if (Fitness(i)< Fitness(PopulationSize))
        Fitness(PopulationSize) = Fitness(i);
        cur_best=i;
    end;
end;
    for i=1:1:NumberOfNodes
        Chromosome(PopulationSize,i) = Chromosome(cur_best,i);
    end;

    