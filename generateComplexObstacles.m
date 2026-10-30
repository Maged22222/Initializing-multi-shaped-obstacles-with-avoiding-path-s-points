function obstacles = generateComplexObstacles(startPoints, endPoints, baseRadius, realSpeed, numTheta, numPhi, safetyDistance)
    numObstacles = size(startPoints, 1);
    distances = vecnorm(endPoints - startPoints, 2, 2);
    directions = (endPoints - startPoints) ./ distances;
    velocities = directions .* realSpeed;

    theta = linspace(0, 2*pi, numTheta);
    phi = linspace(0, pi, numPhi);
    [Theta, Phi] = meshgrid(theta, phi);

    [ThetaFine, PhiFine] = meshgrid(linspace(0, 2*pi, 60), linspace(0, pi, 40));

    obstacles.position = startPoints;
    obstacles.endPoints = endPoints;
    obstacles.velocity = velocities;
    obstacles.baseRadius = baseRadius * ones(numObstacles, 1);
    obstacles.safetyDistance = safetyDistance;
    obstacles.Theta = Theta;
    obstacles.Phi = Phi;
    obstacles.shape = cell(numObstacles, 1);

    for i = 1:numObstacles
        params = randomShapeParams(baseRadius);

        localRadius = shapeRadius(Theta, Phi, params);
        fineRadius = shapeRadius(ThetaFine, PhiFine, params);

        obstacles.shape{i}.params = params;
        obstacles.shape{i}.localRadius = localRadius;
        obstacles.shape{i}.xRel = fineRadius .* sin(PhiFine) .* cos(ThetaFine);
        obstacles.shape{i}.yRel = fineRadius .* sin(PhiFine) .* sin(ThetaFine);
        obstacles.shape{i}.zRel = fineRadius .* cos(PhiFine);

        safeRadius = localRadius + safetyDistance;
        obstacles.shape{i}.xSafeRel = safeRadius .* sin(Phi) .* cos(Theta);
        obstacles.shape{i}.ySafeRel = safeRadius .* sin(Phi) .* sin(Theta);
        obstacles.shape{i}.zSafeRel = safeRadius .* cos(Phi);
    end
end

function params = randomShapeParams(baseRadius)
    params.baseRadius = baseRadius;
    params.axes = baseRadius * (0.6 + 1.0 * rand(1, 3));

    [Q, ~] = qr(randn(3));
    params.rotation = Q;

    numLobes = randi([4, 8]);
    lobeDirs = randn(numLobes, 3);
    params.lobeDirs = lobeDirs ./ vecnorm(lobeDirs, 2, 2);
    params.lobeAmp = -0.6 + 1.8 * rand(numLobes, 1);
    params.lobeSharp = 3 + 9 * rand(numLobes, 1);

    numWaves = 6;
    waveDirs = randn(numWaves, 3);
    params.waveDirs = waveDirs ./ vecnorm(waveDirs, 2, 2);
    params.waveFreq = 2 + 4 * rand(numWaves, 1);
    params.waveAmp = 0.05 + 0.10 * rand(numWaves, 1);
    params.wavePhase = 2 * pi * rand(numWaves, 1);
end

function r = shapeRadius(Theta, Phi, params)
    ux = sin(Phi) .* cos(Theta);
    uy = sin(Phi) .* sin(Theta);
    uz = cos(Phi);

    R = params.rotation;
    vx = R(1,1)*ux + R(2,1)*uy + R(3,1)*uz;
    vy = R(1,2)*ux + R(2,2)*uy + R(3,2)*uz;
    vz = R(1,3)*ux + R(2,3)*uy + R(3,3)*uz;

    a = params.axes;
    rEllipsoid = 1 ./ sqrt((vx / a(1)).^2 + (vy / a(2)).^2 + (vz / a(3)).^2);

    deform = zeros(size(Theta));
    for k = 1:numel(params.lobeAmp)
        d = params.lobeDirs(k, :);
        dotDir = ux * d(1) + uy * d(2) + uz * d(3);
        deform = deform + params.lobeAmp(k) * exp(params.lobeSharp(k) * (dotDir - 1));
    end

    for k = 1:numel(params.waveAmp)
        w = params.waveDirs(k, :);
        dotDir = ux * w(1) + uy * w(2) + uz * w(3);
        deform = deform + params.waveAmp(k) * cos(params.waveFreq(k) * pi * dotDir + params.wavePhase(k));
    end

    r = rEllipsoid .* (1 + deform);
    r = max(r, 0.35 * params.baseRadius);
end
