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

function [bool, message] = perform_ProbabilisticAnalysis(myNetwork, totalProgress)
% PERFORMS PROBABILISTIC ANALYSIS

tic;

message = '';

% RUN PROBABILISTIC ANALYSIS
networkType = myNetwork.NetworkType;
if strcmp(networkType, 'WeightsBased')

    % FIND STATE TRANSITION PROBABILITIES
    bool = find_StateTransitionProbabilities(myNetwork, totalProgress);
    
    disp(['Time Taken to Find State Transitions Probabilities: ', num2str(toc)]);
    
    if ~bool
        message = 'Error while finding state transition probabilities (Possible erors; 1) Your system memory is insufficient. Please reduce the network state list size and try again)';
        bool = 0;
        return;
    end
        
    % FIND STEADY STATE PROBABILITIES
    bool = find_SteadyStateProbabilities(myNetwork, totalProgress);
    
    disp(['Time Taken to Find Steady State Probabilites: ', num2str(toc)]);
        
    if ~bool
        message = 'Error while finding steady state probabilities';
        bool = 0;
        return;
    end
else
    bool = 0;
    message = 'Probabilistic analysis for rules-based networks is currently unavailable.';
    return;
end

end

