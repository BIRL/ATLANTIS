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

function bool = save_ProbabilisticAnalysisResults( myNetwork )
% SAVES PROBABILISTIC ANALYSIS RESULTS

try
    
    % PROGRESS BAR
    progressbar('Saving results...');
    
    % EXTRACT RESULTS FOLDER PATH
    if ~isempty(myNetwork.FileName)
        PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', '\'), 'Probabilistic Analysis Output\'];
    else
        PathName = [myNetwork.ResultFolderName, 'Probabilistic Analysis Output\'];
    end
    
    % MAKE FOLDER
    [~, ~] = mkdir(PathName);
    
    % SAVE STEADY STATE AND STATE TRANSITION PROBABILITIES
    if ~isempty(myNetwork.SteadyStateProbabilities)
        % FILE NAMES
        FileName2 = [myNetwork.FileName, 'Steady State Probabilities', '.csv'];
        
        % GET DATA
        initialStates = num2cell(myNetwork.NetworkStateList);
        Pini = num2cell(myNetwork.SteadyStateProbabilities);
        attrCount = 1:size(myNetwork.NetworkStateList, 1);
        attrCount = attrCount';
        names = myNetwork.NodeNames;
        if size(names, 1) > 1
            names = names';
        end
        
        progressbar(0.2/1);
        
        % ASSOCIATE CELL FATES
        if ~isempty(myNetwork.CellFateDeterminationLogic)
            associatedCellFates = myNetwork.AssociatedCellFates;
        else
            associatedCellFates = cell(size(initialStates, 1), 1);
        end
        
        % FORMAT DATA
        data2 = horzcat(num2cell(attrCount), associatedCellFates, Pini, initialStates);
        
        header2 = horzcat({'#'}, 'Associated Cell Fates', 'Steady State Probability', names);
        
        % SAVE TO CSV
        cell2csv(strcat(PathName, FileName2), vertcat(header2, data2));
        progressbar(0.4/1);
    end
    
    % CLEAR VAR TO SAVE SPACE
    clear Tij Pini initialStates attractorList associatedCellFates attrCount data1 data2 header1 header2
    
    % SAVE TRAJECTORY
    if ~isempty(myNetwork.Trajectory)
        % UPDATE FILE NAME
        FileName = [myNetwork.FileName, 'Mapped Trajectory', '.csv'];
        
        % GET NETWORK DATA
        trajectory = myNetwork.Trajectory;
        statesInTrajectory = trajectory(:, 3:end);
        stateProbabilites = trajectory(:, 2);
        stateNum = trajectory(:, 1);
        names = myNetwork.NodeNames;
        if size(names, 1) > 1
            names = names';
        end
        
        progressbar(0.6/1);
        
        % ASSOCIATE CELL FATES
        if ~isempty(myNetwork.CellFateDeterminationLogic)
            outputNodeStates = cellfun(@(a) a(:, myNetwork.OutputNodesIndices), ...
                num2cell(statesInTrajectory, 2), 'un', 0);
            
            associatedCellFates = cellfun(@(attr) associate_CellFates...
                (myNetwork.CellFateDeterminationLogic, attr, ...
                numel(myNetwork.UniqueCellFates)), outputNodeStates);
        else
            associatedCellFates = cell(size(stateProbabilites, 1), 1);
        end
        
        % FORMAT DATA
        data = horzcat(num2cell(stateNum), associatedCellFates, num2cell(stateProbabilites), num2cell(statesInTrajectory));
        header = horzcat({'#'}, 'Associated Cell Fate', 'Probabilities', names);
        
        % SAVE TO CSV
        cell2csv(strcat(PathName, FileName), vertcat(header, data));
        progressbar(0.8/1);
    end
    
    % CLEAR VAR TO SAVE SPACE
    clear data header stateProbabilites statesInTrajectory trajectory associatedCellFates
    
    % REMOVE STATE TRANSITION PROBABILITIES TO CREATE SPACE
    myNetwork.StateTransitionProbabilities = 'Removed';

    % SAVE NETWORK STATE LIST
    FileName = [myNetwork.FileName, 'Network State List'];
    
    networkStateList = myNetwork.NetworkStateList;

    % SAVE NETWORK STATE LIST
    cell2csv(strcat(PathName, FileName, '.csv'), num2cell(networkStateList));
    save(strcat(PathName, FileName, '.mat'), 'networkStateList', '-v7.3');

    progressbar(1/1);
        
    % SUCCESS
    bool = 1;
    
    % CLOSE ANY OPEN FILES
    fclose all;
    
catch
    % FAILURE
    bool = 0;
    progressbar(1/1);
end

end