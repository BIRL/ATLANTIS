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

function addLegendsForBiograph(figName)


if isempty(findall(0, 'Name', figName))
    % CONSTRUCT LEGENDS
    legendsFig = figure;
    legendsFig.Color = [1 1 1];
    legendsFig.NumberTitle = 'off';
    legendsFig.MenuBar = 'none';
    legendsFig.Name = figName;
    pos = legendsFig.Position;
    rf1 = 0.62; % REDUCTION FACTOR
    rf2 = 0.2;
    legendsFig.Position = [pos(1) pos(2) pos(3)*rf1 pos(4)*rf2];
    movegui(legendsFig, 'northeast');
    
    hold on;
    
    currentAxis = legendsFig.Children;
    posAxis = currentAxis.Position;
    currentAxis.Visible = 'off';
    
    le(1) = plot(NaN,NaN,'-r');
    le(2) = plot(NaN,NaN,'-g');
    le(3) = plot(NaN,NaN,'-b');
    le(4) = plot(NaN,NaN,'-w');
    
    legendsObj = legend(le,{'Inhibition Arrow','Activation Arrow','Undirected Arrow', 'Edge Thickness Reflects Interaction Magnitude'}, 'location', 'NorthOutside', 'FontSize', 9, 'FontWeight', 'bold');
    legendsObj.Position = [posAxis(1) posAxis(2) posAxis(3) posAxis(4)*0.7];
    legendsObj.Box = 'off';
    
    legendsObj.PickableParts = 'none';
    
%     text(0-0.11, 0, 'The thickness of the edges reflect the interaction magnitude', 'FontSize', 7);
end

end

