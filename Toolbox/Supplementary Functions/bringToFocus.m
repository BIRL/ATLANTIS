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

function bringToFocus( figHandle )
% BRING FIGURE WINDOW TO FOCUS

try
    warning('off', 'all');
    jPeer = get(figHandle, 'JavaFrame');
    jPeer.getAxisComponent.requestFocus;
    
    if ~isempty(findall(0, 'Name','Legend'))
        jPeer = get(findall(0, 'Name','Legend'), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
    end
    warning('on', 'all');
catch
end
end

