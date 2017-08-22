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

function [bool, message] = perform_DeterministicAnalysis(myNetwork, totalProgress)
% PERFORMS DETERMINISTIC ANALYSIS

message = '';

% RUN DETERMINISTIC ANALYSIS
networkType = myNetwork.NetworkType;

if strcmp(networkType, 'WeightsBased')
    bool = deterministicEngine_WeightsBased(myNetwork, totalProgress);
else
    bool = deterministicEngine_RulesBased(myNetwork, totalProgress);
end

if isempty(myNetwork.AttractorTable) 
    message = 'Could not find any attractors. Possible reasons might be; 1) Small attractor search duration value or 2) The input network is not robust and hence does not achieve a stable state. Please retry after increasing the attractor search duration value.';
    bool = 0;
    return;
end

if bool
    % CHECK IF CELL FATE LOGIC IS PRESENT
    if ~isempty(myNetwork.CellFateDeterminationLogic)
        
        % CLASSIFY ATTRACTORS
        bool = classify_Attractors(myNetwork);
        
        if ~bool
            message = 'Something went wrong while characterizing attractors. Please reinput cell fate logic or reperform deterministic analysis.';
            return;
        end
    end
else
    message = 'Something went wrong. Please reperform deterministic analysis. If this does not work, restart ATLANTIS. If the problem persists please report this issue.';
    return;
end

end

