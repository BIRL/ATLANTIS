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

function togglePlotVisibility(source, callbackData, PlotObj)
% TOGGLES VISIBILITY OF CONTOUR PLOTS

try
    if strcmp(PlotObj.Visible, 'on')
        PlotObj.Visible = 'off';
        source.Label = strrep(source.Label, 'Hide', 'Show');
    elseif strcmp(PlotObj.Visible, 'off')
        PlotObj.Visible = 'on';
        source.Label = strrep(source.Label, 'Show', 'Hide');
    end
catch
end

end

