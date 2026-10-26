function fitness = evaluateFitness(individual, goalPoint, obstacles, penaltyFactor)
    % Get the last point in the path
    lastPoint = individual(end, :);

    % Calculate the Euclidean distance to the goal point
    fitness = norm(lastPoint - goalPoint);

    % Check for collision with obstacles
    if checkCollision(individual, obstacles)
        % Apply penalty by multiplying fitness with penalty factor
        fitness = fitness * penaltyFactor;
    end
end
