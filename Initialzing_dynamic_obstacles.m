%% Settings
% Define start and end coordinates for obstacles
startPoints = [   5, 4, 4;14, 11, 6; 8, 6, 0;10 ,9 ,0;];
endPoints = [  3, 14, 1 ;6, 3, 3; 10, 10, 5;10 ,9 ,9;];

obstacle_num = 1; % number of obstcles
startPoints = startPoints(1:obstacle_num, :);
endPoints = endPoints(1:obstacle_num, :);

obstacleRadius = 0.9;
maxObstacleVelocity = 4;
numPointsThet = 10; % it Means 9 around the obstacle
numPointsPhi = 7; % it Means 5 level of points around the obstacles
Safty_Distance = 0.6;

obstacleType = 'complex'; % 'sphere', 'complex', 'ellipsoid', 'cylinder', 'box'

% Initialize obstacles with linear paths
switch lower(obstacleType)
    case 'sphere'
        obstacles = initializeObstaclesWithLinearPaths(startPoints, endPoints, obstacleRadius, maxObstacleVelocity);
    case 'complex'
        obstacles = generateComplexObstacles(startPoints, endPoints, obstacleRadius, maxObstacleVelocity, numPointsThet, numPointsPhi, Safty_Distance);
    case 'ellipsoid'
        obstacles = generateEllipsoidObstacles(startPoints, endPoints, obstacleRadius, maxObstacleVelocity, numPointsThet, numPointsPhi, Safty_Distance);
    case 'cylinder'
        obstacles = generateCylinderObstacles(startPoints, endPoints, obstacleRadius, maxObstacleVelocity, numPointsThet, numPointsPhi, Safty_Distance);
    case 'box'
        obstacles = generateBoxObstacles(startPoints, endPoints, obstacleRadius, maxObstacleVelocity, numPointsThet, numPointsPhi, Safty_Distance);
    otherwise
        error('Unknown obstacle type: %s', obstacleType);
end

totalDistances = vecnorm(endPoints - startPoints, 2, 2);

numIterations = 50;
dt = 0.05;
%% main code
% Plot Dynamic simulation
for iter = 1:numIterations
    [pointsAroundObstacles, bolean_Points] = calculatePointsAroundObstacles(obstacles, numPointsThet, numPointsPhi, Safty_Distance);
    Display_Obstacles(obstacles, pointsAroundObstacles, iter, bolean_Points);

    for i = 1:obstacle_num
        newPos = obstacles.position(i, :) + obstacles.velocity(i, :) * dt;
        distFromStart = norm(newPos - startPoints(i, :));
        distFromEnd = norm(newPos - endPoints(i, :));

        if distFromStart > totalDistances(i)
            obstacles.position(i, :) = endPoints(i, :);
            obstacles.velocity(i, :) = -obstacles.velocity(i, :);
        elseif distFromEnd > totalDistances(i)
            obstacles.position(i, :) = startPoints(i, :);
            obstacles.velocity(i, :) = -obstacles.velocity(i, :);
        else
            obstacles.position(i, :) = newPos;
        end
    end

    pause(0.02);
end
