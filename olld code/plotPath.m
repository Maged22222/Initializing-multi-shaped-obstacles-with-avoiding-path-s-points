function hPath = plotPath(startPoint, goalPoint)
    % Plot the initial path between start and goal points
    startPoint = [1, 1, 1]; % Example value, adjust as needed
goalPoint = [50, 50, 50]; % Example value, adjust as needed
    path = [startPoint; goalPoint];
    hPath = plot3(path(:, 1), path(:, 2), path(:, 3), '-b', 'LineWidth', 2);
end