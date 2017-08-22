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

function [bool] = parse_LogicTables(myNetwork, logicTableFolderInfo, nodeList)

bool = 0;

% CHECK THE CELL ARRAY IS OF STRINGS ONLY AND IS A COLUMN VECTOR

nodeCount = size(nodeList, 1);

progressbar('Parsing logic tables....');

SourceNodesnames  = cell(nodeCount, 1);
SourceNodeindices = cell(nodeCount, 1);
TargetNodenames   = cell(nodeCount, 1);
TargetNodeindices = cell(nodeCount, 1);
NodeUpdatelogic   = cell(nodeCount, 1);

% Adjacency Matrix/Interaction Matrix
interactionMatrix = zeros(nodeCount, nodeCount);

% ERROR LOG
errorLog = '';

% IMPORTING NODE STATE UPDATE LOGIC
for i = 1:nodeCount
    
    % NAME OF NODE LOFIC FILE
    logicTableName = strcat(nodeList{i},'.txt');
    progressbar(i / nodeCount);
    
    try
        % IMPORTING LOGIC TABLE FOR NODE 'i'
        token1 = importdata(fullfile(logicTableFolderInfo, logicTableName));
        % EXTRACTING NUMERIC DATA
        token2 = token1.data;
        % EXTRACTING ALPHABETIC DATA
        token3 = token1.textdata;
        % SEPERATING SOURCE AND TARGET NODE
        sourceNodes = token3(1:end-1);
        targetNode = token3(end);
        
        % CHECK IF THESE NODES ARE PRESENT IN THE NODE LIST
        if ~all(ismember(sourceNodes, nodeList)) || ~ismember(targetNode, nodeList);
            undefined/0; 
        end
        
        % SETTING SOURCE AND TARGET NODE INDICIES
        targetNodeIndex = i;
        [~, sourceNodeIndices] = ismember (sourceNodes, nodeList);
        % EXTRACTING OUTPUT OF TARGET NODE STATE
        outputs = token2(:,end);
        isboolean = all((outputs == 1) == (outputs ~= 0));
        
        % CHECK FOR OUTPUT VALIDITY
        if  ~isboolean || ~(size(token2, 2)-1 == numel(sourceNodes))
            undefined/0;
        end
        
        interactionMatrix(sourceNodeIndices, i) = 1;
        
        % CREATING NETWORK DATASTRUCTURE
        SourceNodesnames{i}  = sourceNodes;
        SourceNodeindices{i} = sourceNodeIndices;
        TargetNodenames{i}   = targetNode;
        TargetNodeindices{i} = targetNodeIndex;
        NodeUpdatelogic{i}   = outputs;
    catch
        targetNodeIndex = i;
        SourceNodesnames{i}  = {'N/A'};
        TargetNodenames{i}   = {'N/A'};
        TargetNodeindices{i} = targetNodeIndex;
        errorLog = [errorLog, ' "', nodeList{i}, '" , ' ];
    end
end

if ~isequal(errorLog,'')
    choice = questdlg(['Logic files for the following nodes: ',...
        errorLog,' were either not found or contain invalid enteries (e.g. parent/child node name present in logic table is missing from node list, logic table contains non-logicals etc). Do you want to continue? (Select "No" to reselect the inputs).'], 'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            bool = 1;
        case 'No'
            return;
    end
end

myNetwork.NodeNames = nodeList;
myNetwork.NodeCount = nodeCount;

myNetwork.SourceNodesNames  = SourceNodesnames;
myNetwork.SourceNodeIndices = SourceNodeindices;
myNetwork.TargetNodeNames   = TargetNodenames;
myNetwork.TargetNodeIndices = TargetNodeindices;
myNetwork.NodeUpdateLogic   = NodeUpdatelogic;
myNetwork.InteractionMatrix = interactionMatrix;

end

