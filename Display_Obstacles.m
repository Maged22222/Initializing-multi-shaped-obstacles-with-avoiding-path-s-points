function Display_Obstacles(obstacles, pointsAroundObstacles, iter, bolean_Points)

    if nargin < 3
        iter = [];
    end
    if nargin < 4
        bolean_Points = [];
    end

    clf;
    hold on;

    if ~isempty(obstacles) && isfield(obstacles, 'position')
        plotObstacles(obstacles);
    end

    if ~isempty(pointsAroundObstacles)
        if ~isempty(bolean_Points) && length(bolean_Points) == size(pointsAroundObstacles, 1)
            validPts = pointsAroundObstacles(bolean_Points == 0, :);
        else
            validPts = pointsAroundObstacles;
        end

        plot3(validPts(:, 1), validPts(:, 2), validPts(:, 3), ...
              'b.', 'MarkerSize', 8, 'DisplayName', 'Surrounding Points');
    end

    grid on;
    axis equal;
    xlabel('Distance along X-axis');
    ylabel('Distance along Y-axis');
    zlabel('Distance along Z-axis');

    if ~isempty(iter)
        title(sprintf('Dynamic Obstacles Simulation (Iteration %d)', iter));
    else
        title('Dynamic Obstacles and Surrounding Points');
    end

    if ~isempty(pointsAroundObstacles)
        pad = 1.0;
        allCurrentPts = pointsAroundObstacles;
        if ~isempty(obstacles) && isfield(obstacles, 'position')
            allCurrentPts = [allCurrentPts; obstacles.position];
        end
        xlim([min(allCurrentPts(:, 1)) - pad, max(allCurrentPts(:, 1)) + pad]);
        ylim([min(allCurrentPts(:, 2)) - pad, max(allCurrentPts(:, 2)) + pad]);
        zlim([min(allCurrentPts(:, 3)) - pad, max(allCurrentPts(:, 3)) + pad]);
    end

    legend('Location', 'best');
    view(3);
    hold off;
    drawnow;
end
