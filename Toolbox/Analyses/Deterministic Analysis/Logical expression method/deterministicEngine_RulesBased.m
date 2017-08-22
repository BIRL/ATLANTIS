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

function bool = deterministicEngine_RulesBased(myNetwork, totalProgress)

try

% GET NETWORK PROPERTIES
targetNodeIndicesList = myNetwork.TargetNodeIndices;
sourceNodeIndicesList = myNetwork.SourceNodeIndices;
NodeUpdateLogicList   = myNetwork.NodeUpdateLogic;
initialStates = myNetwork.NetworkStateList;
totalStates = size( initialStates , 1 );

% CREATE EMPTY LIST TO STORE ATTRACTORS AND TYPES
attractorList = cell(1,totalStates);
attractorTypes = cell(1,totalStates);

% UPDATE EACH STATE UNTIL ATTRACTOR STATE IS ACHIEVED
for state = 1:totalStates
    currentState = initialStates(state,:);
    progressbar(totalProgress, state/totalStates)
    attractor = searchForAttractor(currentState, targetNodeIndicesList, sourceNodeIndicesList, NodeUpdateLogicList, [state,totalStates]);
    attractorList{state} = attractor;
    
    % FIND ATTRACTOR TYPES
    if size(attractor, 1) > 1
        attractorTypes{state} = 'Cyclic';
    elseif size(attractor, 1) == 1
        attractorTypes{state} = 'Point';
    end
end

% CLOSE PROGRESSBAR
progressbar(totalProgress, 1);

% REMOVE EMPTY CELLS
emptY = cellfun(@isempty, attractorList);
attractorList(emptY) = [];
attractorTypes(emptY) = [];

% SORT CYCLIC ATTRACTORS AND CONVERT NUMBERS TO STRING
attractorListSorted = cellfun(@sortrows, attractorList, 'un', 0);
attractorStringList = cellfun(@int2str, attractorListSorted, 'un', 0);

% FIND FREQUENCY OF EACH ATTRACTOR
[uniqueAttractors , uniqueAttractorsIndicies, occurences] = uniqueCellArray(attractorStringList);
attractorBasinSizes = attractorFrequency(occurences);

% CREATE ATTRACTOR TABLE
attractorTable      = cell(numel(uniqueAttractors), 3);
attractorTable(:,1) = cellfun(@str2num, uniqueAttractors,'un',0); % STORES ATTRACTORS
attractorTable(:,2) = attractorTypes(uniqueAttractorsIndicies)'; % STORE ATTRACTOR TYPE
attractorTable(:,3) = num2cell(attractorBasinSizes(:, 3), 2); % STORES BASIN RATIOS

% UDPATE NETWORK PROPERTIES
myNetwork.AttractorTable = flipud(sortCellArr(attractorTable, 3));
myNetwork.AttractorList = attractorList';
myNetwork.AttractorTypes = attractorTypes';

% SUCCESS
bool = 1;

catch
    % FAILURE
    bool = 0;
    progressbar(totalProgress, 1);
end

    function attractor = searchForAttractor(currentState, targetNodeIndices, sourceNodeIndices, updateLogics, progressbarInfo)
        
        % WILL STORE A POINT OR CYLIC ATTRACTOR
        attractor = []; 
        
        % TRAJECTORY MAPPING SIZE
        searchDuration = myNetwork.AttractorSearchDuration; 
        
        % WILL STORE NETWORK STATES TRAJECTORY THAT LEAD TO ATTRACTOR
        trajectoryCell = cell(1,searchDuration);
        trajectoryVec = zeros(searchDuration, myNetwork.NodeCount);
        
        for step = 1:searchDuration
            % UPDATE PROGRESS BAR
%             progressbar(progressbarInfo(1)/progressbarInfo(2), step/searchDuration);
            
            % UPDATE TRAJECTORY
            trajectoryCell{step} = currentState;
            trajectoryVec(step, :) = currentState;
            
            % FIND NEXT STATE
            nextState = UpdateState(currentState);
            
            % CHECK IF THE NEXT STATE IS PRESENT IN THE TRAJECTORY
            index = find(cellfun(@(a) isequal(a,nextState), trajectoryCell(1:step)), 1); % check if updated state is already present in the trajectory
            
            if ~isempty(index) % IF TRUE THAN CYCLE FOUND
                % REMOVE EMPTY ENTERIES
                trajectoryVec(step+1:end, :) = [];
                
                % FIND START AND END OF CYCLIC ATTRACTOR
                startMark = size(trajectoryVec, 1) - (step - index);
                endMark = step;
                
                % CROP THE ATTRACTOR FROM THE TRAJECTORY
                attractor = trajectoryVec(startMark:endMark, :);
                
                % STOP THE SEARCH
                break;
            end
            
            currentState = nextState;
        end
        
        function nextstate = UpdateState(currentState)
            
            nextstate = currentState;
            
            % UPDATE EACH NODE STATE
            for i = 1:size(sourceNodeIndices,1)
                nextstate(i) = UpdateNodeActivty(sourceNodeIndices{i}, targetNodeIndices{i});
            end
            
            function updatedNode = UpdateNodeActivty(SourceNodeIndex, targetNodeIndex)
                try
                    % FIND NEW NODE STATE
                    updatedNode = updateLogics{targetNodeIndex}(binary2Decimal(currentState(SourceNodeIndex)) + 1);
                    
                    if isempty(updatedNode)
                        updatedNode = currentState(targetNodeIndex);
                    end
                    
                catch
                    updatedNode = currentState(targetNodeIndex);
                end
            end
            
        end
        
    end

end