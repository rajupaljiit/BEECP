function [Chromosome, indices,Fitness] = PopSort(Chromosome,Fitness)
	popsize = size(Chromosome,1);
	NumberOfNodes=100;
	Cost = zeros(1, popsize);
	indices = zeros(1, popsize);
	for i = 1 : popsize
	    Cost(i) = Fitness(i);
	end
	[Cost, indices] = sort(Cost, 2, 'ascend');
	Chroms = zeros(popsize, NumberOfNodes);
	for i = 1 : popsize
	    Chroms(i, :) = Chromosome(indices(i),:);
	end
	for i = 1 : popsize
	    Chromosome(i,:) = Chroms(i, :);
	    Fitness(i,:) = Cost(i);
	end


end