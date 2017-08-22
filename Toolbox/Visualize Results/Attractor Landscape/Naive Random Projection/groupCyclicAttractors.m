%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ATLANTIS: Attractor Landscape Analysis Toolbox for        %
%              Cell Fate Discovery and Reprogramming               %
%                           Version 1.0.0                          %
%     Copyright (c) Biomedical Informatics Research Laboratory,    %
%      Lahore University of Management Sciences Lahore (LUMS),     %
%                            Pakistan.                             %
%                 http://biolabs.lums.edu.pk/birl)                 %
%                     (safee.ullah@gmail.com)                      %
%                  Last Modified on: 18-August-2017                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [randomInd, Z] = groupCyclicAttractors(myNetwork, stateSpace, randomInd, stateSpaceLen, Z)
% GROUP CYCLIC ATTRACTORS TOGETHER

randomIndSquare = reshape(randomInd, [stateSpaceLen, stateSpaceLen]);

% GET ALL CYCLIC ATTRACTORS
cyclicAttractors = cell(size(myNetwork.AttractorTable, 1), 1);
for i = 1:size(myNetwork.AttractorTable, 1)
    attr = myNetwork.AttractorTable{i, 1};
    if size(attr, 1) > 1
        cyclicAttractors(i) = myNetwork.AttractorTable(i, 1);
    end
end

% REMOVE EMPTY SPACES
empty = cellfun(@isempty, cyclicAttractors);
if empty == 0
    empty = [];
end
cyclicAttractors(empty) = [];

% STORES COORDS OF ALREADY GROUP ATTRACTORS
unavailablePositions = [];

if ~isempty(cyclicAttractors)
    % FOR EACH CYCLIC ATTRACTOR
    for i = 1:numel(cyclicAttractors)
        % GET CURRENT POSITIONS OF THESE ATTRACTORS
        indicieS = randomInd(1:size(stateSpace, 1));
        [~, currStatePositions] = ismember(cyclicAttractors{i}, stateSpace(indicieS, :), 'rows');
        numOfStates = size(cyclicAttractors{i}, 1);
        
        % FIND ROW AND COL OF STATE AROUND WHICH TO GROUP
        [r, c] = cellfun(@(currPos) find(randomIndSquare == randomIndSquare(currPos)), num2cell(currStatePositions, 2));
        oldPositions = [r, c];
        
        % FIND STATE AROUND WHICH TO GROUP OTHER STATES
        [scores, distances, availableSetsOfPoints] = cellfun(@(rc) findValidPositions(rc(:, 1), rc(:, 2), ...
            numOfStates, unavailablePositions, stateSpaceLen), num2cell(oldPositions, 2), 'un', 0);
        
        % FIND THE BEST CENTER STATE AROUND WHICH TO GROUP OTHER STATES
        [~, centerStateIndex] = min(cell2mat(scores));
        
        % FIND THE CLOSEST POINTS
        [~, pointIndicies] = sort(distances{centerStateIndex});
        newPositions = availableSetsOfPoints{centerStateIndex}(pointIndicies(1:numOfStates-1), :);
        associatedWeights = distances{centerStateIndex}(pointIndicies(1:numOfStates-1), :).*2;
        
        % ADD POSITIONS OF GROUPED STATES TO LIST OF UNAVAILABLE POSITIONS
        unavailablePositions = vertcat(unavailablePositions, oldPositions(centerStateIndex, :), newPositions);
        
        % REMOVE CENTER POINT COORDINATIONS FROM LIST OF ORIGINAL
        % POSITIONS OF STATES
        oldPositions(centerStateIndex, :) = [];
        
        % SWAP ORIGINAL POSITIONS WITH NEW POSITIONS
        for j = 1:size(newPositions, 1)
            % GET NEW AND OLD ROWS AND COLS
            rNew = newPositions(j, 1); cNew = newPositions(j, 2);
            rOld = oldPositions(j, 1); cOld = oldPositions(j, 2);
            
            % SAVE OLD VALUE
            temp1 = randomIndSquare(rNew, cNew);
            temp2 = Z(rNew, cNew);
            
            % SWAP INDICIES VALUES
            randomIndSquare(rNew, cNew) = randomIndSquare(rOld, cOld);
            randomIndSquare(rOld, cOld) = temp1;
            
            % SWAP Z VALUES
            Z(rNew, cNew) = Z(rOld, cOld)/associatedWeights(j);
            Z(rOld, cOld) = temp2;
            
        end
    end
    randomInd = randomIndSquare(:);
end
end

