function obstacles = generateEllipsoidObstacles(startPoints, endPoints, baseRadius, realSpeed, numTheta, numPhi, safetyDistance)
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
        a = baseRadius * (0.8 + 0.5 * rand());
        b = baseRadius * (0.8 + 0.5 * rand());
        c = baseRadius * (0.8 + 0.5 * rand());

        obstacles.shape{i}.xRel = a .* sin(Phi) .* cos(Theta);
        obstacles.shape{i}.yRel = b .* sin(Phi) .* sin(Theta);
        obstacles.shape{i}.zRel = c .* cos(Phi);

        obstacles.shape{i}.xSafeRel = (a + safetyDistance) .* sin(Phi) .* cos(Theta);
        obstacles.shape{i}.ySafeRel = (b + safetyDistance) .* sin(Phi) .* sin(Theta);
        obstacles.shape{i}.zSafeRel = (c + safetyDistance) .* cos(Phi);
    end
end
