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

function bool = addMutations_WeightsBased(myNetwork, mutationFilePath, mutationFileName)

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
    
    % SANITY CHECK 1: CHECK IF FILE IS NOT EMPTY AND HAS DATA AND IS
    % IMPORTED IN STRUCT FORM
    if isstruct(token)
        
        % EXTRACTING NODES LIST
        mutationData = token.textdata;
        mutationType = token.data;
        
        % SEPERATING NODES FROM LINKS
        linksData = mutationType == 2; % 2 MEANS LINKS
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
        
        % GETTING BASAL VALUES
        basalValues = myNetwork.BasalValues;
        
        % ERROR LOG
        errorLog = '';
        
%         % MUTATED NODES
%         mutatesNodes = cell(numel(NodesList), 1);
        
        if ~isempty(NodesList)
            % FINDING INDICES OF THE NODES TO BE MUTATED
            [~, mutateNodeIndices] = ismember(cellfun(@lower, NodesList, 'un', 0), cellfun(@lower, myNetwork.NodeNames, 'un', 0));
            
            for i = 1:numel(mutateNodeIndices)
                % IF NODE FOUND
                if mutateNodeIndices(i) ~= 0
                    if mutationValues(i) == 0
                        basalValues( mutateNodeIndices(i) ) = -1000;
                    else
                        basalValues( mutateNodeIndices(i) ) = 1000;
                    end
%                     mutatesNodes(i) = NodesList{i};
                else
                    % SAVE LIST OF NODE NOT FOUND
                    errorLog = [errorLog, '" ', NodesList, ' -> ', num2str(mutationValues(i)),' " , '];
                end
            end
        end
        
        % REMOVE EMPTY SPACES
%         mutatesNodes(cellfun(@isempty, mutatesNodes)) = [];
        
        % UPDATED MUTATED NODES
%         myNetwork.MutatedNodes = mutatesNodes;
        
        % GETTING INTERACTION WEIGHTS
        interactionWeights = myNetwork.EdgeWeights;
        
        if ~isempty(LinksList)
            % SEPERATING SOURCE AND TARGET NODES
            NodePairs = cellfun(@(x) strsplit(x, '>'), LinksList, 'un', 0);
            sourceNodes = cellfun(@(x) lower(x{1}) , NodePairs, 'un', 0);
            targetNodes = cellfun(@(x) lower(x{2}) , NodePairs, 'un', 0);
            
            % FINDING SOURCE AND TARGET NODE INDICIES
            [~, sourceNodesIndices] = ismember(cellfun(@lower, sourceNodes, 'un', 0), cellfun(@lower, myNetwork.NodeNames, 'un', 0));
            [~, targetNodesIndices] = ismember(cellfun(@lower, targetNodes, 'un', 0), cellfun(@lower, myNetwork.NodeNames, 'un', 0));
            
            for i = 1:numel(targetNodes)
                % CHECK BOTH NODES IN THE PAIR ARE PRESENT
                try
                    
                    % CHECK IF BOTH NODES ARE PRESENT
                    if sourceNodesIndices(i) == 0 || targetNodesIndices(i) == 0
                        undefined/0;
                    end
                    
                    % DELETING INTERACTION WEIGHTS
                    r = sourceNodesIndices(i);
                    c = targetNodesIndices(i);
                    
                    % CHECK IF THE INTERACTION IS PRESENT
                    if interactionWeights(r, c) == 0
                        undefined/0;
                    end
                    
                    % IF PRESENT THAN SET TO 0
                    interactionWeights(r, c) = 0;
                catch
                    errorLog = [errorLog, '" ', sourceNodes{i}, ' > ', targetNodes{i},' "', ' , '];
                end
            end
        end
        
        if ~isequal(errorLog,'')
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
myNetwork.BasalValues = basalValues;
myNetwork.EdgeWeights = interactionWeights;

% UPDATE FILE NAME
ind = strfind(mutationFileName, '.');
extension = mutationFileName(ind:ind + 3);
myNetwork.FileName = [strrep(mutationFileName, extension, ''), ' - '];

end