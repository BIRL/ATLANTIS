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

function [orderInTrajectory, allAttractorNumber, basinSizes, probabilities, cellFates, attractorTypes, outputNodeActivities, avgOutputNodeActivities] = generate_AttractorStateToolTipData(attractorIndiciesOriginal, transientStateindiciesOriginal, myNetwork, stateSpace)
% EXTRACTS THE BASIN SIZES, PROBABILITIES AND CELL FATES OF ATTRACTOR
% STATES

% BASIN SIZES, PROBABILTIES AND CELL FATE VAR
orderInTrajectory = cell(numel(attractorIndiciesOriginal), 1);
allAttractorNumber = cell(numel(attractorIndiciesOriginal), 1);
basinSizes = cell(numel(attractorIndiciesOriginal), 1);
probabilities = cell(numel(attractorIndiciesOriginal), 1);
cellFates = cell(numel(attractorIndiciesOriginal), 1);
attractorTypes = cell(numel(attractorIndiciesOriginal), 1);
outputNodeActivities = cell(numel(attractorIndiciesOriginal), 1);
avgOutputNodeActivities = cell(numel(attractorIndiciesOriginal), 1);

if ~isempty(myNetwork.CellFateDeterminationLogic)
    % GET BASIN SIZES AND EXTRACT CELL FATES
    for i = 1:size(myNetwork.AttractorTable, 1)
        attractor = myNetwork.AttractorTable{i, 1};
        [~, indicies] = ismember(attractor, stateSpace(attractorIndiciesOriginal, :), 'rows');
        indicies(indicies==0) = [];
        basinSizes(indicies) = myNetwork.AttractorTable(i, 3);
        if size(myNetwork.AttractorTable, 2) > 3
            cellFates(indicies) = myNetwork.AttractorTable(i, 4);
        else
            cellFates(indicies) = {'N/A'};
        end
        if numel(indicies) > 1
            attractorTypes(indicies) = {'Cyclic Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        else
            attractorTypes(indicies) = {'Point Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        end
        outputNodeActivities(indicies) = cellfun(@(state) state(:, myNetwork.OutputNodesIndices), num2cell(attractor, 2), 'un', 0);
        [~, AvgNodeActivtiy] = cellfun(@(attr) summarize_AttractorActivity(attr(:, myNetwork.OutputNodesIndices), 0.2, 0.2), myNetwork.AttractorTable(i, 1), 'un', 0);
        avgOutputNodeActivities(indicies) = AvgNodeActivtiy;
    end
else
    % GET BASIN SIZES
    for i = 1:size(myNetwork.AttractorTable, 1)
        attractor = myNetwork.AttractorTable{i, 1};
        [~, indicies] = ismember(attractor, stateSpace(attractorIndiciesOriginal, :), 'rows');
        basinSizes(indicies) = myNetwork.AttractorTable(i, 3);
        if numel(indicies) > 1
            attractorTypes(indicies) = {'Cyclic Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        else
            attractorTypes(indicies) = {'Point Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        end
    end
    % IF STATES NOT CHARACTERIZED AND ASSOCIATED WITH CELL FATES
    cellFates(:) = {'N/A'};
    outputNodeActivities(:) = {'N/A'};
    avgOutputNodeActivities(:) = {'N/A'};
end


if ~isempty(myNetwork.SteadyStateProbabilities) % PA HAS BEEN PERFORMED
    % EXTRACT CORRESPONDING PROBABILITIES
    probabilities = cellstr(num2str(myNetwork.SteadyStateProbabilities(attractorIndiciesOriginal)));
elseif isempty(myNetwork.SteadyStateProbabilities) % PA HAS NOT BEEN PERFORMED
    % IF PA NOT PERFORMED
    probabilities(:) = {'N/A'};
end


% ORDER IN TRAJECTOR
if ~isempty(myNetwork.Trajectory)
    % EXTRACT CORRESPONDING PROBABILITIES
    [~, indicies] = ismember(attractorIndiciesOriginal, flipud(transientStateindiciesOriginal), 'rows');
    
    for ind = 1:numel(indicies)
        
        if indicies(ind) == 0
            order = 'Absent';
        else
            order = int2str(indicies(ind));
        end
        
        orderInTrajectory(ind) = {order}; 
    end
else
    orderInTrajectory(:) = {'N/A'};
end

end

