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

function bool = parse_NetworkFile(myNetwork, fileName, filePath)

try
    % IMPORTING FILE
    allData = importdata(fullfile(filePath, fileName));
    
    numericData = allData.data;
    textData = allData.textdata;
    
    token = {textData{1, :}};
    
    token(1) = [];
    
    % EXTRACTING NODE NAMES
    nodeNames = token;
    numOfNodes = numel(nodeNames);
    
    % EXTRACTING INTERACTION WEIGHTS
    interactionWeights = numericData(1:numOfNodes, :);
    
    numericData(1:numOfNodes, :) = [];
    
    NaNs = isnan(numericData);
    
    % EXTRACTING BASAL VALUES
    basalValues = numericData(~NaNs);
    
    % SANITY CHECKS
    if numOfNodes ~= numel(basalValues) || ~iscellstr(nodeNames) || ~isnumeric(interactionWeights) || ~isnumeric(basalValues) || ~all( size(interactionWeights) == [numOfNodes, numOfNodes])
       undefined/0;
    end
    
    % CREATING NETWORK
    myNetwork.NodeNames = nodeNames;  % cellfun(@(n) lower(strrep(n, ' ', '')), , 'un', 0);
    myNetwork.EdgeWeights = interactionWeights;
    myNetwork.BasalValues = basalValues;
    myNetwork.NodeCount = numel(nodeNames);
    
    bool = 1;
    
catch
    bool = 0;
    return;
end


end