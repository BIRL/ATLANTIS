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

function enableATLANTIS
% ENABLE ATLANTIS FIGURE
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'on');
try
    warning('off', 'all');
    jPeer = get(findall(0, 'tag','ATLANTIS_Main'), 'JavaFrame');
    jPeer.getAxisComponent.requestFocus;
    warning('on', 'all');
catch
end
end

