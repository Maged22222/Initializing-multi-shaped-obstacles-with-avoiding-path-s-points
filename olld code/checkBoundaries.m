function isInBounds = checkBoundaries(position)
    % Define simulation boundaries
    minX = 0;
    maxX = 100;
    minY = 0;
    maxY = 100;
    minZ = 0;
    maxZ = 100;

    % Check if the adjusted position is within the boundaries
    isInBounds = position(1) >= minX && position(1) <= maxX && ...
                 position(2) >= minY && position(2) <= maxY && ...
                 position(3) >= minZ && position(3) <= maxZ;
end
