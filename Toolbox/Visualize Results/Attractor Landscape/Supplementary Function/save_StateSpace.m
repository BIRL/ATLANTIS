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

function save_StateSpace(myNetwork, stateSpace)
% SAVES THE STATE SPACE

% EXTRACT RESULTS FOLDER PATH
if ~isempty(myNetwork.FileName)
    PathName = [myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', filesep)];
else
    PathName = myNetwork.ResultFolderName;
end

% MAKE RESULTS FOLDER
[~, ~] = mkdir(PathName);

% CREATE NAME
FileName = [myNetwork.FileName, 'Modified State Space Used for Plotting.csv'];

% ASSEMBLE DATA
stateCount = num2cell(1:size(stateSpace, 1))';
data = horzcat(stateCount, num2cell(stateSpace));
nodeNames = myNetwork.NodeNames;

if size(nodeNames, 1) > 1
    nodeNames = nodeNames';
end
header = horzcat({'State #'}, nodeNames);

% SAVE TO EXCEL AND CLEAR SPACE
cell2csv(fullfile(PathName, FileName), vertcat(header, data));
clear data;
end

