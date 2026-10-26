function population = initializePopulation(populationSize, maxPosition)
    % Initialize population with random positions
    maxPosition = [100, 100, 100];
    populationSize = 100;
    population.position = rand(populationSize, 3) .* maxPosition;
    population.fitness = zeros(populationSize, 1);
end