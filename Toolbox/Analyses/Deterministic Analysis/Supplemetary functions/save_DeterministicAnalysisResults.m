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

function bool = save_DeterministicAnalysisResults( myNetwork )
% SAVES DETERMINISTIC ANALYSIS RESULTS

% if ~isempty(myNetwork.Time)
%     time = myNetwork.Time;
% end

% tic;

try 
    % PROGRESS BAR                                                                                                                                                 
    progressbar('Saving results...');
    
    % EXTRACT RESULTS FOLDER PATH
    if ~isempty(myNetwork.FileName)
        PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', filesep), 'Deterministic Analysis Output', filesep];
    else
        PathName = [myNetwork.ResultFolderName, 'Deterministic Analysis Output', filesep];
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
        attrType = attractorTable(:, 2);
        basinSizes = attractorTable(:, 3);
        
        % ASSOCIATE CELL FATES
        if ~isempty(myNetwork.CellFateDeterminationLogic)
            associatedCellFates = attractorTable(:, 4);
        else
            associatedCellFates = cell(size(attractorActivityAsWhole, 1), 1);
        end
        
        progressbar(0.3/1);
        
        % SET ORIENTATION OF THE NAMES
        names = myNetwork.NodeNames;
        
        if size(names, 1) > 1
            names = names';
        end
        
        % CREATING HEADER
        header = horzcat({'Attractor #'}, 'Attractor Type', 'Associated Cell Fate', 'Basin Size');
        
        % CREATE FILES
        fid1 = fopen(strcat(PathName, FileName1), 'w');
        fid2 = fopen(strcat(PathName, FileName2), 'w');
        fid3 = fopen(strcat(PathName, FileName3), 'w');
        
        formatToken = '%s,';
        
        % ADDING HEADERS
        fprintf(fid1, formatToken, header{:, 1:4}, names{:});
        fprintf(fid1, [filesep, 'n']);
        
        fprintf(fid2, formatToken, header{:, 1:4}, names{:});
        fprintf(fid2, [filesep, 'n']);
        
        fprintf(fid3, formatToken, header{:, 1:4}, names{:});
        fprintf(fid3, [filesep, 'n']);
        
        % POPULATING FILES
        for i = 1:size(attractorTable, 1)
            attr = attractorTable{i, 1};
            attrSize = size(attr, 1);
            
            attractorType = attrType{i};
            associatedFate = associatedCellFates{i};
            propensity = num2str(basinSizes{i});
            states = attractorTable{i, 1};
            attrNumb = int2str(i);
            activityInFractions = attractorActivityInFractions{i};
            activityInWholes = attractorActivityAsWhole{i};
            
            % POPULATE FILE 1
            fprintf(fid1, '%s,', attrNumb, attractorType, associatedFate, propensity);
            fprintf(fid1, '%d,', activityInFractions(:));
            fprintf(fid1, [filesep, 'n']);
            
            % POPULATE FILE 2
            fprintf(fid2, '%s,', attrNumb, attractorType, associatedFate, propensity);
            fprintf(fid2, '%d,', activityInWholes(:));
            fprintf(fid2, [filesep, 'n']);
            
            % POPULATE FILE 3
            for l = 1:attrSize
                attractor = states(l, :);
                fprintf(fid3, '%s,', attrNumb, attractorType, associatedFate, propensity);
                fprintf(fid3, '%u,', attractor(:));
                fprintf(fid3, [filesep, 'n']);
            end
            
            fprintf(fid3, [filesep, 'n']);
            
        end
        
        progressbar(0.7/1);
        
        fclose(fid1); 
        fclose(fid2); 
        fclose(fid3);
        
        clear associatedCellFates attractorTable attractorActivityAsWhole attractorActivityInFractions;
    end
    
    % SAVE CELL FATE TABLE
    if ~isempty(myNetwork.CellFateLandscape)
        
        % UPDATE FILE NAME
        FileName = [myNetwork.FileName, 'Cell Fate Propensites', '.csv'];
        
        % CREATE FILE
        fid4 = fopen(strcat(PathName, FileName), 'w');
        
        % FORMAT DATA
        cellfateTable = myNetwork.CellFateLandscape;
        header = {'Cell fate', 'Propensity'};
        
        formatToken = '%s,';
        
        % ADDING HEADER
        fprintf(fid4, formatToken, header{:});
        fprintf(fid4, [filesep, 'n']);
        
        cellFates = cellfateTable(:,1);
        propensities = cellfateTable(:,2);
        
        % POPULATING FILES
        for i = 1:size(cellfateTable, 1)
            cellFate = cellFates{i};
            propensity = num2str(propensities{i});
            
            % POPULATE FILE
            fprintf(fid4, ['%s, %s ', filesep,'n'], cellFate, propensity);
        end
        
        % CLOSE ANY OPEN FILES
        fclose(fid4);
    end

    % SAVE NETWORK STATE LIST
    FileName = 'Network State List DA';
    
    % GET STATE SPACE
    networkStateList = myNetwork.NetworkStateList;
    
    % SAVE NETWORK STATE LIST
    csvwrite(strcat(PathName, FileName, '.csv'), networkStateList);
    save(strcat(PathName, FileName, '.mat'), 'networkStateList', '-v7.3');

    progressbar(1/1);
        
    % SUCCESS
    bool = 1;
    
%     %$
%     if ~isempty(myNetwork.Time)
%         time = [time, '  ', 'time taken to save results: ', num2str(toc)];
%         timeFile = fopen(strcat(PathName, 'Run Time Analysis DA.txt'), 'w');
%         fprintf(timeFile, '%s', time);
%         fclose(timeFile);
%     else
%         toc;
%     end
%     
catch
    % FAILURE
    bool = 0;
    
    progressbar(1/1);
    
    % CLOSE ANY OPEN FILES
    fclose all;
end

end

