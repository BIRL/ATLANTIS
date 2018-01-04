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

function [gridTipToolData, gridData] = assembleToolTipData(myNetwork, x, y, z, randomInd, stateSpaceLen, mappingMethod, stateSpace, attractorIndiciesOriginal, transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal)
%

% INITIATE EMPTY VAR TO STORE CELL FATES
allOrderInTrajectory = [];
allCellFates = [];
allBasinSizes = [];
allProbabilities = [];
allAttractorTypes = [];
allAttractorNumber = [];
allOutputNodeActivities = [];
allAvgOutputNodeActivities = [];

% DA -> BASIN SIZES
if ~isempty(attractorIndiciesOriginal)
    
    [orderInTrajectory, attractorNumber, basinSizes, probabilities, cellFates...
        , attractorTypes, outputNodeActivities...
        , avgOutputNodeActivities] = generate_AttractorStateToolTipData(attractorIndiciesOriginal...
        , transientStateindiciesOriginal, myNetwork, stateSpace);
    
    allOrderInTrajectory = vertcat(allOrderInTrajectory, orderInTrajectory);
    allAttractorNumber = vertcat(allAttractorNumber, attractorNumber);
    allCellFates = vertcat(allCellFates, cellFates);
    allBasinSizes =  vertcat(allBasinSizes, basinSizes);
    allProbabilities =  vertcat(allProbabilities, probabilities);
    allAttractorTypes =  vertcat(allAttractorTypes, attractorTypes);
    allOutputNodeActivities = vertcat(allOutputNodeActivities, outputNodeActivities);
    allAvgOutputNodeActivities = vertcat(allAvgOutputNodeActivities, avgOutputNodeActivities);
end

% TRAJECTORY || TOP 10 STEADY STATES WITH HIGHES PROB -> PROBABILITY
if ~isempty(transientStateindiciesOriginal) || ~isempty(prominentSteadyStateIndiciesOriginal)
        
    [orderInTrajectory, attractorNumber, basinSizes, probabilities, cellFates, attractorTypes, outputNodeActivities...
        , avgOutputNodeActivities] = generate_SteadyStatesToolTipData(transientStateindiciesOriginal...
        , prominentSteadyStateIndiciesOriginal, myNetwork, stateSpace);
    
    allOrderInTrajectory = vertcat(allOrderInTrajectory, orderInTrajectory);
    allAttractorNumber = vertcat(allAttractorNumber, attractorNumber);
    allCellFates = vertcat(allCellFates, cellFates);
    allBasinSizes =  vertcat(allBasinSizes, basinSizes);
    allProbabilities =  vertcat(allProbabilities, probabilities);
    allAttractorTypes =  vertcat(allAttractorTypes, attractorTypes);
    allOutputNodeActivities = vertcat(allOutputNodeActivities, outputNodeActivities);
    allAvgOutputNodeActivities = vertcat(allAvgOutputNodeActivities, avgOutputNodeActivities);
end

% REPLACE EMPTY CELL FATES
empty = cellfun(@isempty, allCellFates);
allCellFates(empty) = {'Uncharacterized'};

totalStates = int2str(size(stateSpace, 1));

if strcmp(mappingMethod, 'naive')
    allOriginalIndicies = vertcat(attractorIndiciesOriginal, transientStateindiciesOriginal...
        , prominentSteadyStateIndiciesOriginal);
    
    % CREATE CELL THAT WILL STORE DATA TIP INFORMATION
    gridTipToolData = cell(stateSpaceLen, stateSpaceLen);
    
    % PROCESS X AND Y
    if size(x, 2) ~= 1
        gridData = ones(numel(x), 2);
        for i = 1:numel(x)
            gridData(i, :) = [x(i), y(i)];
        end
    else
        gridData = [x, y];
    end
    
    % POPULATED GRID TIP TOOL DATA
    [~, newIndices] = ismember(allOriginalIndicies, randomInd, 'rows');
    newIndices(newIndices == 0) = [];
    for i = 1:numel(newIndices)
        coords = gridData(newIndices(i, :), :);
        r = coords(1);
        c = coords(2);
        if isempty(gridTipToolData{r, c})
            gridTipToolData{r, c} = {allAttractorNumber(i), allAttractorTypes{i}, ['State ', ...
                int2str(allOriginalIndicies(i)), ' of ', totalStates], allCellFates{i},allOrderInTrajectory{i}, ...
                allBasinSizes{i}, allProbabilities{i}, ...
                allOutputNodeActivities{i}, allAvgOutputNodeActivities{i}};
        end
    end
    
elseif strcmp(mappingMethod, 'sammon')
    Z = z{1};
    zq = z{2};
    
    % SET TOLERANCE
    precision = length(num2str(10*(x(1)-floor(Z(1)))))/4;
    tol = 10^-(precision);
    
    % FIND NEW INDICIES
    [~, attractorIndicies] = ismembertol(Z(attractorIndiciesOriginal), zq(:), tol, 'ByRows', true);
    [~, transientStateindicies] = ismembertol(Z(transientStateindiciesOriginal), zq(:), tol, 'ByRows', true);
    [~, prominentSteadyStateIndicies] = ismembertol(Z(prominentSteadyStateIndiciesOriginal), zq(:), tol, 'ByRows', true);
    attractorIndicies(attractorIndicies == 0) = [];
    transientStateindicies(transientStateindicies == 0) = [];
    prominentSteadyStateIndicies(prominentSteadyStateIndicies == 0) = [];
    
    allOriginalIndicies = vertcat(attractorIndicies, transientStateindicies, prominentSteadyStateIndicies);

    % CREATE CELL THAT WILL STORE DATA TIP INFORMATION
    gridTipToolData = cell(numel(x), 1);
    
    % PROCESS X AND Y
    gridData = {[x(:), y(:), zq(:)], allOriginalIndicies};
    
    % POPULATED GRID TIP TOOL DATA
    for i = 1:numel(allOriginalIndicies)
        if isempty(gridTipToolData{allOriginalIndicies(i)})
            gridTipToolData{allOriginalIndicies(i)} = {allAttractorNumber(i), allAttractorTypes{i}, ['State ', ...
                int2str(allOriginalIndicies(i)), ' of ', totalStates], allCellFates{i},allOrderInTrajectory{i}, ...
                allBasinSizes{i}, allProbabilities{i}, ...
                allOutputNodeActivities{i}, allAvgOutputNodeActivities{i}};
        end
    end
end

end

