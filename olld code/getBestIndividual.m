function bestIndividual = getBestIndividual(population, goalPoint, obstacles, penaltyFactor)
    % Initialize variables
    bestFitness = Inf;
    bestIndividual = [];
 penaltyFactor = 1.1;
    % Evaluate fitness for each individual in the population
    for i = 1:numel(population)
        individual = population(i).position;

        % Check for collision with obstacles
        if checkCollision(individual, obstacles)
            % Adjust path generation process to avoid obstacles
            individual = adjustPath(individual, obstacles);
        end

        % Evaluate fitness with penalty factor
        fitness = evaluateFitness(individual, goalPoint, obstacles, penaltyFactor);

        % Update best individual if current fitness is better
        if fitness < bestFitness
            bestFitness = fitness;
            bestIndividual = individual;
        end
    end
end
