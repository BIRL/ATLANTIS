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

function bool = find_SteadyStateProbabilities(myNetwork, totalProgress)

try
    % GET NETWORK PROPERTIES AND INITIALIZE VARIABLES
    stateSpace = size(myNetwork.NetworkStateList, 1);
    steps = myNetwork.TimeSteps;
    Tij = myNetwork.StateTransitionProbabilities;
    Tji = Tij';
    initialProbabilities = ones(stateSpace,1)./(stateSpace);
    iteration = 1;
    precision = myNetwork.SteadyStatePrecision;
    
    while (iteration <= steps)
        % INITIALIZE FLUX VAR
        fluxOut = zeros(stateSpace, 1);
        fluxIn = zeros(stateSpace, 1);
        
        % UDPATE PROGRESSBAR
        progressbar(totalProgress, 1, iteration/steps);
        
        % FINDING CHANGE FLUXES USING MASTER EQUATIONS
        for Statei = 1:stateSpace
            fluxOut = Tij(:,Statei).* initialProbabilities...
                + fluxOut;
            fluxIn = Tji(:,Statei).* initialProbabilities(Statei)...
                + fluxIn;
        end
        
        % FINDING CHANGE IN PROBABILITIES
        changeInProbabilities = - fluxOut + fluxIn;
        
        % UPDATE PROBABILITIES
        updatedProbabilites = initialProbabilities + changeInProbabilities;
        
        % ROUND FUNCTION
        roundSig = @(x) round(x, precision, 'significant');
        
        % STOP SIMULATION IF STEADY STATE HAS BEEN ACHIEVED
        similar = roundSig(initialProbabilities) == roundSig(updatedProbabilites);
        if all( similar )
            disp(['Reached at timestep: ', num2str(iteration)]);
            initialProbabilities = updatedProbabilites;
            progressbar(totalProgress, 1, 1);
            break;
        end
        
        % SET INITIAL PROBABILITIES TO UPDATED ONES
        initialProbabilities = updatedProbabilites;
        
        % ITERATION INCREAMENT
        iteration = iteration + 1;
        
    end
    
    % UDPATE NETWORK PROPERTIES
    myNetwork.SteadyStateTimeStep = iteration;
    myNetwork.SteadyStateProbabilities = initialProbabilities;
    
    % SUCCESS
    bool = 1;
    
catch
    % FAILURE
    bool = 0;
    progressbar(totalProgress, 1, 1);
end

end