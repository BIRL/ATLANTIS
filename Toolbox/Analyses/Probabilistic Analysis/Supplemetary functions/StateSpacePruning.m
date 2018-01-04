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

function prunnedStateSpace = StateSpacePruning(myNetwork)

% GET INITIAL STATE LIST
initialStatesList = myNetwork.NetworkStateList;
updatedStateList = initialStatesList;

prunnedStateSpace = [];

% CORRECT BASAL VALUES DIMENSIONS
if size(myNetwork.BasalValues, 1) > 1
    bi = myNetwork.BasalValues';
else
    bi = myNetwork.BasalValues;
end

% FIND STATE UPDATE PROPENSITIES
NodeStateUpdateSummmation = initialStatesList*(myNetwork.EdgeWeights) + repmat(bi, [size(initialStatesList, 1), 1]);

% UPDATE NODE STATES
% 1) > 0
indices = NodeStateUpdateSummmation > 0;
updatedStateList(indices) = 1;

% 2) < 0
indices = NodeStateUpdateSummmation < 0;
updatedStateList(indices) = 0;

% 3) == 0
indices = find(NodeStateUpdateSummmation == 0);
updatedStateList(indices) = initialStatesList(indices);

% FIND UNIQUE NETWORK STATES
prunnedStateSpace = unique([prunnedStateSpace; updatedStateList], 'rows');

end