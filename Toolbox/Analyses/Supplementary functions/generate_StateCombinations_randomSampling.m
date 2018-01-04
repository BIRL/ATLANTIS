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

function states = generate_StateCombinations_randomSampling(myNetwork, sampleSize)

states = []; % will store randomly generated states

progressbar('Generating States. Please Wait...');

while size(states, 1) < sampleSize
    i = size(states, 1);
    diff = sampleSize - size(states, 1);
    progressbar(i/sampleSize);
    states = vertcat(states, randi([0 1], diff,myNetwork.NodeCount)); %#ok<AGROW>
    [a, b]=unique(states,'rows');   %#ok<ASGLU> % finding replicated rows %
    states = states(sort(b),:);     % removing replicated rows
end

progressbar(1);

end