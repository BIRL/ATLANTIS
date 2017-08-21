%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ATLANTIS: Attractor Landscape Analysis Toolbox for        %
%              Cell Fate Discovery and Reprogramming               %
%                           Version 1.0.0                          %
%     Copyright (c) Biomedical Informatics Research Laboratory,    %
%      Lahore University of Management Sciences Lahore (LUMS),     %
%                            Pakistan.                             %
%                 http://biolabs.lums.edu.pk/birl)                 %
%                     (safee.ullah@gmail.com)                      %
%                  Last Modified on: 09-August-2017                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool = map_Trajectory(obj)
% Finds transients states between a specified start and end state

try
    % GET DATA
    trajectoryBounds = obj.TrajectoryBounds;
    data = [obj.SteadyStateProbabilities, obj.NetworkStateList];
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
    [~, indicies] = ismember(transientStates(:, 2:end), obj.NetworkStateList, 'rows');
    
    % CROP TRAJECTORY AND UPDATE THE NETWORK PROPERTIES
    obj.Trajectory = horzcat(indicies, transientStates);
    
    % SUCCESS
    bool = 1;
catch
    % FAILURE
    bool = 0;
end

end