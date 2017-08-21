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

function outputFolder = generate_OutputFolderName(NetworkfileName)
% generates filename based on current time and date

% REMOVE EXTENSION
ind = strfind(NetworkfileName, '.');
extension = NetworkfileName(ind:ind + 3);
FileName = strrep(NetworkfileName, extension, '');

% SAVE NetworkfileName
setappdata(0, 'NetworkfileName', FileName);

% GET DATE AND TIME
dateTime = datestr(now,'yyyy-mm-dd HH-MM-SS ');

% FOLDER NAME
outputFolder = ['Results\', dateTime, FileName, '\'];

end

