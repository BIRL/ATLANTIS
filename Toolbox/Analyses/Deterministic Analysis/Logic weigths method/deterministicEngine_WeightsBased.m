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

function bool = deterministicEngine_WeightsBased(myNetwork, totalProgress)

try
    % CANCEL BUTTON
    cancelButton = CancelSimulationButton;
    movegui(cancelButton, 'northeast');
    setappdata(0,'CancelSimulation', []);
    
    % GET NETWORK PROPERTIES
    aij = myNetwork.EdgeWeights;
    b   = myNetwork.BasalValues';
    totalStates = size(myNetwork.NetworkStateList, 1);
    
    progressbar(0.1, 0);
        
    % SMART SYNCHRONOUS UPDATE TO REDUCE ATTRACTOR SEARCH SPACE
    preliminarySearchResults = synchronousAttractorSearch_WeightsBased(myNetwork);
        
    progressbar(0.4, 0);
    
    % EXTRACTING POTENTIAL ATTRACTORS
    [potentialAttractors, ~, FreQ] = unique(preliminarySearchResults, 'rows');
    
    % ARRAY TO STORE INFO ON WHETHER ATTRACTOR CONFIRMED OR NOT
    checked = zeros(size(potentialAttractors, 1), 1);
    
    % ATTRACTOR LIST SIZE
    attractorTableSize = size(potentialAttractors, 1);
    
    % CREATE EMPTY LIST TO STORE ATTRACTORS AND TYPES
    attractorTable = cell(attractorTableSize, 3);
    
    % ATTRACTOR TABLE ITERATOR
    iterator = 1;
    
%     tic
    % CONFIRM ATTRACTORS
    for state = 1:size(potentialAttractors)
        % UPDATE PROGRESS BAR
        progressbar(totalProgress, state/attractorTableSize);
        
        if ~checked(state)
            
            % GET CURRENT STATE
            currentState = potentialAttractors(state, :);
            
            % SEARCHING FOR ATTRACTOR IN SINGLE STATE
            attractor = searchForAttractor(currentState);
            
            if ~isempty(attractor)
                
                % ATTRACTOR SIZE
                attrSize = size(attractor, 1);
                
                % FIND ATTRACTOR TYPES
                if attrSize > 1
                    attractorTypes = 'Cyclic';
                    % SORT ATTRACTOR
                    %                 attractor = sortrows(attractor);
                    
                    % CHECK IF ANY STATE OF THIS ATTRACTOR IS PRESENT IN POTENTIAL ATTR
                    % LIST
                    [~, locA] = ismember(attractor, potentialAttractors, 'rows');
                    locA(locA == 0) = [];
                    checked(locA) = 1;
                elseif attrSize == 1
                    locA = state;
                    attractorTypes = 'Point';
                end
                
                % COMPUTE BASIN SIZE
                if numel(locA) > 1
                    attractorsIndicies = find(ismember(FreQ, locA, 'rows') ~= 0);
                else
                    attractorsIndicies = find(FreQ == state);
                end
                
                % CANCEL SIMULATION
                if ~isempty(getappdata(0,'CancelSimulation'))
                    cancelButton.delete;
                    undefined/0;
                end
                
                basinSizeRatio = numel(attractorsIndicies)/totalStates;
                
                % CHECK IF ATTRACTOR IS ALREADY PRESENT
                present = 0;
                for k = iterator-1:-1:1
                    attractorList = attractorTable{k,1};
                    [~, match] = ismember(attractorList, attractor, 'rows');
                    
                    % IF PRESENT THAN UPDATE BASIN SIZE RATIO
                    if match ~= 0
                        attractorTable{k,3} = attractorTable{k,3} + basinSizeRatio;
                        present = 1;
                        break;
                    end
                end
                
                if present == 0
                    % SAVE THE NEW ATTRACTOR
                    attractorTable(iterator,:) = {attractor, attractorTypes, basinSizeRatio};
                    iterator = iterator + 1;
                end
            end
        end
    end
    
    % DELETE CANCEL BUTTON
    cancelButton.delete;
    
    % CLOSE PROGRESSBAR
    progressbar(totalProgress, 1);
        
    % REMOVE EMPTY CELLS
    emptY = cellfun(@isempty, attractorTable(:, 1));
    attractorTable(emptY, :) = [];
    
    % UDPATE NETWORK PROPERTIES
    myNetwork.AttractorTable = flipud(sortCellArr(attractorTable, 3));
    
    % SUCCESS
    bool = 1;
    
%     disp(['DA Result Processing time: ', num2str(toc)])
    
catch
    % FAILURE
    bool = 0;
    progressbar(totalProgress, 1);
    cancelButton.delete;
%     disp(['End of Deterministic analysis. Unsuccessful', 'Time elapsed', num2str(toc)])
end

    function attractor = searchForAttractor(CurrentState, ~)
        
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