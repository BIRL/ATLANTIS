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

function dataTip = customToolTips_SammonMapping(figHandle, index, toolTipData, varargin)
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

% determine the datatip position
pos = [X(index) Y(index) Z(index)];

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
currZ = pos(3);

% EXTRACT GRID TOOL TIP DATA 
gridToolTipData = toolTipData{1};

% EXTRACT GRID INFO -> X AND Y
xyz = toolTipData{2};
x = xyz(:, 1);
y = xyz(:, 2);
z = xyz(:, 3);

% FIND MATCHES
precision = length(num2str(10*(x(1)-floor(x(1)))))/3;
tol = 10^-(precision);
[~, index] = ismembertol([currX, currY, currZ], [x, y, z], tol, 'ByRows', true);

if index == 0
    toolTipInfo = {};
    return;
end

% EXTRACT TOOL TIP INFORMATION OF THIS POINT
pointToolTips = gridToolTipData(index);

% REMOVE EMPTY
pointToolTips(cellfun(@isempty, pointToolTips)) = [];

% SELECT FIRST ONE


% IF POINT IS NOT AN ATTRACTOR THAN CREATE EMPTY DATA
if isempty(pointToolTips)
%     pointToolTip = cell(5, 1);
%     pointToolTip(:) = {'N/A'};
%     toolTipInfo = {['x: ', num2str(currX), ' | y: ', num2str(currY)], ' | z: ', num2str(currZ)};
    toolTipInfo = {};
else
    pointToolTip = pointToolTips{1};
    % form the X and Y axis datatip labels
    toolTipInfo = {[char('Attractor #: '), joinStr_CellArr(pointToolTip{1}, '')], [char('Type: ') pointToolTip{2}],...
                   pointToolTip{3}, [char('Associated Cell Fate: ') pointToolTip{4}], ...
                   [char('Order in Trajectory: ') pointToolTip{5}],...
                   [char('Basin Size: ') num2str(pointToolTip{6})],...
                   [char('Probability: ') num2str(pointToolTip{7})],...
                   [char('Output Nodes Activities (ONAs): ') num2str(pointToolTip{8})],...
                   [char('Average ONAs of this Attractor: ') num2str(pointToolTip{9})]};
end

end