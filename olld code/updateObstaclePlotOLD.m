function hObstacles = updateObstaclePlot(hObstacles, obstacles)
    if isvalid(hObstacles)
        % Update existing scatter plot object
        set(hObstacles, 'XData', obstacles.position(:, 1), 'YData', obstacles.position(:, 2), 'ZData', obstacles.position(:, 3));
    else
        % Recreate scatter plot object
        hObstacles = scatter3(obstacles.position(:, 1), obstacles.position(:, 2), obstacles.position(:, 3));
        hObstacles.SizeData = 100; % Adjust marker size as needed
        hObstacles.MarkerFaceColor = 'r';
        hObstacles.MarkerEdgeColor = 'k';
    end
end