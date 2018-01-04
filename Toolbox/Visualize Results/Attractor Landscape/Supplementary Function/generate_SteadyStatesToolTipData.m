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

function [orderInTrajectory, allAttractorNumber, basinSizes, probabilities, cellFates, attractorTypes, outputNodeActivities, avgOutputNodeActivities] = generate_SteadyStatesToolTipData(transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal, myNetwork, stateSpace)
% EXTRACTS THE BASIN SIZES, PROBABILITIES AND CELL FATES ASSOCIATED WITH
% STEADY STATES

combinedIndicies = vertcat(transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal);

% BASIN SIZES, PROBABILTIES AND CELL FATE VAR
orderInTrajectory = cell(numel(combinedIndicies), 1);
allAttractorNumber = cell(numel(combinedIndicies), 1);
basinSizes = cell(numel(combinedIndicies), 1);
probabilities = cell(numel(combinedIndicies), 1);
cellFates = cell(numel(combinedIndicies), 1);
attractorTypes = cell(numel(combinedIndicies), 1);
outputNodeActivities = cell(numel(combinedIndicies), 1);
avgOutputNodeActivities = cell(numel(combinedIndicies), 1);

combinedIndicies(combinedIndicies == 0) = [];

if ~isempty(myNetwork.AttractorTable)
    for i = 1:size(myNetwork.AttractorTable, 1)
        attractor = myNetwork.AttractorTable{i, 1};
        [~, indicies] = ismember(attractor, stateSpace(combinedIndicies, :), 'rows');
        indicies(indicies==0) = [];
        basinSizes(indicies) = myNetwork.AttractorTable(i, 3);
        if numel(indicies) > 1
            attractorTypes(indicies) = {'Cyclic Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        else
            attractorTypes(indicies) = {'Point Attractor'};
            allAttractorNumber(indicies) = {int2str(i)};
        end
    end
    empty = cellfun(@isempty, basinSizes);
    basinSizes(empty) = {'0'};
    
    empty = cellfun(@isempty, attractorTypes);
    attractorTypes(empty) = {'N/A'};
    
    empty = cellfun(@isempty, allAttractorNumber);
    allAttractorNumber(empty) = {'N/A'};
else
    % IF DA NOT PERFORMED
    basinSizes(:) = {'N/A'};
    attractorTypes(:) = {'N/A'};
    allAttractorNumber(:) = {'N/A'};
end

if ~isempty(myNetwork.CellFateDeterminationLogic)
    attractorList = cellfun(@(a) a(:, myNetwork.OutputNodesIndices), ...
        num2cell(stateSpace, 2), 'un', 0);
    
    associatedCellFates = cellfun(@(attr) associate_CellFates...
        (myNetwork.CellFateDeterminationLogic, attr, ...
        numel(myNetwork.UniqueCellFates)), attractorList);
    
    % EXTRACT CELL FATES
    cellFates = associatedCellFates(combinedIndicies);
    
    % GET OUTPUT NODE ACTIVITIES
    outputNodeActivities = cellfun(@(state) state(:, myNetwork.OutputNodesIndices), num2cell(stateSpace(combinedIndicies, :), 2), 'un', 0);
    avgOutputNodeActivities = outputNodeActivities;
else
    % IF STATES NOT CHARACTERIZED AND ASSOCIATED WITH CELL FATES
    cellFates(:) = {'N/A'};
    outputNodeActivities(:) = {'N/A'};
    avgOutputNodeActivities(:) = {'N/A'};
end

if ~isempty(myNetwork.SteadyStateProbabilities) % PA HAS BEEN PERFORMED
    % EXTRACT CORRESPONDING PROBABILITIES
    probabilities = cellstr(num2str(myNetwork.SteadyStateProbabilities(combinedIndicies)));
elseif isempty(myNetwork.SteadyStateProbabilities) % PA HAS NOT BEEN PERFORMED
    % SET PROBABILITES TO : N/A
    probabilities(:) = {'N/A'};
end

% ORDER IN TRAJECTOR
if ~isempty(myNetwork.Trajectory)
    % EXTRACT CORRESPONDING PROBABILITIES
    [~, indicies] = ismember(combinedIndicies, flipud(transientStateindiciesOriginal), 'rows');
    
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

