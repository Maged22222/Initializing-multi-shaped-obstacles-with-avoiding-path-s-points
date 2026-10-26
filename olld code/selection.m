function selectedPopulation = selection(population)
    tournamentSize = min(5, length(population));  % Maximum tournament size is 5 or the population size
    numSelected = 10;  % Example number of selected individuals, adjust as needed
    
    selectedPopulation = struct('position', {}, 'fitness', {});
    for i = 1:numSelected
        % Perform tournament selection
        tournamentIndices = randperm(length(population), tournamentSize);
        tournamentPopulation = population(tournamentIndices);
        [~, winnerIdx] = max([tournamentPopulation.fitness]);
        winner = tournamentPopulation(winnerIdx);
        
        % Add winner to selected population
        selectedPopulation(i) = winner;
    end
end