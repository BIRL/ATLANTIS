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

function bool = save_ProbabilisticAnalysisResults( myNetwork )
% SAVES PROBABILISTIC ANALYSIS RESULTS

% if ~isempty(myNetwork.Time)
%     time = myNetwork.Time;
% end

try
    
    % PROGRESS BAR
    progressbar('Saving results...');
    
    % EXTRACT RESULTS FOLDER PATH
    if ~isempty(myNetwork.FileName)
        PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', filesep), 'Probabilistic Analysis Output', filesep];
    else
        PathName = [myNetwork.ResultFolderName, 'Probabilistic Analysis Output', filesep];
    end
        
    % MAKE FOLDER
    [~, ~] = mkdir(PathName);
        
    % CHECK IF USER CHOOSE TO PRUNE STATE SPACE
    if myNetwork.PruneStateSpace == 1
        stateSpace = myNetwork.PrunnedStateSpacePA;
    else
        stateSpace = myNetwork.NetworkStateList;
    end
        
    %# 1. SAVE STEADY STATE AND STATE TRANSITION PROBABILITIES
    if ~isempty(myNetwork.SteadyStateProbabilities)
        
        % FILE NAMES
        FileName2 = [myNetwork.FileName, 'Steady State Probabilities', '.csv'];
        
        % NODE NAMES
        names = myNetwork.NodeNames;
        if size(names, 1) > 1
            names = names';
        end
        
        % STEADY STATE PROBABILITES (SSPs)
        SSPs = myNetwork.SteadyStateProbabilities;
        
        progressbar(0.2/1);
                
        % ASSOCIATE CELL FATES
        if ~isempty(myNetwork.CellFateDeterminationLogic)

            associatedCellFates = myNetwork.AssociatedCellFates;
            
            % IF STATE SPACE IS PRUNNED GET THE ASSOCIATED FATES FOR THE
            % PRESENT STATES
            if size(associatedCellFates, 1) ~= size(stateSpace, 1)
                
                % FIND LOCATIONS OF CHARACTERIZED STATES
                [~, locA] = ismember(stateSpace, myNetwork.NetworkStateList, 'rows');
                
                % ASSOCIATE CELL FATES IF STATES NOT CHARACTERIZED
                if min(locA) == 0
                    outputNodeActivities = cellfun(@(a) a(:, myNetwork.OutputNodesIndices), ...
                        num2cell(stateSpace, 2), 'un', 0);
                    
                    associatedCellFates = cellfun(@(attr) associate_CellFates...
                        (myNetwork.CellFateDeterminationLogic, attr, ...
                        numel(myNetwork.UniqueCellFates)), outputNodeActivities);
                else
                    associatedCellFates = associatedCellFates(locA);
                end
            end
            
        else
            associatedCellFates = cell(size(stateSpace, 1), 1);
        end
                
        % CREATING HEADER
        header = horzcat({'Attractor #'}, 'Associated Cell Fate', 'Steady State Probability');
        
        % CREATE FILES
        try
            fid = fopen(strcat(PathName, FileName2), 'w');
        catch
            fid = fopen(strcat(PathName, FileName2,' (2)'), 'w');
        end
        
        formatToken = '%s,';
        
        % ADDING HEADERS
        fprintf(fid, formatToken, header{:, 1:3}, names{:});
        fprintf(fid, ['\', 'n']);
        
        % POPULATING FILES
        for i = 1:size(SSPs, 1)  
            attrNumb = int2str(i);
            associatedFate = associatedCellFates{i};
            propensity = num2str(SSPs(i));
            
            % POPULATE FILE
            fprintf(fid, '%s,', attrNumb, associatedFate, propensity);
            fprintf(fid, '%u,', stateSpace(i, :));
            fprintf(fid, ['\', 'n']);
        end
        
        progressbar(0.4/1);
        
        fclose(fid);
        
        % CLEAR VAR TO SAVE SPACE
        clear attrCount associatedCellFates SSPs
    end
    
    
    %# 2. SAVE TRAJECTORY
    if ~isempty(myNetwork.Trajectory)

        % UPDATE FILE NAME
        FileName = [myNetwork.FileName, 'Mapped Trajectory', '.csv'];
        
        % GET DATA
        trajectory = myNetwork.Trajectory;
        statesInTrajectory = trajectory{3}(:, 2:end);
        stateProbabilites = trajectory{3}(:, 1);
        stateNum = trajectory{1};
        associatedCellFates = trajectory{2};
        
        names = myNetwork.NodeNames;
        if size(names, 1) > 1
            names = names';
        end
        
        progressbar(0.6/1);
        
        % FORMAT DATA
        header = horzcat({'#'}, 'Associated Cell Fate', 'Probabilities', names);
        
        % CREATE FILES
        try
            fid = fopen(strcat(PathName, FileName), 'w');
        catch
            fid = fopen(strcat(PathName, FileName,' (2)'), 'w'); 
        end
        
        formatToken = '%s,';
        
        % ADDING HEADERS
        fprintf(fid, formatToken, header{:, 1:3}, names{:});
        fprintf(fid, ['\', 'n']);
        
        % POPULATING FILES
        for i = 1:size(stateNum, 1)  
            attrNumb = int2str(stateNum(i));
            associatedFate = associatedCellFates{i};
            propensity = num2str(stateProbabilites(i));
            
            % POPULATE FILE
            fprintf(fid, '%s,', attrNumb, associatedFate, propensity);
            fprintf(fid, '%u,', statesInTrajectory(i, :));
            fprintf(fid, ['\', 'n']);
        end
                
        fclose(fid);
       
        progressbar(0.8/1);
    end
    
    if ~isempty(myNetwork.SteadyStateTimeStep) && myNetwork.SteadyStateTimeStep > 0
        FileName = [myNetwork.FileName, ' Steady State iteration'];
        
        fid6 = fopen(strcat(PathName, FileName, '.txt'), 'w');        
        
        % ADD information
        fprintf(fid6, '%s', ['Iterations (Simulation Timesteps) taken to find steady state probabilities: ', num2str(myNetwork.SteadyStateTimeStep)]);
        
        fclose(fid6);
    end
    
    % CLEAR VAR TO SAVE SPACE
    clear data header stateProbabilites statesInTrajectory trajectory associatedCellFates

    if myNetwork.PruneStateSpace == 1        
        % FILE NAME IN WHICH NETWORK STATE LIST WILL BE SAVE
        FileName = 'Prunned Network State List PA';
    else
        % FILE NAME IN WHICH NETWORK STATE LIST WILL BE SAVE
        FileName = 'Network State List PA';
    end
    
    % SAVE NETWORK STATE LIST
    csvwrite(strcat(PathName, FileName, '.csv'), stateSpace);
    save(strcat(PathName, FileName, '.mat'), 'stateSpace', '-v7.3');

    progressbar(1/1);
        
    % SUCCESS
    bool = 1;
    
    %$
%     if ~isempty(myNetwork.Time)
%         time = [time, '  ', 'time taken to save results: ', num2str(toc)];
%         timeFile = fopen(strcat(PathName, 'Run Time Analysis PA.txt'), 'w');
%         fprintf(timeFile, '%s', time);
%         fclose(timeFile);
%     else
%         toc;
%     end
    
catch
    % FAILURE
    bool = 0;
    progressbar(1/1);
    
    % CLOSE ANY OPEN FILES
    fclose all;
end

end