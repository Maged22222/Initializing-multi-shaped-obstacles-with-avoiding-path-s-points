function offspringPopulation = crossoverAndMutate(selectedPopulation, crossoverRate, mutationRate)
    % Initialize offspring population with zeros
    offspringPopulation = struct('position', zeros(100, 3), 'fitness', zeros(100, 1));

    % Perform crossover for each pair of parents
    for i = 1:2:min(size(selectedPopulation, 1), 100) % Limit to 100 parents
        % Select parent individuals for crossover
        parent1 = selectedPopulation(i,:);
        
        % Check if there is a second parent available
        if i+1 <= size(selectedPopulation, 1)
            parent2 = selectedPopulation(i+1,:);
        else
            % If no second parent available, use parent1 again
            parent2 = parent1;
        end
        
        % Perform crossover with the given crossover rate
        if rand() <= crossoverRate
            crossoverPoint = randi([1, length(parent1) - 1]);  % Random crossover point
            offspring1.position = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
            offspring2.position = [parent2(1:crossoverPoint), parent1(crossoverPoint+1:end)];
        else
            offspring1.position = parent1;
            offspring2.position = parent2;
        end
        
        % Add offspring to the offspring population
        index = (i + 1) / 2;  % Compute index for inserting offspring
        offspringPopulation(index).position = reshape([offspring1.position; offspring2.position], 1, []);
        offspringPopulation(index).fitness = 0;  % Initialize fitness value, you can compute it as needed
    end
end
