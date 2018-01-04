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

function bool = addMutations_RulesBased(myNetwork, mutationFilePath, mutationFileName)

% CHECK
bool = 0;

try
    % BACKUP NETWORK
    myNetwork.NetworkBackUp = copy(myNetwork);
    
    token = importdata(fullfile(mutationFilePath, mutationFileName));
    
    % IF CELL GIVE ERROR
    if iscell(token)
        undefined/0;
    end
    
    % CHECK IF STRUCT
    if isstruct(token)
        
        % EXTRACTING NODES LIST
        mutationData = token.textdata;
        mutationType = token.data;
        
        % SEPERATING NODES FROM LINKS
        linksData = mutationType == 2; % 2 means links
        NodesList = mutationData(~linksData);
        mutationValues = mutationType(~linksData);
        LinksList = mutationData(linksData); 
        
        % SANITY CHECK 2: mutationValues ARE 0s OR 1s ONLY
        isboolean = all((mutationValues == 1) == (mutationValues ~= 0));
        if ~isboolean
            undefined/0;
        end
        
        % SANITY CHECK 3: NodeList CONTAINS ONLY STRINGS
        if ~iscellstr(NodesList)
            undefined/0;
        end
        
        % SANITY CHECK 4: LinksList is properly formatted
        if ~isempty(LinksList)
            chk4 = strfind(LinksList, '>');
            if ~isempty(find(cellfun(@isempty, chk4) == 1, 1))
                undefined/0;
            end
        end
        
        % GETTING NODE UPDATE LOGIC LIST
        NodeUpdateLogicList = myNetwork.NodeUpdateLogic;
        
        % ERROR LOG
        errorLog = '';
        
        if ~isempty(NodesList)
            % FINDING INDICES OF THE NODES TO BE MUTATED
            [~, mutateNodeIndices] = ismember(cellfun(@lower, NodesList, 'un', 0), cellfun(@lower, myNetwork.TargetNodeNames));
            
            for i = 1:numel(mutateNodeIndices)
                if mutateNodeIndices(i) ~= 0
                    currentIndex = mutateNodeIndices(i);
                    sizeOFoutputs = numel(NodeUpdateLogicList{currentIndex});
                    % UPDATE NODE UPDATE LOGIC LIST
                    NodeUpdateLogicList{currentIndex} = ones(sizeOFoutputs, 1)*mutationValues(i);
                else
                    % SAVE LIST OF NODE NOT FOUND
                    errorLog = [errorLog, '" ', NodesList, ' -> ', num2str(mutationValues(i)),' " , '];
                end
            end
            
        end
        
        % GETTING SOURCE NODE NAMES AND INDICIES
        sourceNodeNamesList = myNetwork.SourceNodesNames;
        sourceNodeIndices = myNetwork.SourceNodeIndices;
        
        if ~isempty(LinksList)
            % SEPERATING SOURCE AND TARGET NODES
            NodePairs = cellfun(@(x) strsplit(x, '>'), LinksList, 'un', 0);
            sourceNodes = cellfun(@(x) lower(x{1}) , NodePairs, 'un', 0);
            targetNodes = cellfun(@(x) lower(x{2}) , NodePairs, 'un', 0);
            
            % FINDING SOURCE AND TARGET NODE INDICIES
            [~, targetNodeIndices] = ismember(cellfun(@lower, targetNodes, 'un', 0), cellfun(@lower, myNetwork.TargetNodeNames));
            
            for i = 1:numel(targetNodes)
                % CHECK IF NODES IN THE PAIR ARE PRESENT
                try
                    % FIND TARGET NODE INDEX
                    targetInd = targetNodeIndices(i);
                    
                    % FIND SOURCE NODE INDEX
                    sourceNodesList = sourceNodeNamesList{targetInd};
                    [~, sourceNodeInd] = ismember(sourceNodes{i}, sourceNodesList);
                    
                    % CHECK IF THE TARGET AND SORUCE NODE ARE PRESENT
                    if targetInd == 0 || sourceNodeInd == 0
                        undefined/0;
                    end
                    
                    % UPDATE NODE UPDATE LOGIC LIST
                    logicTableSize = numel(sourceNodesList);
                    logicTable = truthTableGenerator(logicTableSize);
                    rowsToDel = logicTable(:, sourceNodeInd) == 1;
                    NodeUpdateLogicList{targetInd}(rowsToDel) = [];
                    sourceNodeNamesList{targetInd}(sourceNodeInd) = [];
                    sourceNodeIndices{targetInd}(sourceNodeInd) = [];
                catch
                    errorLog = [errorLog, '" ', sourceNodes{i}, ' > ', targetNodes{i},' "', ' , '];
                end
                
            end
            
        end
        
        if ~isequal(errorLog,'')
            errorLog = joinStr_CellArr(errorLog, ' ');
            choice = questdlg(['Following mutations were not added: ',...
                errorLog,'. Possibel reasons: 1) Node names in the mutation file are incorrect, 2) Node(s) or link(s) in mutation file not present in the network. Do you want to continue? (Select "No" to reselect the inputs).'], 'Warning', 'Yes', 'No', 'No');
            switch choice
                case 'Yes'
                case 'No'
                    return;
            end
        end
    else
        % EMPTY FILE -> CONTROL CONDITION
        
        % UPDATE FILE NAME
        ind = strfind(mutationFileName, '.');
        extension = mutationFileName(ind:ind + 3);
        myNetwork.FileName = [strrep(mutationFileName, extension, ''), ' - '];
        
        bool = 1;
        return;
    end
    
catch
    enableDisableFig(findall(0, 'tag','ModfiyNetworkMenu'), 'off');
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    uiwait(errordlg('Invalid file input. Please enter a valid file. See help for more information.', 'Invalid input'));
    enableDisableFig(findall(0, 'tag','ModfiyNetworkMenu'), 'on');
    return;
end

% MUTATIONS ADDED SUCCESSFULLY
bool = 1;

% MAKE NETWORK BACKUP
myNetwork.NetworkBackUp = copy(myNetwork);

% ADD CHANGES TO THE UPDATE LOGIC LIST
myNetwork.MutationInfo = token;
myNetwork.SourceNodesNames = sourceNodeNamesList;
myNetwork.SourceNodeIndices = sourceNodeIndices;
myNetwork.NodeUpdateLogic = NodeUpdateLogicList;

% UPDATE FILE NAME
ind = strfind(mutationFileName, '.');
extension = mutationFileName(ind:ind + 3);
myNetwork.FileName = [strrep(mutationFileName, extension, ''), ' - '];

    function combinations = truthTableGenerator( N )
        % Truth Table Generator
        % Mustafa U. Torun (Jan, 2010)
        % ugur.torun@gmail.com
        
        L = 2^N;
        combinations = zeros(L,N);
        
        for s = 1:N
            temp = [zeros(L/2^s,1); ones(L/2^s,1)];
            combinations(:,s) = repmat(temp,2^(s-1),1);
        end
    end

end