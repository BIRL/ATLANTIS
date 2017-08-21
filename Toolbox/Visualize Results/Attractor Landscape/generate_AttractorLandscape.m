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

function errormsg = generate_AttractorLandscape
% PLOT POTENTIAL ENERGY AND BASIN SIZE LANDSCAPE

% GET NETWORK
myNetwork = get(0, 'UserData');

% DEFAULT MSG
errormsg = '';

% EXTRACT PLOTTING OPTIONS
PlottingOptions2 = myNetwork.AttractorLandscapePlottingOptions;

% EXTRACT PLOTTING OPTIONS
mappingMethod = PlottingOptions2.mappingMethod;
plotTypes = PlottingOptions2.plotTypes;

plotPEL = 0;
plotBSL = 0;
plotPL = 0;

if strcmp(plotTypes, 'All')
    plotPEL = 1; plotBSL = 1; plotPL = 1;
elseif strcmp(plotTypes, 'PE & BS')
    plotPEL = 1; plotBSL = 1; plotPL = 0;
elseif strcmp(plotTypes, 'PE & P')
    plotPEL = 1; plotBSL = 0; plotPL = 1;
elseif strcmp(plotTypes, 'BS & P')
    plotPEL = 0; plotBSL = 1; plotPL = 1;
elseif strcmp(plotTypes, 'PE')
    plotPEL = 1; plotBSL = 0; plotPL = 0;
elseif strcmp(plotTypes, 'BS')
    plotPEL = 0; plotBSL = 1; plotPL = 0;
elseif strcmp(plotTypes, 'P')
    plotPEL = 0; plotBSL = 0; plotPL = 1;
end

try
    % SETUP STATE SPACE
    stateSpace = myNetwork.NetworkStateList;
    
    if strcmp(mappingMethod, 'sammon')
        
        steadyStates = [];
        
        % ADD ATTRACTOR STATES
        if ~isempty(myNetwork.AttractorTable)
            steadyStates = vertcat(steadyStates, cell2mat(myNetwork.AttractorTable(:, 1)));
        end
        
        % GET MODIFIED STATE SPACE IF PRESENT
        if ~isempty(myNetwork.ModifiedStateSpace)
            stateSpace = myNetwork.ModifiedStateSpace;
            
            % FIND STATES IN TRAJECTROY
            if ~isempty(myNetwork.Trajectory)
                steadyStates = vertcat(steadyStates, myNetwork.Trajectory(:, 3:end));
            end
            
            % FIND STEADY STATES FROM PA RESULTS
            if ~isempty(myNetwork.SteadyStateProbabilities)
                steadyStateProbs = myNetwork.SteadyStateProbabilities;
                avgPini = mean(steadyStateProbs);
                ind = steadyStateProbs > avgPini;
                steadyStates = vertcat(steadyStates, myNetwork.NetworkStateList(ind, :));
            end
            
            % REMOVE DUPLICATES
            steadyStates = unique(steadyStates, 'rows');
        end
        
        % CHECK IF THE STATES ARE PRESENT IN THE NEW STATE SPACE
        [~, attrIndex] = ismember(steadyStates, stateSpace, 'rows');
        absentInd = attrIndex == 0;
        statesNotInStateSpace = steadyStates(absentInd, :);
        
        if ~isempty(statesNotInStateSpace)
            % IF STATES NOT IN STATE SPACE ARE MORE THAN SIZE OF STATE SPACE REDUCE THEIR NUMBER
            if size(statesNotInStateSpace, 1) > size(stateSpace, 1)
                extra = size(statesNotInStateSpace, 1) - size(stateSpace, 1);
                statesNotInStateSpace(end-extra:end, :) = [];
            end
            
            % REMOVE RANDOM NON-ATTRACTOR STATES FROM STATE SPACE TO MAKE SPACE FOR ABSENT ATTRACTOR
            randomInd = unique(randi([1 size(stateSpace, 1)], 1, max([size(stateSpace, 1), size(statesNotInStateSpace, 1)])));
            
            % REMOVE INDICIES CORRESPONDING TO ATTRACTORS
            [~, attrInd] = ismember(attrIndex, randomInd);
            attrInd(attrInd == 0) = [];
            randomInd(attrInd) = [];
            
            % REMOVE STATES
            stateSpace(randomInd(1:size(statesNotInStateSpace, 1)), :) = [];
            
            % UPDATE STATE SPACE
            stateSpace = vertcat(stateSpace, statesNotInStateSpace);
        end
    end
    
    % ADD ATTRACTOR STATES, IF PRESENT, TO THE STATE SPACE
    if strcmp(mappingMethod, 'naive') && ~isempty(myNetwork.AttractorTable) && size(myNetwork.NetworkStateList, 1) < 2^myNetwork.NodeCount
        stateSpace = unique(vertcat(stateSpace, cell2mat(myNetwork.AttractorTable(:, 1))), 'rows');
    end
    
catch
    errormsg = 'Error while setting up the state space.';
    return;
end


try
    % GET PREVIOUS RESULTS
    xy = myNetwork.MappingResults;
    
    % SET DEFAULT
    mappingPerformed = 0;
    
    % ASK IF USER WANTS TO USE PREVIOUS RESULTS
    if ~isempty(xy) && (strcmp(mappingMethod, 'sammon') && size(xy{1}, 1) ~= size(stateSpace, 1))
        choice = questdlg('Sammon mapping was already performed. Do you want to use the previous results?', ...
            'Warning', 'Yes', 'No', 'No');
        
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        
        % Handle response
        switch choice
            case 'Yes'
                mappingPerformed = 1;
                x = xy{1};
                y = xy{2};
            case 'No'
                mappingPerformed = 0;
                myNetwork.MappingResults = [];
                myNetwork.RandomIndicies = [];
        end
    else
        mappingPerformed = 0;
        myNetwork.MappingResults = [];
        myNetwork.RandomIndicies = [];
    end
    
    % PERFORM N-D TO 2-D PROJECTION
    if ~mappingPerformed
        
        if strcmp(mappingMethod, 'sammon')
            % PERFORM SAMMON MAPPING
            xy = sammonMapping(stateSpace);
            x = xy(:,1);
            y = xy(:,2);
            
            % CHECK FOR NANS AND INFS
            allNaNsInX = isnan(x);
            allInfsInX = isinf(x);
            allNaNsInY = isnan(y);
            allInfsInY = isinf(y);
            
            % IF ANY NANS OR INFS ARE FOUND
            if max(allNaNsInX) || max(allNaNsInY) || max(allInfsInX) || max(allInfsInY)
                % LET USER DECIDE IF HE/SHE WANTS TO CONTINUE
                choice = questdlg('The current state space was not able to be projected to 2-Dimsions. The resulting landsacpe may contain artifacts. Consider plotting attractor landscape using simple random (naive) mapping or using a different state space. Do you want to continue?', ...
                    'Warning', ...
                    'Yes', 'No', 'No');
                
                enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
                
                % Handle response
                switch choice
                    case 'Yes'
                        % REMOVE NANS AND INFS
                        x(allNaNsInX) = max(abs(x));
                        y(allNaNsInY) = max(abs(y));
                        x(allInfsInX) = max(x);
                        y(allInfsInY) = max(y);
                    case 'No'
                        return;
                end
            end
            
            % FILE NAME
            fileName = 'Sammon Mapping Results.mat';
        elseif strcmp(mappingMethod, 'naive')
            [x, y] = naiveMapping(stateSpace);
            
            % FILE NAME
            fileName = 'Naive Mapping Results.mat';
        end
        
        % UPDATE NETWORK OBJECT
        myNetwork.MappingResults = {x, y};
        
        % MAKE FOLDER
        PathName = myNetwork.ResultFolderName;
        [~, ~] = mkdir(PathName);
        
        % DATA
        header = {'x', 'y'};
        data = vertcat(header, {x, y}); %#ok<NASGU>
        
        % SAVE MAPPING RESULTS
        save(fullfile(PathName, fileName), 'data');
        clear data;
    end
    
catch
    errormsg = 'Error while projecting the state space';
    return;
end

% UPDATE STEADY STATE PROBABILITIES AND ASSOCIATED CELL FATES
if ~isempty(myNetwork.SteadyStateProbabilities)

    % SAVE ORIGINAL STEADY PROBABILITIES
    originalPini = myNetwork.SteadyStateProbabilities;

    % REMOVE ZEROS
    originalPini(originalPini == 0) = 1000;
    originalPini(originalPini == 1000) = min(originalPini);

    % PROCESS Z DATA STEADY STATE PROBABILITIES
    steadyStateProbs = zeros(size(stateSpace, 1), 1);
    steadyStateProbs(:) = min(originalPini);
    [~, indicies] = ismember(myNetwork.NetworkStateList, stateSpace, 'rows');
    indicies(indicies == 0) = [];
    
    %%%%%%%%%%%%%%%
    for i = 1:numel(indicies)
        steadyStateProbs(indicies(i)) = originalPini(i);
    end
    
    % REPLACE STEADY STATE PROBABILITIES
    myNetwork.SteadyStateProbabilities = steadyStateProbs;

    if ~isempty(myNetwork.AssociatedCellFates)
        originalAssociatedFates = myNetwork.AssociatedCellFates;
        newAssociatedFates = cell(size(stateSpace, 1), 1);
        for i = 1:numel(indicies)
            newAssociatedFates(indicies(i)) = myNetwork.AssociatedCellFates(i);
        end
        myNetwork.AssociatedCellFates = newAssociatedFates;
    end
end

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% PLOT POTENTIAL ENERGY LANDSCAPE
if plotPEL
    plot_PotentialEnergyLandscape(x, y, stateSpace, myNetwork, PlottingOptions2)
    drawnow
end

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% PLOT PROBABILITY LANDSCAPE
if plotPL
    plot_ProbabilityLandscape(x, y, stateSpace, myNetwork, PlottingOptions2)
    drawnow
end

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% PLOT BASIN SIZE LANDSCAPE
if plotBSL
    plot_BasinSizeLandscape(x, y, stateSpace, myNetwork, PlottingOptions2)
    drawnow
end

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% RESTORE ORIGINAL STEADY STATE PROBABILITIES
if ~isempty(myNetwork.SteadyStateProbabilities)
    myNetwork.SteadyStateProbabilities = originalPini;

    % RESTORE ASSOCIATED CELL FATES
    if ~isempty(myNetwork.AssociatedCellFates)
        myNetwork.AssociatedCellFates = originalAssociatedFates;
    end
end

% SAVE STATE SPACE
if  getappdata(0, 'saveModifiedStateSpace');
    try
        save_StateSpace(myNetwork, stateSpace);
    catch
    end
end

end

