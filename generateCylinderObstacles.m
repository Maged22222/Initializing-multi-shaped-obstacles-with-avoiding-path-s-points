function obstacles = generateCylinderObstacles(startPoints, endPoints, baseRadius, realSpeed, numTheta, numPhi, safetyDistance)
    numObstacles = size(startPoints, 1);
    distances = vecnorm(endPoints - startPoints, 2, 2);
    directions = (endPoints - startPoints) ./ distances;
    velocities = directions .* realSpeed;

    theta = linspace(0, 2*pi, numTheta);
    phi = linspace(0, pi, numPhi);
    [Theta, Phi] = meshgrid(theta, phi);

    obstacles.position = startPoints;
    obstacles.endPoints = endPoints;
    obstacles.velocity = velocities;
    obstacles.baseRadius = baseRadius * ones(numObstacles, 1);
    obstacles.safetyDistance = safetyDistance;
    obstacles.Theta = Theta;
    obstacles.Phi = Phi;
    obstacles.shape = cell(numObstacles, 1);

    for i = 1:numObstacles
        r = baseRadius * (0.8 + 0.4 * rand());
        h = baseRadius * (1.2 + 0.6 * rand());

        z = h * (1 - 2 * Phi / pi);

        obstacles.shape{i}.xRel = r .* cos(Theta);
        obstacles.shape{i}.yRel = r .* sin(Theta);
        obstacles.shape{i}.zRel = z;

        rSafe = r + safetyDistance;
        zSafe = (h + safetyDistance) * (1 - 2 * Phi / pi);
        obstacles.shape{i}.xSafeRel = rSafe .* cos(Theta);
        obstacles.shape{i}.ySafeRel = rSafe .* sin(Theta);
        obstacles.shape{i}.zSafeRel = zSafe;
    end
end
