function hObstacles = plotObstacles(obstacles)
    % Plot obstacles in the 3D space
    hObstacles = scatter3(obstacles.position(:, 1), obstacles.position(:, 2), obstacles.position(:, 3));
    
    % Customize plot appearance (e.g., color, size)
    hObstacles.SizeData = 100; % Adjust marker size as needed
    hObstacles.MarkerFaceColor = 'r';
    hObstacles.MarkerEdgeColor = 'k';
end