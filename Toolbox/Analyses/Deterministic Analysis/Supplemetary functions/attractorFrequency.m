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

function table = attractorFrequency( vec )
% Finds the frequency of each element present in the input vector
% vector vec and creates a table with three columns. First column
% mentions each element present in vec. Second columns represents
% the frequency corresponding to each element in first column and
% the third column gives the percentage of the corresponding
% element in vector vec

uniqueEle = unique(vec);
table = zeros(numel(uniqueEle), 3);
table(:,1) = uniqueEle;
totalEle = numel(vec);

for ele = 1:numel(uniqueEle)
    freq = sum(vec == uniqueEle(ele) );
    table(ele,2) = freq;
    table(ele,3) = freq/totalEle;
end

end