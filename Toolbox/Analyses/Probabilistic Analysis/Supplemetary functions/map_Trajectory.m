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

function bool = map_Trajectory(myNetwork)
% Finds transients states between a specified start and end state

try
    % GET DATA
    trajectoryBounds = myNetwork.TrajectoryBounds;
            
    data = [myNetwork.SteadyStateProbabilities, myNetwork.NetworkStateList];
    data = flipud(sortrows(data, 1));
    
    % FIND START AND END STATE POSITIONS
    [~, ind1] = ismember(trajectoryBounds(1, :), data(:, 2:end), 'rows');
    [~, ind2] = ismember(trajectoryBounds(2, :), data(:, 2:end), 'rows');
    
    % ARBITORILY ASSIGN IND1 AND IND2 TO END AND START STATE
    endStateIndex = ind1;
    startStateIndex = ind2;
    
    % CORRENT ASSIGNMENT IF WRONG
    if ind1 < ind2
        endStateIndex = ind2;
        startStateIndex = ind1;
    end
    
    % TRANSIENT STATES
    transientStates = data(startStateIndex:endStateIndex, :);
    
    % FIND ORIGINAL INDICIES OF THE TRAISIENT
    [~, indicies] = ismember(transientStates(:, 2:end), myNetwork.NetworkStateList, 'rows');
    
    % ASSOCIATE CELL FATES
    if ~isempty(myNetwork.CellFateDeterminationLogic)
        outputNodeStates = cellfun(@(a) a(:, myNetwork.OutputNodesIndices), ...
            num2cell(transientStates(:, 2:end), 2), 'un', 0);

        associatedCellFates = cellfun(@(attr) associate_CellFates...
            (myNetwork.CellFateDeterminationLogic, attr, ...
            numel(myNetwork.UniqueCellFates)), outputNodeStates);
    else
        associatedCellFates = cell(size(transientStates, 1), 1);
    end
    
    % CROP TRAJECTORY AND UPDATE THE NETWORK PROPERTIES
    myNetwork.Trajectory = {indicies, associatedCellFates, transientStates};
    
    % SUCCESS
    bool = 1;
catch
    % FAILURE
    bool = 0;
end

end