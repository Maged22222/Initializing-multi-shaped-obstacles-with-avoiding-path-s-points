function [pointsAroundObstacles, Non_realpointsAroundObstacles] = calculatePointsAroundObstacles(obstacles, numPointsTheta, numPointsPhi, radiusOffset)

    theta = linspace(0, 2*pi, numPointsTheta);
    phi = linspace(0, pi, numPointsPhi);
    [Theta, Phi] = meshgrid(theta, phi);

    pointsAroundObstacles = [];
    Non_realpointsAroundObstacles = zeros(numPointsTheta*numPointsPhi, size(obstacles.position, 1));
    isComplex = isfield(obstacles, 'shape') && ~isempty(obstacles.shape);

    for i = 1:size(obstacles.position, 1)
        centerX = obstacles.position(i, 1);
        centerY = obstacles.position(i, 2);
        centerZ = obstacles.position(i, 3);

        if isComplex
            xSphere = centerX + obstacles.shape{i}.xSafeRel;
            ySphere = centerY + obstacles.shape{i}.ySafeRel;
            zSphere = centerZ + obstacles.shape{i}.zSafeRel;
        else
            radius = obstacles.radius(i) + radiusOffset;
            xSphere = centerX + radius * sin(Phi) .* cos(Theta);
            ySphere = centerY + radius * sin(Phi) .* sin(Theta);
            zSphere = centerZ + radius * cos(Phi);
        end

        pointsAroundObstacles = [pointsAroundObstacles; xSphere(:), ySphere(:), zSphere(:)];
        points = [xSphere(:), ySphere(:), zSphere(:)];

        [~, ~, repeatedIdx] = findRepeatedPoints(points, 1e-5);
        Non_realpointsAroundObstacles(1:size(repeatedIdx, 1), i) = repeatedIdx + (numPointsTheta*numPointsPhi*(i-1));
    end
end
