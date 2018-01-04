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

function associatedFates  = associate_CellFates(cellFateInfo, attr, numOfUnCF)

% EXTRATING CELL FATES AND LOGIC
cellfates = cellFateInfo{:,1};
logicList = cellFateInfo{:,2};

% CREATE CELL ARRAY TO STORE ASSOCIATED FATES
associatedFates = cell(numOfUnCF, 1);
fateIndex = 1;

replacingNaNs = 1000;

for i = 1:numel(logicList)
    
    % PROCESS ATTRACTOR
    tempAttr = attr;
    logic = logicList{i};
    allNaNs = isnan(logic);
    logic(allNaNs) = replacingNaNs;
    tempAttr(allNaNs) = replacingNaNs;
    
    % COMPARE ATTRACTOR WITH LOGIC
    if isequal(logic, tempAttr)
        associatedFates{fateIndex} = cellfates{i};
        fateIndex = fateIndex + 1;
    end
    
end

% REMOVE EMPTY ENTERIES
emptyCells = cellfun(@isempty, associatedFates);
associatedFates(emptyCells) = [];

% FIND UNIQUE FATES AND COMBINE THEM TO FORM A STRING
[associatedFates, ~, ~] = uniqueCellArray(associatedFates);
associatedFates = { joinStr_CellArr(associatedFates, ' + ' ) };

end