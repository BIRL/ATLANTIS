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

function bool = find_StateTransitionProbabilities(myNetwork, totalProgress)

try
    % GET NETWORK PROPERTIES
    initialStates = myNetwork.NetworkStateList;
    numberOfStates = size(initialStates, 1);
    aij = myNetwork.EdgeWeights;
    noise = myNetwork.Noise;
    c = myNetwork.DegradationConstant;
    bi = myNetwork.BasalValues';
    Tij = ones(numberOfStates, numberOfStates);
    nodeOnProbabilities = zeros(numberOfStates, myNetwork.NodeCount);
    nodeOffProbabilities = zeros(numberOfStates, myNetwork.NodeCount);
    
    % 1. FINDING NODE TRANSITION PROBABILITIES
    
    % FIND ACCUMULATIVE EFFECT OF INTERACTORS AND BASAL VALUES ON
    % EACH NODE
    Summation = initialStates*aij+repmat(bi,[numberOfStates,1]);
    
    % IF THE 'summation' > 0 THEN NEXT STATE = 1
    % (EFFECT OF NEGATIVE REGULATION < POSITIVE REGULATION)
    indices = Summation > 0;
    % ASSIGNING NODES WITH +IVE INPUT HIGH PROBABILITY TO TURN ON
    nodeOnProbabilities(indices) = 1/2 + 1/2*tanh(noise*Summation(indices));
    nodeOffProbabilities(indices) = 1-nodeOnProbabilities(indices);
    
    % FINDING NODES WHICH HAVE NEGATIVE INPUT
    indices = Summation < 0;
    % ASSIGNING NODES WITH -IVE INPUT HIGH PROBABILITY TO TURN OFF
    nodeOffProbabilities(indices) = 1/2 - 1/2*tanh(noise*Summation(indices));
    nodeOnProbabilities(indices) = 1 - nodeOffProbabilities(indices);
    
    % FINDING NODES WHICH HAVE NO INPUT
    indices = find(Summation == 0);
    
    for n = 1:length(indices)
        if initialStates(indices(n)) == 0
            % IF THE NODE WAS OFF IT STAYS OFF
            nodeOnProbabilities(indices(n)) = c;
            nodeOffProbabilities(indices(n)) = 1-c;
        elseif initialStates(indices(n)) == 1
            % IF THE NODE WAS ON IT STAYS ON
            nodeOnProbabilities(indices(n)) = 1-c;
            nodeOffProbabilities(indices(n)) = c;
        end
    end
    
    % 2. FINDING STATE TRANSITION PROBABILITIES
    
    % FIND ACTIVE AND INACTIVE NODES
    activeNodes = initialStates == 0;
    inactiveNodes   = initialStates == 1;
    
    % POPULATE STATE TRANSITION PROBABILITIES MATRIX
    for Statei = 1:numberOfStates
        % UPDATE PROGRESSBAR
        progressbar(totalProgress, Statei/numberOfStates, 0);
        
        % ALL ACTIVE NODES 
        allOn = repmat(nodeOnProbabilities(Statei,:),[numberOfStates, 1]);
        
        % ALL INACTIVE NODES
        allOff = repmat(nodeOffProbabilities(Statei,:),[numberOfStates, 1]);
        allOn(activeNodes) = 1;
        allOff(inactiveNodes) = 1;
        Tij(Statei, :) = (prod(allOn, 2) .* prod(allOff, 2))';
    end
    
    % UPDATE NETWORK PROPERTIES
    myNetwork.StateTransitionProbabilities = Tij;
    
    % SUCCESS
    bool = 1;
    
catch
    % FAILURE
    bool = 0;
    progressbar(totalProgress, 1, 0);
end

end