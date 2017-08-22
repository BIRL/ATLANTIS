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

function [bool, memoryRequired, maxmemoryAvailable] = isMemorySufficient(x)
% Checks if it is possible to create x elements

% CHECK MEMORY SIZE
[~, systemview] = memory;
maxmemoryAvailable = systemview.PhysicalMemory.Available;
memoryRequired = x*8;

if ( memoryRequired < maxmemoryAvailable-maxmemoryAvailable*10/100 )
    bool = 1;
    return;
end

bool = 0;

end

