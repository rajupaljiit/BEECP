function [AveCost] = ComputeAveCost(Chromosome,Fitness)

Cost = [];
for i = 1 : size(Chromosome,1)
    if Fitness(i) < inf
        Cost = [Cost Fitness(i)];
    end
end
% Compute average cost.
AveCost = mean(Cost);
return;