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

function [bool, figHandle, networkSketch] = sketchGraphUsingBiograph(myNetwork)

try
    progressbar('Sketching Network...');
    
    % SET EDGE COLORS OPTION TO NULL BY DEFAULT 
    EdgeColors = 0;
    
    % SHOW SELF LOOPS
    showSelfLoops = 1;
    
    % CHECK NETWORK TYPE AND GET INTERACTION INFORMATION
    if strcmp(myNetwork.NetworkType, 'WeightsBased')
        interactionMat = myNetwork.EdgeWeights;
        EdgeColors = 1;
    else
        interactionMat = myNetwork.InteractionMatrix;
    end
    
    % GET NODE NAMES
    nodeNames = myNetwork.NodeNames;
    
    % GET NODE AND INTERACTION NUMBER
    nodeCount = myNetwork.NodeCount;
    edgeCount = numel(interactionMat(~interactionMat==0));
    
    % CATER FOR SELF LOOPS
    selfLoops = find(diag(interactionMat));
    
    if ~isempty(selfLoops) && showSelfLoops
        
        % ADD SELF LOOP NODES
        diagValues = diag(interactionMat);
        interactionMat = interactionMat-diag(diagValues);
        n = size(interactionMat,1);
        m = numel(selfLoops);
        interactionMat(n+m,n+m) = 0;
        newInteractions = repmat(diagValues(diagValues ~= 0), [2, 1]); 
        interactionMat(sub2ind([n+m , n+m], [selfLoops ;...
                            (1:m)'+n], [(1:m)'+n ; selfLoops])) = newInteractions;
        nodeNames((1:m)+n) = {' '};
    end
    
    progressbar(0.2);
    
    % CREATE BIOGRAPH
    networkSketch = biograph(interactionMat);
    
    progressbar(0.7);

    % SET AUTONODE SIZE OFF
    networkSketch.NodeAutoSize = 'off';

    % UPDATE ARROW SIZE
    networkSketch.ArrowSize = 5;

    % GET NODES
    Nodes = networkSketch.Nodes;

    % GET EDGES
    Edges = networkSketch.Edges;

    % UPDATE PROPERTIES
    for i = 1:numel(Edges)
        
        % UPDATE EDGE PROPERTIES
        if EdgeColors
            weight = Edges(i).Weight;

            if weight > 0
                EdgeColor = [50,205,50]./250;
            elseif weight < 0
                EdgeColor = [250,1,1]./250;
            end
            Edges(i).LineColor = EdgeColor;
            Edges(i).LineWidth = abs(weight);
        else
            Edges(i).LineColor = [0.1 0.1 205]./250;
        end

        % UPDATE NODE PROPERTIES
        if i <= numel(Nodes)
            Nodes(i).label = nodeNames{i};
            Nodes(i).Color = [1, 1, 1];
            Nodes(i).LineColor = [0, 0, 0];
            Nodes(i).TextColor = [1,1,139]./250;

            if ~isempty(selfLoops) && i>n 
                selfNodeName = nodeNames{find(interactionMat(i, :),1)};
                Nodes(i).ID = [selfNodeName, ' Self Loop'];
                Nodes(i).Shape = 'circle';
                Nodes(i).FontSize = 1;
                Nodes(i).Size = [0.1, 0.1];
            end
        end
    end
    
    progressbar(0.9);

    % UPDATE GRAPH PROPERTIES
    networkSketch.Nodes = Nodes;
    networkSketch.Edges = Edges;

    % SET NODE AUTOSIZE TO ON
    networkSketch.NodeAutoSize = 'on';
    
    % VIEW BIOGRAPH
    view(networkSketch)
    
    % GCF
    figHandle = gcf;
    figHandle.Name = ['Nodes: ', int2str(nodeCount), ' & Links: ', int2str(edgeCount)];
    
    % SUCCESS
    bool = 1;
    
    progressbar(1);
    
catch
    % FAILURE
    bool = 0;
    figHandle = 0;
    networkSketch = 0;
    progressbar(1);
end

end