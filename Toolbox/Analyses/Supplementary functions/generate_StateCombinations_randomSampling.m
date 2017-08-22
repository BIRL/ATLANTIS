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

function states = generate_StateCombinations_randomSampling(myNetwork, sampleSize)

states = []; % will store randomly generated states

while ( size(states, 1) < sampleSize )
    diff = sampleSize - size(states, 1);
    states = vertcat(states, randi([0 1], diff,myNetwork.NodeCount)); %#ok<AGROW>
    [a, b]=unique(states,'rows');   %#ok<ASGLU> % finding replicated rows %
    states = states(sort(b),:);     % removing replicated rows
end

end