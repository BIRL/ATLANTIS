%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ATLANTIS: Attractor Landscape Analysis Toolbox for        %
%              Cell Fate Discovery and Reprogramming               %
%                           Version 2.0.0                          %
%     Copyright (c) Biomedical Informatics Research Laboratory,    %
%      Lahore University of Management Sciences Lahore (LUMS),     %
%                            Pakistan.                             %
%                 http://biolabs.lums.edu.pk/birl)                 %
%                     (safee.ullah@gmail.com)                      %
%                  Last Modified on: 03-January-2018               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [score, distances, availablePoints] = findValidPositions(r, c, pointsNeeded, unavailablePositions, stateSpaceLen)
% 

% FIND EMPTY POSITION NEARBY THIS ATTRACTOR
[rows, cols] = findPositions(r, c, pointsNeeded*2 + numel(unavailablePositions), stateSpaceLen);

% REMOVE ANY UNAVAILABLE POINTS
if ~isempty(unavailablePositions)
    [~, indicies] = ismember(unavailablePositions, [rows, cols], 'rows');
    indicies(indicies == 0) = [];
    rows(indicies) = [];
    cols(indicies) = [];
end

availablePoints = [rows, cols];

% FIND DISTANCE BETWEEN THE CENTER AND THE CANDIDATE POINTS
distances = cellfun(@(x) norm([r,c] - x) , num2cell(availablePoints,2));

if  size(distances, 1) >= pointsNeeded
    score = mean(distances) + var(distances);
elseif size(distances, 1) < pointsNeeded
    score = inf;
end

end

