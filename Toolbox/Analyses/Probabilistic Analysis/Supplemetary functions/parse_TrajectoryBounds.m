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

function bool = parse_TrajectoryBounds(obj, fileName, pathName)
% THIS FUNCTIONS EXTRACTS THE START AND THE END STATES FROM THE USER 
% SPECIFIED TXT OR CSV FILE

try
    % LOADING LOGIC FILE
    allData = importdata(fullfile(pathName, fileName));
    
    % CHECK IF NOT EMPTY
    if isempty(allData) || isstruct(allData)
       undefined/0; 
    end
    
    % CHECK IF IS MATRIX
    if ~ismatrix(allData)
        undefined/0;
    end
    
    % CHECK SIZE
    if size(allData, 1) ~= 2 || size(allData, 2) ~= obj.NodeCount
        undefined/0;
    end
    
    % UPDATE NETWORK PROPERTIES
    obj.TrajectoryBounds = allData;
    
    % SUCCESS
    bool = 1;
catch
    % FAILURE
    bool = 0;
end

end

