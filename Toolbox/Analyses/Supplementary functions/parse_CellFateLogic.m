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

function [bool, rawLogic] = parse_CellFateLogic(obj, fileName, pathName)
% THIS FUNCTION EXTRACTS CELL FATES AND OUTPUT NODES FROM THE USER
% SPECIFIED FILE

% EMPTY CELL TO STORE LOGIC
rawLogic = {};

try
    
    % LOADING LOGIC FILE
    allData = csv2cell(fullfile(pathName, fileName));
    
    if isempty(allData)
       undefined/0; 
    end
    
    % EXTRACTING CELL FATES
    cellfates = allData(:,1);
    
    % REMOVING EMPTY ROWS
    cellfates = cellfates(2:end);
    
    % CHECK IF ALL ARE STRINGS
    areNum = cellfun(@str2num, cellfates, 'un', 0);
    empty = cellfun(@isempty, areNum);
    
    if all(~empty)
        undefined/0;
    end
    
    % EXTRACTING OUTPUT NODES
    outputNodes = allData(1, :);
    
    % ADDING OUTPUT NODES TO LOGIC VAR
    cellFateDeterminationLogic = outputNodes;
    
    % REMOVING EMPTY CELLS
    outputNodes = outputNodes(2:end);
    
    % CHECK IF ALL OUTPUT NODES ARE PRESENT
    [~, outputNodeIndicies] = ismember(cellfun(@lower, outputNodes, 'un', 0), cellfun(@lower, obj.NodeNames, 'un', 0));
    
    if sum(outputNodeIndicies == 0) > 0
        uiwait(errordlg('Some of the nodes in this file are not present in the network. Please only input file containing nodes same as that in the network.', 'Invalid File'));
        undefined/0;
    end
    
    % INITIALIZING ROW AND NODE POSITIONS
    row = 2;
    nodePosisitions = [];
    
    for f = 1:numel(cellfates)
        
        % ADD FATE TO LOGIC
        cellFateDeterminationLogic{row, 1} = cellfates{f};
        
        % INITIALIZING LIST OF OUTPUT NODES
        listOfNodestates = cell(1, numel(outputNodes));
        
        for n = 1:numel(outputNodes)
            
            % FIND STATE OF NODE 'n' FOR CELL FATE 'f'
            Nodestates = eval(strcat('[' ,allData{f+1, n+1} ,']'));
            
            % IF ANY OF THE STATES IS NOT NUMERIC GIVE ERROR
            if ~isnumeric(Nodestates)
                undefined/0;
            end
            
            % IF NODE STATE PRESENT THAN RECORD ITS POSITION
            if ~isempty(Nodestates)
                nodePosisitions = horzcat(nodePosisitions, n);
            end
            
            % UPDATE LIST OF OUTPUT NODES FOR THIS CELL FATE
            listOfNodestates{n} = Nodestates;
        end
        
        % REMOVE EMPTY CELLS
        listOfNodestates(cellfun(@isempty, listOfNodestates)) = [];
        
        % GENERATE COMBINATIONS
        combinations = generateCombinations(listOfNodestates{:});
        
        % ADD ADDITIONAL ROWS IF MORE THAN ONE COMBINATION
        rowToBeCopied = cellFateDeterminationLogic(row, :);
        newRows = repmat(rowToBeCopied, [size(combinations, 1)-1, 1]);
        cellFateDeterminationLogic = vertcat(cellFateDeterminationLogic, newRows);
        
        % ADD COMBINATIONS TO LOGIC VAR
        lowerBound = row;
        upperBound = row + size(combinations, 1) - 1;
        cellFateDeterminationLogic(lowerBound:upperBound, nodePosisitions+1) = num2cell(combinations);
        
        % UPDATE ROW AND NODE POSITIONS
        row = row + size(combinations, 1);
        nodePosisitions = [];
    end
    
    % OUTPUT RAW LOGIC
    rawLogic = cellFateDeterminationLogic;
    
    % FORMAT CELL FATE DETERMINATION LOGIC
    rules = cellFateDeterminationLogic(2:end, 2:end);
    rules(cellfun(@isempty, rules)) = {NaN};
    rules = num2cell(cell2mat(rules), 2);
    cellFateDeterminationLogic = {cellFateDeterminationLogic(2:end, 1), rules};
    
    % SUCCESS
    bool = 1;
    
    % UPDATE NETWORK CELL FATE LOGIC
    obj.CellFateDeterminationLogic = cellFateDeterminationLogic;
    obj.UniqueCellFates = cellfates;
    obj.OutputNodes = outputNodes;
    obj.OutputNodesIndices = outputNodeIndicies;
    
catch
    % FAILURE
    bool = 0;
end

    function Combinations = generateCombinations(varargin)
        numberOfElements = cellfun('prodofsize', varargin);
        indices = fliplr(arrayfun(@(n) {1:n}, numberOfElements));
        [indices{:}] = ndgrid(indices{:});
        Combinations = cellfun(@(c,i) {reshape(c(i(:)), [], 1)}, ...
                            varargin, fliplr(indices));
        Combinations = [Combinations{:}];
    end

end

