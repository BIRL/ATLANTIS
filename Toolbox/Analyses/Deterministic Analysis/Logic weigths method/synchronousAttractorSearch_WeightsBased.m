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

function preliminarySearchResults = synchronousAttractorSearch_WeightsBased(myNetwork)

initialStates = myNetwork.NetworkStateList;
updatedStates = initialStates;

if size(myNetwork.BasalValues, 1) > 1
    bi = myNetwork.BasalValues';
else
    bi = myNetwork.BasalValues;
end

% REPLICATE BASAL VALUES FOR FASTER COMPUTATION
basalVec = repmat(bi, [size(myNetwork.NetworkStateList, 1), 1]);

iterator = myNetwork.NodeCount;

similarityCount = 0;

currentPotentialAttrsCount = 0;

%-- Updating initial states --%
% tic;
for k = 1 : iterator
    
    Summation = initialStates*(myNetwork.EdgeWeights) + basalVec;
    
    % Finding the indices in the summation matrix at which the elements are greater than zero
    updatedStates(Summation > 0) = 1;
    
    % Finding the indices in the summation matrix at which the elements are less than zero
    updatedStates(Summation < 0) = 0;
    
    % Finding the indices in the summation matrix at which the elements are equal to zero
    updatedStates(Summation == 0) = initialStates(Summation == 0);    
    
    oldPotentialAttrsCount = currentPotentialAttrsCount;
    currentPotentialAttrsCount = numel(unique(updatedStates, 'rows'));
    
%     disp(['Iteration: ', num2str(k), ' | unique Attrs: ',...
%                     num2str(currentPotentialAttrsCount)]);
    
%     if isequal(updatedStates,initialStates)
%         break;
%     end
    
    if abs(oldPotentialAttrsCount - currentPotentialAttrsCount) == 0
        similarityCount = similarityCount + 1;
        if similarityCount >= 5
            break;
        end
    else
        similarityCount = 0;
    end
    
    initialStates = updatedStates;
end
% toc;

preliminarySearchResults = updatedStates;

end