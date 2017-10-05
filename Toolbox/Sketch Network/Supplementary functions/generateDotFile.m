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

function bool = generateDotFile(myNetwork)
% CREATES A DOT FILE

try
    % EXTRACT RESULTS FOLDER PATH
    if ~isempty(myNetwork.FileName)
        PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', '\')];
    else
        PathName = myNetwork.ResultFolderName;
    end
    
    % MAKE FOLDER
    [~, ~] = mkdir(PathName);
    
    % FILE NAME
    str = 'DotFile.dot';
    name = strcat(PathName, str);
    
    % CREATING FILE
    fileID = fopen(name, 'w');
    
    % GRAPH TYPE
    start =horzcat('digraph g {','\n');
    fprintf(fileID,start);
    
    % DEFINE NODE SPACING AND SPLINE
    afterStart = horzcat('\t','nodesep=0.4;','\n'); %,'\t','//splines = true','\n');
    fprintf(fileID,afterStart);
    
    % NODE SHAPE
    nodeDefault=horzcat('\t' ,'node [shape = ellipse, color=white, style=filled, fontsize = 20 ];','\n');
    fprintf(fileID,nodeDefault);
    fprintf(fileID,'\n');
    %default node and edge variables
    defaultActEdgeLabelColor = 'green';
    defaultInhEdgeLabelColor = 'red';
    defaultEdgeLabelStyle = 'bold';
    
    % INTERACTION MATRIX
    if isempty(myNetwork.InteractionMatrix)
        interactionMatrix = myNetwork.EdgeWeights;
    else
        interactionMatrix = myNetwork.InteractionMatrix;
    end
        
    nodeList = myNetwork.NodeNames;
    
    % WRITING DOT FILE
    for i = 1:myNetwork.NodeCount;
        fromNode = nodeList{i};
        for j = 1:myNetwork.NodeCount;
            toNode = nodeList{j};
            if interactionMatrix(i, j) >= 1; % IF INTERACTION IS POSITIVE
                line = horzcat('\t', '"', fromNode,'"', ' ->','',' ','"', toNode,'"',' [' , 'style=',defaultEdgeLabelStyle, ' ,', 'color=',defaultActEdgeLabelColor, ',' , ' label="+ ',num2str(interactionMatrix(i,j)),' "]',';','\n');
                fprintf(fileID,line);
            elseif interactionMatrix(i, j) < 0; % IF INTERACTION IS NEGATIVE
                line = horzcat('\t', '"',fromNode,'"',' ->','',' ','"', toNode,'"',' [' , 'style=',defaultEdgeLabelStyle, ' ,', 'color=',defaultInhEdgeLabelColor, ',' , ' label=" ',num2str(interactionMatrix(i,j)),' "]',';','\n');
                fprintf(fileID,line);
            else
            end
        end
    end
    
    % CLOSE FILE
    fprintf(fileID, '}');
    fclose('all');
    
    % SUCCESS
    bool = 1;
    
    % SAVE DOT FILE NAME
    myNetwork.DotFileInfo = {str, PathName};
    
catch
    % FAILURE
    bool = 0;
end

end

