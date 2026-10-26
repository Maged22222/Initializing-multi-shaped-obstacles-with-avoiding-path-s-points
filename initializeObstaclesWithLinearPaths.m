function obstacles = initializeObstaclesWithLinearPaths(startPoints, endPoints, obstacleRadius, realSpeed)
    numObstacles = size(startPoints, 1);
    
    distances = vecnorm(endPoints - startPoints, 2, 2); 
    directions = (endPoints - startPoints) ./ distances;
    velocities = directions .* realSpeed;
    
    % Initialize obstacles
    obstacles.position = startPoints;
    obstacles.endPoints = endPoints;
    obstacles.velocity = velocities;
    obstacles.radius = obstacleRadius * ones(numObstacles, 1);
end