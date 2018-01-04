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

function bool = find_SteadyStateProbabilities(myNetwork, totalProgress)

try
    
    % CANCEL BUTTON
    cancelButton = CancelSimulationButton;
    movegui(cancelButton, 'northeast');
    setappdata(0,'CancelSimulation', []);

    % CHECK IF USER CHOOSE TO PRUNE STATE SPACE
    if myNetwork.PruneStateSpace == 1;
        stateSpaceSize = size(myNetwork.PrunnedStateSpacePA, 1);
    else
        stateSpaceSize = size(myNetwork.NetworkStateList, 1);
    end

    % GET NETWORK PROPERTIES AND INITIALIZE VARIABLES
    maxSteps = myNetwork.TimeSteps;
    Tij = myNetwork.StateTransitionProbabilities;
    Tji = Tij';
    initialProbabilities = ones(stateSpaceSize, 1)./(stateSpaceSize);
    iteration = 1;
    errorThreshold = myNetwork.ErrorThreshold;
    
    while (iteration <= maxSteps)
        % INITIALIZE FLUX VAR
        fluxOut = zeros(stateSpaceSize, 1);
        fluxIn = zeros(stateSpaceSize, 1);
        
        % UDPATE PROGRESSBAR
        progressbar(totalProgress, 1, iteration/maxSteps);
        
        % FINDING CHANGE FLUXES USING MASTER EQUATIONS
        for Statei = 1:stateSpaceSize
            fluxOut = Tij(:,Statei).* initialProbabilities...
                + fluxOut;
            fluxIn = Tji(:,Statei).* initialProbabilities(Statei)...
                + fluxIn;
        end
        
        % FINDING CHANGE IN PROBABILITIES
        changeInProbabilities = - fluxOut + fluxIn;
        
        % UPDATE PROBABILITIES
        updatedProbabilites = initialProbabilities + changeInProbabilities;
        
        % STOP SIMULATION IF STEADY STATE HAS BEEN ACHIEVED
        diff = abs(initialProbabilities - updatedProbabilites);
        
        PercentageSimilar = sum( diff <= errorThreshold , 1 ) / stateSpaceSize;
        
        % STEADY STATE CONFIRMATION CONDITION
        if PercentageSimilar >= 0.98 && iteration > 10 && all(initialProbabilities >= 0)
            disp(['Steady State Probabilities reached at iteration #: ', num2str(iteration)]);
            myNetwork.SteadyStateTimeStep = iteration;
            break;
        end
        
        % SET INITIAL PROBABILITIES TO UPDATED ONES
        initialProbabilities = updatedProbabilites;
        
        % ITERATION INCREAMENT
        iteration = iteration + 1;
        
        % CANCEL SIMULATION
        if ~isempty(getappdata(0,'CancelSimulation'))
            cancelButton.delete;
            undefined/0;
        end
        
    end
        
    % DELETE CANCEL BUTTON
    cancelButton.delete;
    
    % UDPATE NETWORK PROPERTIES
    myNetwork.SteadyStateProbabilities = updatedProbabilites;
    
    % SUCCESS
    bool = 1;
        
catch
    % FAILURE
    bool = 0;
    progressbar(totalProgress, 1, 1);
    cancelButton.delete;
end

    

end