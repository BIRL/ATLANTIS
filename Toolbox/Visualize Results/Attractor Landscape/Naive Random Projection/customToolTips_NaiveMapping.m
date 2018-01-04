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

function dataTip = customToolTips_NaiveMapping(figHandle, coords, toolTipData, varargin)
% function: datatip(hPlot, index, str, varargin)

% set data-cursor mode properties
cursorMode = datacursormode(gcf);

set(cursorMode, 'enable', 'on', 'UpdateFcn', {@generateToolTip, toolTipData})

% delete the previous datatip(s) if needed
cursorMode.removeAllDataCursors
          
% get the z axis data
X = get(figHandle(1), 'XData');
Y = get(figHandle(1), 'YData');
Z = get(figHandle(1), 'ZData');

x = coords{1};
y = coords{2};

% determine the datatip position
pos = [X(x, y) Y(x, y) Z(y, x)];

% create a datatip
dataTip = cursorMode.createDatatip(figHandle(1));

% set the datatip marker appearance
set(dataTip, 'Position', pos, 'Marker','O', 'MarkerSize', 15, 'MarkerFaceColor','none',...
              'MarkerEdgeColor','k', 'OrientationMode','auto', 'BackgroundAlpha', 0.85);
          
updateDataCursors(cursorMode);

% turn Cursor Mode off
set(cursorMode, 'enable', 'off');

end

function toolTipInfo = generateToolTip(~, dataTip, toolTipData)

% determine current datatip position
pos = get(dataTip, 'Position');
currX = pos(1);
currY = pos(2);

% EXTRACT GRID TOOL TIP DATA 
gridToolTipData = toolTipData{1};
gridLen = length(gridToolTipData);

% EXTRACT GRID INFO -> X AND Y
xy = toolTipData{2};
x = xy(:, 2);
y = xy(:, 1);

% NORMALIZE THE POINTS
currX = 1+(gridLen-1)*(currX-min(x))/( max(x)-min(x));
currY = 1+(gridLen-1)*(currY-min(y))/( max(y)-min(y));

% EXTRACT TOOL TIP INFORMATION OF THIS POINT
pointToolTip = gridToolTipData{currX, currY};

% IF POINT IS NOT AN ATTRACTOR THAN CREATE EMPTY DATA
if isempty(pointToolTip)
    [r, c] = find(cellfun(@isempty, gridToolTipData) == 0);
    [~, index] = ismembertol([currX, currY], [r, c], 0.04, 'ByRows', true);
    
    % IF POINT STILL NOT FOUND RETURN
    if index == 0
        toolTipInfo = {};
        return;
    end
    % EXTRACT TOOL TIP INFORMATION OF THIS POINT
    pointToolTip = gridToolTipData{r(index), c(index)};
end

% toolTipInfo = {[' ', pointToolTip{1}]};

% form the X and Y axis datatip labels
toolTipInfo = {[char('Attractor #: '), joinStr_CellArr(pointToolTip{1}, '')], [char('Type: ') pointToolTip{2}],...
                   pointToolTip{3}, [char('Associated Cell Fate: ') pointToolTip{4}], ...
                   [char('Order in Trajectory: ') pointToolTip{5}],...
                   [char('Basin Size: ') num2str(pointToolTip{6})],...
                   [char('Probability: ') num2str(pointToolTip{7})],...
                   [char('Output Nodes Activities (ONAs): ') num2str(pointToolTip{8})],...
                   [char('Average ONAs of this Attractor: ') num2str(pointToolTip{9})]};

end