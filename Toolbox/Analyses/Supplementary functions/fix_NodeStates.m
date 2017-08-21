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

function [bool, inputNodes] = fix_NodeStates(obj, fileInfo)

bool = 0;
inputNodes = [];

try  
    % IMPORT DATA
    allData = importdata(fileInfo);
    
    % CHECK IF NOT EMPTY AND IS STRUCT
    if isempty(allData) || ~isstruct(allData)
        undefined/0;
    end
    
    % EXTRACTING NUMERIC AND NON NUMERIC DATA
    numericData = allData.data;
    textData = allData.textdata;
    
    % SANITY CHECK 1: CHECK SIZE
    if all(size(numericData) ~= size(textData)) && size(numericData, 1) ~= 1
        undefined/0;
    end
    
    % SANITY CHECK 2: NODES ARE PRESENT IN THE NETWORK
    [logicals, InputNodeIndicies] = ismember(cellfun(@lower, textData, 'un', 0), cellfun(@lower, obj.NodeNames, 'un', 0));
    if sum(logicals) ~= size(numericData, 2)
        undefined/0;
    end
    
    % SANITY CHECK 3: NUMERIC DATA IS BOOLEAN
    isboolean = all((numericData == 1) == (numericData ~= 0));
    if ~isboolean
        undefined/0;
    end
    
    % INPUT STATE VALUE
    stateVal = numericData;
    
    % GET NETWORK STATE LIST
    networkStateList = obj.NetworkStateList;
    
    for i = 1:size(networkStateList,1)
        networkStateList(i,InputNodeIndicies) = stateVal;
    end
    
    % SET BOOL TO TRUE
    bool = 1;
    
    % INPUTNODES
    inputNodes = textData;
    
    % MAKE BACKUP OF PREVIOUS NETWORK STATE LIST
    setappdata(0, 'NetworkStateList', obj.NetworkStateList);
    
    % UPDATE STATE COMBINATIONS
    obj.NetworkStateList = networkStateList;
    
catch
    bool = 0;
    return;    
end


end

