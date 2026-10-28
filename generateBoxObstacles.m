function obstacles = generateBoxObstacles(startPoints, endPoints, baseRadius, realSpeed, numTheta, numPhi, safetyDistance)
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

    epsVal = 1e-6;

    for i = 1:numObstacles
        L = baseRadius * (0.8 + 0.5 * rand());
        W = baseRadius * (0.8 + 0.5 * rand());
        H = baseRadius * (0.8 + 0.5 * rand());

        ux = sin(Phi) .* cos(Theta);
        uy = sin(Phi) .* sin(Theta);
        uz = cos(Phi);

        distBox = min(min(L ./ (abs(ux) + epsVal), W ./ (abs(uy) + epsVal)), H ./ (abs(uz) + epsVal));

        obstacles.shape{i}.xRel = distBox .* ux;
        obstacles.shape{i}.yRel = distBox .* uy;
        obstacles.shape{i}.zRel = distBox .* uz;

        distSafe = distBox + safetyDistance;
        obstacles.shape{i}.xSafeRel = distSafe .* ux;
        obstacles.shape{i}.ySafeRel = distSafe .* uy;
        obstacles.shape{i}.zSafeRel = distSafe .* uz;
    end
end
