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

function bool = save_DeterministicAnalysisResults( myNetwork )
% SAVES DETERMINISTIC ANALYSIS RESULTS

try
    % PROGRESS BAR
    %                                                                                                                                                 
    progressbar('Saving results...');
    
    % EXTRACT RESULTS FOLDER PATH
    if ~isempty(myNetwork.FileName)
        PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', '\'), 'Deterministic Analysis Output\'];
    else
        PathName = [myNetwork.ResultFolderName, 'Deterministic Analysis Output\'];
    end
    
    % MAKE FOLDER
    [~, ~] = mkdir(PathName);
    
    % SAVE UNIQUE ATTRACTOR LIST
    if ~isempty(myNetwork.AttractorTable)
        % UPDATE FILE NAME
        FileName1 = [myNetwork.FileName, ...
            'Attractor Table (Stratified Average Activity)', '.csv'];
        FileName2 = [myNetwork.FileName, ...
            'Attractor Table (Average Activity in Fractions)', '.csv'];
        FileName3 = [myNetwork.FileName, ...
            'Attractor Table', '.csv'];
        
        % SUMMARIZE ATTRACTOR ACTIVITIES
        attractorTable = myNetwork.AttractorTable;
        upperbound = 0.2;
        lowerbound = 0.2;
        [attractorActivityInFractions, attractorActivityAsWhole] = ...
            cellfun(@(a)summarize_AttractorActivity (a, upperbound, lowerbound)...
            , attractorTable(:, 1), 'un', 0);
        
        % GET NETWORK DATA
        attrCount = num2cell(1:size(attractorTable, 1))';
        attrType = attractorTable(:, 2);
        basinSizes = attractorTable(:, 3);
        
        % ASSOCIATE CELL FATES
        if ~isempty(myNetwork.CellFateDeterminationLogic)
            associatedCellFates = attractorTable(:, 4);
        else
            associatedCellFates = cell(size(attractorActivityAsWhole, 1), 1);
        end
        
        % FORMAT DATA
        attractorActivityAsWhole = num2cell(cell2mat(attractorActivityAsWhole));
        attractorActivityInFractions = num2cell(cell2mat(attractorActivityInFractions));
        
        data1 = horzcat(attrCount, attrType, associatedCellFates, basinSizes, attractorActivityAsWhole);
        data2 = horzcat(attrCount, attrType, associatedCellFates, basinSizes, attractorActivityInFractions);
        data3 = horzcat(attrCount, attrType, associatedCellFates, basinSizes, attractorTable(:, 1));
        
        datA3 = cell(size(cell2mat(attractorTable(:, 1)), 1), size(data2, 2));
        iterator = 0;
        
        for i = 1:size(attractorTable, 1)
            attr = attractorTable{i, 1};
            attrSize = size(attr, 1);
            temp = horzcat(repmat(data3(i, 1:end-1), [attrSize 1]), num2cell(data3{i, end}));
            datA3(1 + iterator:iterator + attrSize, :) = temp;
            iterator = iterator + attrSize;
        end
        
        names = myNetwork.NodeNames;
        
        % SET ORIENTATION OF THE NAMES
        if size(names, 1) > 1
            names = names';
        end
        
        header1 = horzcat({'#'}, 'Attractor Type', 'Associated Cell Fate', 'Basin Size', names);
        
        % SAVE TO CSV
        cell2csv(strcat(PathName, FileName1), vertcat(header1, data1));
        cell2csv(strcat(PathName, FileName2), vertcat(header1, data2));
        progressbar(0.6/1);
        cell2csv(strcat(PathName, FileName3), vertcat(header1, datA3));
        progressbar(0.8/1);
    end

    % CLEAR VAR TO SAVE SPACE
    clear results attrCount attractorActivityAsWhole attractorActivityInFractions associatedCellFates data1 data2 data3
    
    % SAVE CELL FATE TABLE
    if ~isempty(myNetwork.CellFateLandscape)
        % UPDATE FILE NAME
        FileName = [myNetwork.FileName, 'Cell Fate Propensites', '.csv'];
        
        % FORMAT DATA
        cellfateTable = myNetwork.CellFateLandscape;
        header = {'Cell fate', 'Propensity'};
        
        % SAVE TO CSV
        cell2csv(strcat(PathName, FileName), vertcat(header, cellfateTable));
    end

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

