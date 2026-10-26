function obstacles = updateObstacles(obstacles, timeStep)
    % Update obstacle positions along defined paths

    % Define the start and end coordinates for each obstacle
    startCoordinates = [10, 10, 10; 20, 20, 20; 30, 30, 30; 40, 40, 40; 50, 50, 50]; % Example start coordinates
    endCoordinates = [30, 30, 30; 40, 50, 80; 50, 90, 30; 60, 90, 60; 70, 50, 50]; % Example end coordinates

    % Calculate the movement vector for each obstacle based on start and end coordinates
    numObstacles = size(obstacles.position, 1);
    for i = 1:numObstacles
        % Get the start and end coordinates for the obstacle
        startCoord = startCoordinates(i, :);
        endCoord = endCoordinates(i, :);

        % Calculate the movement vector from start to end coordinates
        movementVector = (endCoord - startCoord) / norm(endCoord - startCoord);

        % Update obstacle position along the movement vector
        currentPosition = obstacles.position(i, :);
        newPosition = currentPosition + movementVector;

        % Update obstacle position
        obstacles.position(i, :) = newPosition;
    end
end
