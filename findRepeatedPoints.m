function [uniquePts, repeatedPts, repeatedIdx] = findRepeatedPoints(pts, tolerance)
  
    if isempty(pts)
        uniquePts = [];
        repeatedPts = [];
        repeatedIdx = [];
        return;
    end
   
    
    ia = 1; 
    
    uniquePts = pts(1, :); 
  
    for i = 2:size(pts, 1)
        currentPoint = pts(i, :);
        currentPointMatrix = repmat(currentPoint, size(uniquePts, 1), 1);
        distSquared = sum((currentPointMatrix - uniquePts).^2, 2);
   
        if min(distSquared) > tolerance
           
            uniquePts = [uniquePts; currentPoint];
            ia = [ia; i]; 
        end
    end
  
    allIdx = (1:size(pts, 1))'; 
     
    isRepeated = true(size(pts, 1), 1);
  
    isRepeated(ia) = false; 
   
    repeatedPts = pts(isRepeated, :);
  
    repeatedIdx = allIdx(isRepeated);
end

