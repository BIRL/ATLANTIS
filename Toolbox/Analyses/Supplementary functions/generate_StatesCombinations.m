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

function generate_StatesCombinations(obj)
% Generates a matrix of boolean states of length = number of nodes
% Mustafa U. Torun (Jan, 2010)
% ugur.torun@gmail.com

N = obj.NodeCount;

L = 2^N;
combinations = zeros(L,N);

for i=1:N
    temp = [zeros(L/2^i,1); ones(L/2^i,1)];
    combinations(:,i) = repmat(temp,2^(i-1),1);
end

obj.NetworkStateList = combinations;

end