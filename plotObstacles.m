function plotObstacles(obstacles)
    isComplex = isfield(obstacles, 'shape') && ~isempty(obstacles.shape);

    if ~isComplex
        [X, Y, Z] = sphere(20);
    end

    for i = 1:size(obstacles.position, 1)
        if isComplex
            X = obstacles.shape{i}.xRel;
            Y = obstacles.shape{i}.yRel;
            Z = obstacles.shape{i}.zRel;
            surf(obstacles.position(i, 1) + X, ...
                 obstacles.position(i, 2) + Y, ...
                 obstacles.position(i, 3) + Z, ...
                 'FaceColor', 'k', 'EdgeColor', 'none', 'FaceAlpha', 1.0, ...
                 'HandleVisibility', 'off');
        else
            surf(obstacles.position(i, 1) + obstacles.radius(i) * X, ...
                 obstacles.position(i, 2) + obstacles.radius(i) * Y, ...
                 obstacles.position(i, 3) + obstacles.radius(i) * Z, ...
                 'FaceColor', 'k', 'EdgeColor', 'none', 'FaceAlpha', 1.0, ...
                 'HandleVisibility', 'off');
        end
    end

    plot3(obstacles.position(:, 1), obstacles.position(:, 2), obstacles.position(:, 3), ...
          'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'DisplayName', 'Obstacle Centers');

    if isfield(obstacles, 'velocity') && ~isempty(obstacles.velocity)
        arrow_length = 1.5;
        for i = 1:size(obstacles.position, 1)
            v = obstacles.velocity(i, :);
            v_norm = norm(v);
            if v_norm > 0
                dir = v / v_norm;
                if i == 1
                    quiver3(obstacles.position(i, 1), obstacles.position(i, 2), obstacles.position(i, 3), ...
                            dir(1)*arrow_length, dir(2)*arrow_length, dir(3)*arrow_length, ...
                            0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Velocity Vector');
                else
                    quiver3(obstacles.position(i, 1), obstacles.position(i, 2), obstacles.position(i, 3), ...
                            dir(1)*arrow_length, dir(2)*arrow_length, dir(3)*arrow_length, ...
                            0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'HandleVisibility', 'off');
                end
            end
        end
    end
end
