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

function toggleEdgeLabels(source, callbackData, textObj)
% TOGGLES VISIBILITY STATE OF EDGE LABELS

try
    if strcmp(textObj(1).Visible, 'on')
        State = 'off';
        source.Label = strrep(source.Label, 'Hide', 'Show');
    elseif strcmp(textObj(1).Visible, 'off')
        State = 'on';
        source.Label = strrep(source.Label, 'Show', 'Hide');
    end
    for i = 1:numel(textObj)
        textObj(i).Visible = State;
    end
catch
end

end

