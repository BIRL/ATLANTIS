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

function [figHandle, bool, plotHandle, gridTipToolData, gridData] = plot_AttractorLandscape(myNetwork, x, y, z, plottingOptions, stateSpace)
% PLOTS ATTRACTOR LANDSCAPE USING RESULTS FROM PROBABILITIC (STEADY STATE
% PROBABILITIES) OR DETERMINISTIC (BASIN SIZES) ANALYSIS

try
    % EXTRACTING PLOTTING OPTIONS
    plotTitle = plottingOptions.plotTitle;
    showToolTip = plottingOptions.showToolTip;
    annotateAttractors = plottingOptions.AnnotateAttractors;
    selectedColorScheme = plottingOptions.selectedColorScheme;
    mappingMethod = plottingOptions.mappingMethod;
    
    % LANDSCAPE PLOTTING
    figure;
    
    if strcmp(mappingMethod, 'sammon')
        % LAYOUT GRID BOUNDS
        resolution = (max(x(:))-min(x(:)))/(sqrt(size(stateSpace, 1)*4));
        xn = min(x):resolution:max(x);
        yn = min(y):resolution:max(y);
        
        % CREATE GRID
        [xq,yq] = meshgrid(xn, yn);
        
        % STATE SPACE LENGTH
        stateSpaceLen = length(xq);
        
        % CREATE A SURFACE + CONTOUR PLOT
        zq = griddata(x, y, z, xq, yq,'natural');
        plotHandle = surfc(xq, yq, zq);
        Z = z;
        x = xq;
        y = yq;
    elseif strcmp(mappingMethod, 'naive')
        % STATE SPACE LENGTH
        stateSpaceLen = length(x);
        
        % IF STATE SPACE NOT A PERFECT SQUARE, MAKE IT A PERFECT SQUARE
        if stateSpaceLen^2 ~= size(stateSpace, 1)
            numExtraBox = stateSpaceLen^2 - size(stateSpace, 1);
            extraValues = zeros(numExtraBox, 1);
            extraValues(:) = 0;
            newZ = vertcat(z, extraValues);
        else
            newZ = z;
        end
        
        % RANDOMIZE Z VALUES
        if ~isempty(myNetwork.RandomIndicies) && size(myNetwork.RandomIndicies, 1) == size(newZ, 1)
            randomInd = myNetwork.RandomIndicies;
        else
            randomInd = randperm(size(stateSpace, 1))';
            extraVals = size(stateSpace, 1) + 1 : size(newZ, 1);
            randomInd = vertcat(randomInd, extraVals');
            myNetwork.RandomIndicies = randomInd;
        end
        
        % CREATE RESHAPED Z WITH RANDOMIZED Z VALUES
        shuffledZ = newZ(randomInd);
        Z = reshape(shuffledZ, [stateSpaceLen, stateSpaceLen]);
        
        % GROUP CYCLIC ATTRACTORS
        if ~isempty(myNetwork.AttractorTable) && plottingOptions.groupCyclicAttractors
            [randomInd, Z] = groupCyclicAttractors(myNetwork, stateSpace, randomInd, stateSpaceLen, Z);
        end

        % CREATE A SURFACE + CONTOUR PLOT
        plotHandle = surfc(x, y, Z);
        
        Z = reshape(newZ(randomInd), [stateSpaceLen, stateSpaceLen]);
    end
    
    % IMPROVE VISUALIZATION
    set(plotHandle(1),'FaceColor','interp'); % 'flat' 'texture'
    set(plotHandle(1),'EdgeColor','none');
    
    colormap(flipud(eval([selectedColorScheme, '(100)']))); % winter autum parula
    
    % REMOVE X AND Y AXIS TICKS AND ADD LABELS
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    xlabel('States');
    ylabel('States');
    
    % GET FIGURE HANDLE
    figHandle = gcf;
    
    % ADD COLORBAR
    colorbar
    
    % AXIS
    zlim([0 1.08]);
    
    % STABILIZE AXIS
    axis(axis)
    
    % ADD CONTEXT MENU TO FIGURE
    rootMenu = uicontextmenu(figHandle);
    figHandle.UIContextMenu = rootMenu;
    
    % ADD PLOT MODIFICATION OPTIONS IN CONTEXT MENU
    addPlotModificationOptionsMenu(figHandle, rootMenu, plotHandle)
    
    % REMOVE NUMBER TITLE AND UPDATE FIGURE TITLE
    if strcmp(plottingOptions.plotTypes, 'BS')
        name = 'Basin Size Landscape';
    elseif strcmp(plottingOptions.plotTypes, 'PE')
        name = 'Potential Energy Landscape';
    else
        name = 'Probability Landscape';
    end
    
    if ~isempty(myNetwork.FileName)
        str = strrep(myNetwork.FileName, ' - ', '');
        if isempty(strtrim(plotTitle))
            title([plotTitle, str]);
        else
            title([plotTitle, ' - ', str]);
        end
    else
        str = getappdata(0, 'NetworkfileName');
        title(plotTitle);
    end
    
    set(figHandle, 'Name', [name, ' - ', str], 'NumberTitle', 'off');    
    
    % INITIALIZE INDICIES VAR
    attractorIndiciesOriginal = [];
    transientStateindiciesOriginal = [];    
    prominentSteadyStateIndiciesOriginal = [];
    
    % GET INDICIES OF ATTRACTOR STATE
    if ~isempty(myNetwork.AttractorTable)
        [~, attractorIndiciesOriginal] = ismember(cell2mat(myNetwork.AttractorTable(:, 1)), stateSpace, 'rows');
    end
    
    % GET INDICIES OF STATES IN TRAJECTORY
    if ~isempty(myNetwork.Trajectory)    
        trajectoryResults = myNetwork.Trajectory;
        
        statesInTrajectory = trajectoryResults{3};        
        associatedCellFates = trajectoryResults{2};
        
        if ~all(cellfun(@isempty, associatedCellFates))
            characterizedStatesInTrajectory = ...
                statesInTrajectory(~cellfun(@isempty, associatedCellFates), :);
            [~, transientStateindiciesOriginal] = ismember(characterizedStatesInTrajectory(:, 2:end), stateSpace, 'rows');
        else
            [~, transientStateindiciesOriginal] = ismember(statesInTrajectory(:, 2:end), stateSpace, 'rows');
        end
    end
    
    if ~isempty(myNetwork.SteadyStateProbabilities)
        % GET INDICIES OF TOP 10 PROMINENT STATES
        [sortedZ, indiciesOfOriginalPositions] = sort(z(:), 'descend');
        prominentSteadyStateIndiciesOriginal = indiciesOfOriginalPositions(sortedZ > 0);
        indicieS = 10;
        if ~isempty(attractorIndiciesOriginal)
            indicieS = size(attractorIndiciesOriginal, 1);
        end
        prominentSteadyStateIndiciesOriginal = prominentSteadyStateIndiciesOriginal(1:indicieS);
    end
    
    % REMOVE ZERO ENTERIES
    transientStateindiciesOriginal(transientStateindiciesOriginal == 0) = [];
    attractorIndiciesOriginal(attractorIndiciesOriginal == 0) = [];
    prominentSteadyStateIndiciesOriginal(prominentSteadyStateIndiciesOriginal == 0) = [];
    
    if strcmp(mappingMethod, 'sammon')
        zData = {Z, zq};
        randomInd = [];
    else
        zData = Z;
    end
    
    % SET UP MATERIAL FOR DISPLAYING TOOLTIPS
    if showToolTip
        [gridTipToolData, gridData] = assembleToolTipData(myNetwork, x, y...
            , zData, randomInd, stateSpaceLen, mappingMethod, stateSpace...
            , attractorIndiciesOriginal, transientStateindiciesOriginal...
            , prominentSteadyStateIndiciesOriginal);
    else
        gridTipToolData = [];
        gridData = [];
    end
    
    % ADD ANNOTATIONS
    if annotateAttractors
        [prominentSteadyStateIndicies, transientStateindicies, ...
            attractorIndicies, attractorStateMarks,  transientStateMarks, ...
            prominentSteadyStateMarks, arrowsObj] = annotate_AttractorLandscape(x, y, zData...
            , stateSpaceLen, mappingMethod, randomInd, attractorIndiciesOriginal...
            , transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal);
        
        % ADD UIMENU TO TOGGLE ANNOTATIONS
        addToggleAnnotationMenu(rootMenu, prominentSteadyStateIndicies, ...
            transientStateindicies, attractorIndicies, prominentSteadyStateMarks, ...
            transientStateMarks, attractorStateMarks, arrowsObj);
        
        % ADD LEGENDS
        addLegendsForAttractorPlots;
    end
    
    % SUCCESS
    bool = 1;
catch
    % FAILURE
    bool = 0;
end

end

