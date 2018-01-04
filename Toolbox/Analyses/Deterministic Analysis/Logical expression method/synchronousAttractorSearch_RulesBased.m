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

function preliminarySearchResults = synchronousAttractorSearch_RulesBased(myNetwork)

% GET VARIABLES
targetNodeIndicesList = myNetwork.TargetNodeIndices;
sourceNodeIndicesList = myNetwork.SourceNodeIndices;
initialStates         = myNetwork.NetworkStateList;
truthTables           = myNetwork.TruthTables;
updatedStates = initialStates;

iterator = myNetwork.NodeCount;

currentPotentialAttrsCount = 0;

similarityCount = 0;

%-- Updating initial states --%
tic;
for iterations = 1 : iterator
    
    progressbar(iterations/(iterator*2), 0);
    
    %     tic;
    for node = 1 : myNetwork.NodeCount
        
        % GET TARGET NODE INDEX
        targetNode = targetNodeIndicesList{node};
        
        % FIND NEXT STATE OF TARGET NODE
        updatedTargetNodeStates = initialStates(:, targetNode);
        
        % GET SOURCE NODE INDICIES
        sourceNodes = sourceNodeIndicesList{node};
        
        if ~isempty(sourceNodes)
            % GET CURRENT STATE OF SOURCE NODES
            currentStates = initialStates(:, sourceNodes);
                        
            % FIND NEXT STATE OF TARGET NODE
            truthTable =truthTables{targetNode};
            outputs = truthTable(:, end);
            
            % IF ALL OUTPUTS == 0
            if sum(outputs) == 0
                updatedTargetNodeStates(:) = 0;
                % IF ALL OUTPUTS == 1
            elseif sum(outputs) == size(truthTable, 1)
                updatedTargetNodeStates(:) = 1;
                % IF MIXED
            else
%                 inputs = truthTable(:, 1:end-1);
                locA = binary2Decimal(currentStates) + 1;
                
                locA(locA == 0) = updatedTargetNodeStates(locA == 0);
                updatedTargetNodeStates = outputs(locA);
            end
        end
        
        % UPDATE TARGET NODE STATE
        updatedStates(:, targetNode) = updatedTargetNodeStates;
    end
    %     toc;
    
    oldPotentialAttrsCount = currentPotentialAttrsCount;
    currentPotentialAttrsCount = numel(unique(updatedStates, 'rows'));
    
%     disp(['Iteration: ', num2str(iterations), ' | unique Attrs: ',...
%                     num2str(currentPotentialAttrsCount)]);
    
    if abs(oldPotentialAttrsCount - currentPotentialAttrsCount) == 0
        similarityCount = similarityCount + 1;
        if similarityCount >= 3
            break;
        end
    else
        similarityCount = 0;
    end
    
    initialStates = updatedStates;
end
toc;

preliminarySearchResults = updatedStates;

end