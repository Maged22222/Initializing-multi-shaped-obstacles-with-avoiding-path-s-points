function obstacles = generateComplexObstacles(startPoints, endPoints, baseRadius, realSpeed, numTheta, numPhi, safetyDistance)
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
        numHarmonics = 3;
        rPerturb = zeros(size(Theta));

        for h = 1:numHarmonics
            freqTheta = randi([1, 4]);
            freqPhi = randi([1, 3]);
            amp = 0.15 + 0.15 * rand();
            phaseTheta = 2 * pi * rand();
            phasePhi = pi * rand();

            rPerturb = rPerturb + amp * cos(freqTheta * Theta + phaseTheta) .* sin(freqPhi * Phi + phasePhi);
        end

        localRadius = baseRadius * (1 + 0.3 * (rPerturb / max(abs(rPerturb(:)))));

        obstacles.shape{i}.localRadius = localRadius;
        obstacles.shape{i}.xRel = localRadius .* sin(Phi) .* cos(Theta);
        obstacles.shape{i}.yRel = localRadius .* sin(Phi) .* sin(Theta);
        obstacles.shape{i}.zRel = localRadius .* cos(Phi);

        safeRadius = localRadius + safetyDistance;
        obstacles.shape{i}.xSafeRel = safeRadius .* sin(Phi) .* cos(Theta);
        obstacles.shape{i}.ySafeRel = safeRadius .* sin(Phi) .* sin(Theta);
        obstacles.shape{i}.zSafeRel = safeRadius .* cos(Phi);
    end
end
