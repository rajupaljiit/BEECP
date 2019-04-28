%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Raju Pal
%Jaypee Institute of Information Technology, Noida, UP, India



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






function [Chromosome,Fitness,CHNum] = BBO(ProbFlag,Fitness,PopulationSize,NumberOfNodes,Chromosome,Sensor,Sink,ETX,ERX,Efs,Emp,EDA,do,NumofCH,Totenergy)

if ~exist('ProbFlag', 'var')
    ProbFlag = true;
end
pmodify = 1; % habitat modification probability
pmutate = 0.5; % initial mutation probability

Keep = 2; % elitism parameter: how many of the best habitats to keep from one generation to the next
lambdaLower = 0.0; % lower bound for immigration probabilty per gene
lambdaUpper = 1; % upper bound for immigration probabilty per gene
dt = 1; % step size used for numerical integration of probabilities
I = 1; % max immigration rate for each island
E = 1; % max emigration rate, for each island
P = PopulationSize; %max species count, for each island

for j = 1 : size(Chromosome,1)
    Prob(j) = 1 / size(Chromosome,1);
end

% Begin the optimization loop
for GenIndex = 1 : 20
%     GenIndex
    % Sorting of population
    [Chromosome,indices,Fitness]=PopSort(Chromosome,Fitness);
    MinFitness = [Fitness(1)];
    % Compute the average cost
   [AverageFitness] = ComputeAveCost(Chromosome,Fitness);
    AvgFitness = [AverageFitness];
    % Save the best habitats in a temporary array.
    for j = 1 : Keep
        chromKeep(j,:) = Chromosome(j,:);
        costKeep(j) = Fitness(j);
    end
    
    % Map cost values to species counts.
    
    for i = 1 : size(Chromosome,1)
        if Fitness(i)< inf
            SpeciesCount(i) = P - i;
        else
            SpeciesCount(i) = 0;
        end
    end

    % Compute immigration rate and emigration rate for each species count.
    for i = 1 : size(Chromosome,1)
        lambda(i) = I * (1 - SpeciesCount(i) / P);
        mu(i) = E * SpeciesCount(i) / P;
    end
    
    if ProbFlag
        % Compute the time derivative of Prob(i) for each habitat i.
        for j = 1 : size(Chromosome,1)
            
            lambdaMinus = I * (1 - (SpeciesCount(j) - 1) / P);
            muPlus = E * (SpeciesCount(j) + 1) / P;
            if j < size(Chromosome,1)
                ProbMinus = Prob(j+1);
            else
                ProbMinus = 0;
            end
            if j > 1
                ProbPlus = Prob(j-1);
            else
                ProbPlus = 0;
            end
            ProbDot(j) = -(lambda(j) + mu(j)) * Prob(j) + lambdaMinus * ProbMinus + muPlus * ProbPlus;
        end
        % Compute the new probabilities for each species count.
        Prob = Prob + ProbDot * dt;
        Prob = max(Prob, 0);
        Prob = Prob / sum(Prob);
    end
    % Now use lambda and mu to decide how much information to share between habitats.
    lambdaMin = min(lambda);
    lambdaMax = max(lambda);
    for k = 1 : size(Chromosome,1)
        if rand > pmodify
            continue;
        end
        % Normalize the immigration rate.
        lambdaScale = lambdaLower + (lambdaUpper - lambdaLower) * (lambda(k) - lambdaMin) / (lambdaMax - lambdaMin);
        % Probabilistically input new information into habitat i
        for j = 1 : NumberOfNodes
            if (Chromosome(k,j) ~= -1) && rand < lambdaScale
                % Pick a habitat from which to obtain a feature
                RandomNum = rand * sum(mu);
                Select = mu(1);
                SelectIndex = 1;
                while (RandomNum > Select) && (SelectIndex < PopulationSize)
                    SelectIndex = SelectIndex + 1;
                    Select = Select + mu(SelectIndex);
                end
                Chromosome(k,j) = Chromosome(SelectIndex,j);
            else
                Chromosome(k,j) = Chromosome(k,j);
            end
        end
    end
    if ProbFlag
        % Mutation
        Pmax = max(Prob);
        MutationRate = pmutate * (1 - Prob / Pmax);
        
        % Sorting of population
        [Chromosome,indices,Fitness]=PopSort(Chromosome,Fitness);
        
        % Mutate only the worst half of the solutions
        for k = 1 : size(Chromosome,1)
            for parnum = 1 : NumberOfNodes
                if (Chromosome(k,parnum) ~= -1) && MutationRate(k) > rand
                    if( Chromosome(k,parnum) == 0)
                        Chromosome(k,parnum)= 1;
                    else
                        Chromosome(k,parnum) = 0;
                    end
                end
            end
        end
        
        
        [Chromosome,Fitness,NumofCH,Totenergy] = CalculateFitness(PopulationSize,NumberOfNodes,Chromosome,Fitness,Sensor,Sink,ETX,ERX,Efs,Emp,EDA,do,NumofCH,Totenergy);
        mincount =min(NumofCH);
        CHNum(GenIndex) = mincount;
        
        
        
        % Sorting of population
        [Chromosome,indices,Fitness]=PopSort(Chromosome,Fitness);
        
        % Replace the worst with the previous generation's elites.
        n = size(Chromosome,1);
        for k = 1 : Keep
            Chromosome(n-k+1,:) = chromKeep(k,:);
            Fitness(n-k+1) = costKeep(k);
        end
        % Sorting of population
        [Chromosome,indices,Fitness]=PopSort(Chromosome,Fitness);
        
        % Compute the average cost
        [AverageFitness] = ComputeAveCost(Chromosome,Fitness);
        
        % Display info to screen
        MinFitness = [MinFitness Fitness(1)];
        AvgFitness = [AvgFitness AverageFitness];

%          disp(['The best and mean of Generation # ', num2str(GenIndex), ' are ',...
%              num2str(MinFitness(end)), ' and ', num2str(AvgFitness(end))]);
        
    end
end