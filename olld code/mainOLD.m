
    % Simulation parameters
    startPoint = [1, 1, 1];
    goalPoint = [50, 50, 50];
    numObstacles = 5;
    obstacleRadius = 20;
    penaltyFactor = 1.1;
    maxObstacleVelocity = 2;
    populationSize = 100;
    maxGenerations = 50;
    crossoverRate = 0.8;
    mutationRate = 0.1;
    maxPosition = [100, 100, 100];
    maxX = 300;
    maxY = 300;
    maxZ = 300;
    maxTimeSteps = 200;

    % Initialize obstacles and population
    obstacles = initializeObstacles(numObstacles, maxPosition, maxObstacleVelocity, obstacleRadius);
    population = initializePopulation(populationSize, maxPosition);

    % Initialize visualization
    figure;
    hObstacles = plotObstaclesOLD(obstacles);
    xlim([0, maxX]);
    ylim([0, maxY]);
    zlim([0, maxZ]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;

    % Initialize best individual and path plot
    bestIndividual = [];
    hPath = plot3(startPoint(1), startPoint(2), startPoint(3), 'g-', 'LineWidth', 2);

    % Real-time simulation loop
    for t = 1:maxTimeSteps
        % Update obstacle positions (simulate movement in real-time)
        obstacles = updateObstaclesOLD(obstacles);

        % Update obstacle plot in real-time
        updateObstaclePlotOLD(hObstacles, obstacles);

        % Perform genetic algorithm operations (selection, crossover, mutation)
        selectedPopulation = selection(population);
        offspringPopulation = crossoverAndMutate(selectedPopulation, crossoverRate, mutationRate);
     
        population.position = offspringPopulation.position.position;
        population.fitness = offspringPopulation.position.fitness;
        % Get best individual and update path plot in real-time
        bestIndividual = getBestIndividual(population, goalPoint, obstacles);
        

        % Check termination criteria (e.g., max time steps)
        if t == maxTimeSteps
            break;
        end

        % Pause for real-time appearance
        pause(0.1); % Adjust time interval as needed
    end


function path = generatePath(bestIndividual, startPoint, hPath)
    % Generate the path based on individual's positions and starting point
    path = [startPoint; bestIndividual];
    updatePathPlot(hPath, path);
end
