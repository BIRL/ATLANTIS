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

function  [fracSummary, boolSummary] = summarize_AttractorActivity(attr, ub, lb)
% summarizes node activity states in a cyclic attractor by finding average 

total = size(attr, 1);
attr = num2cell(attr,1);
summarizedAttr = cellfun(@sum, attr);
fracSummary = summarizedAttr./ total;
boolSummary = fracSummary;

% find the nodes that show oscilatory behavior
filter1 = find(boolSummary <= 1-ub);
filter2 = find(boolSummary >= 0+lb);

% find the nodes that are almost zero or one
almost0 = boolSummary < 0+lb;
almost1 = boolSummary > 1-ub;

% Oscilating nodes
oscilatoryNodesindex = intersect(filter1,filter2);

% if ~isempty(oscilatoryNodesindex)
%     attractorType = 'Point';
% else
%     attractorType = 'Cyclic';
% end

boolSummary(oscilatoryNodesindex) = 2;
boolSummary(almost0) = 0;
boolSummary(almost1) = 1;

end