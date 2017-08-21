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


function bool = deterministicEngine_WeightsBased(myNetwork, totalProgress)

try

% GET NETWORK PROPERTIES
aij = myNetwork.EdgeWeights;
b   = myNetwork.BasalValues';
initialStates = myNetwork.NetworkStateList;
totalStates = size(initialStates, 1);

% CREATE EMPTY LIST TO STORE ATTRACTORS AND TYPES
attractorList = cell(1,totalStates);
attractorTypes = cell(1,totalStates);

% UPDATE EACH STATE UNTIL ATTRACTOR STATE IS ACHIEVED
for state = 1:totalStates
    progressbar(totalProgress, state/totalStates);
    currentState = initialStates(state, :);
    attractor = searchForAttractor(currentState, [state, totalStates]);
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
[uniqueAttractors , uniqueAttractorsIndicies, occurences] = ...
                                    uniqueCellArray(attractorStringList);
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

    function attractor = searchForAttractor(CurrentState, progressbarInfo)
        
        % WILL STORE A POINT OR CYLIC ATTRACTOR
        attractor = [];
        
        % TRAJECTORY MAPPING SIZE
        searchDuration = myNetwork.AttractorSearchDuration;
        
        % INITIALIZE NEXT STATE
        nextState = CurrentState;
        
        % WILL STORE NETWORK STATES TRAJECTORY THAT LEAD TO ATTRACTOR
        trajectoryCell = cell(1, searchDuration);
        trajectoryVec = zeros(searchDuration, myNetwork.NodeCount);
        
        for step = 1:searchDuration
            % UPDATE PROGRESS BAR
%             progressbar(progressbarInfo(1)/progressbarInfo(2), step/searchDuration);
            
            % UPDATE TRAJECTORY
            trajectoryCell{step} = CurrentState;
            trajectoryVec(step, :) = CurrentState;
            
            % FIND ACCUMULATIVE EFFECT OF INTERACTORS AND BASAL VALUES ON
            % EACH NODE
            summation = CurrentState* aij + b;
            
            % IF THE 'summation' > 0 THEN NEXT STATE = 1
            % (EFFECT OF NEGATIVE REGULATION < POSITIVE REGULATION)
            indices = summation > 0;
            nextState(indices) = 1;
            
            % IF THE 'summation' < 0 THEN NEXT STATE = 0
            % (EFFECT OF NEGATIVE REGULATION > POSITIVE REGULATION)
            indices = summation < 0;
            nextState(indices) = 0;
            
            % IF THE 'summation' = 0 THEN NEXT STATE = CURRENT STATE
            % (EFFECT OF NEGATIVE REGULATION == POSITIVE REGULATION)
            indices = summation == 0;
            nextState(indices) = CurrentState(indices);
            
            % CHECK IF THE NEXT STATE IS PRESENT IN THE TRAJECTORY
            index = find(cellfun(@(a) isequal(a,nextState), trajectoryCell(1:step)), 1);
            
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
            
            % SET CURRENT STATE TO NEXT STATE
            CurrentState = nextState;
            
        end
    end
end