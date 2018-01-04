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

function [bool, memoryRequired, maxmemoryAvailable] = isMemorySufficient(x)
% Checks if it is possible to create x elements

% CHECK MEMORY SIZE

if ismac
    % Code to run on Mac plaform
    [~, maxmemoryAvailable] = system('sysctl hw.memsize | awk ''{print $2}''');
    maxmemoryAvailable = str2num(maxmemoryAvailable);
elseif isunix
    % Code to run on Linux plaform
    
elseif ispc
    [~, systemview] = memory;
    maxmemoryAvailable = systemview.PhysicalMemory.Available;
else
    bool = 0;
    memoryRequired = [];
    maxmemoryAvailable = [];
    return;
end

memoryRequired = x*8;

if memoryRequired < maxmemoryAvailable
    bool = 1;
    return;
end

bool = 0;

end

