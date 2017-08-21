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

function [basinSizes, probabilities, cellFates, attractorTypes, outputNodeActivities, avgOutputNodeActivities] = generate_SteadyStatesToolTipData(combinedIndicies, myNetwork, stateSpace)
% EXTRACTS THE BASIN SIZES, PROBABILITIES AND CELL FATES ASSOCIATED WITH
% STEADY STATES

% BASIN SIZES, PROBABILTIES AND CELL FATE VAR
basinSizes = cell(numel(combinedIndicies), 1);
probabilities = cell(numel(combinedIndicies), 1);
cellFates = cell(numel(combinedIndicies), 1);
attractorTypes = cell(numel(combinedIndicies), 1);
outputNodeActivities = cell(numel(combinedIndicies), 1);
avgOutputNodeActivities = cell(numel(combinedIndicies), 1);

if ~isempty(myNetwork.AttractorTable)
    for i = 1:size(myNetwork.AttractorTable, 1)
        attractor = myNetwork.AttractorTable{i, 1};
        [~, indicies] = ismember(attractor, stateSpace(combinedIndicies, :), 'rows');
        indicies(indicies==0) = [];
        basinSizes(indicies) = myNetwork.AttractorTable(i, 3);
        if numel(indicies) > 1
            attractorTypes(indicies) = {['Cyclic Attractor  - ', '(Attr #: ', num2str(i), ')']};
        else
            attractorTypes(indicies) = {['Point Attractor - ', '(Attr #: ', num2str(i), ')']};
        end
    end
    empty = cellfun(@isempty, basinSizes);
    basinSizes(empty) = {'0'};
    
    empty = cellfun(@isempty, attractorTypes);
    attractorTypes(empty) = {'N/A'};
else
    % IF DA NOT PERFORMED
    basinSizes(:) = {'N/A'};
    attractorTypes(:) = {'N/A'};
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

end

