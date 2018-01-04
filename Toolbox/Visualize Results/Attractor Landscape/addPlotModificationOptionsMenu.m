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

function addPlotModificationOptionsMenu(figHandle, rootMenu, h)
% ADDS PLOT MODIFICATION OPTIONS IN CONTEXT MENU OF THE FIGURE

% PARENT MENU
menuLabel = 'Toggle Plot Properties';
parentMenu = addContextMenuToFigure(rootMenu, menuLabel, '');

% CHILD MENU 1
menuLabel = 'Hide Surface Plot';
addContextMenuToFigure(parentMenu, menuLabel, {@togglePlotVisibility, h(1)});

% CHILD MENU 2
menuLabel = 'Hide Contour Plot';
addContextMenuToFigure(parentMenu, menuLabel, {@togglePlotVisibility, h(2)});

% CHILD MENU 3
menuLabel = 'Invert Plot';
axis = findall(figHandle.Children, 'type', 'Axes');
addContextMenuToFigure(parentMenu, menuLabel, {@InvertPlot, axis});

% CHILD MENU 4
menuLabel = 'Toggle Plot Colormap';
childMenu = addContextMenuToFigure(parentMenu, menuLabel, '');
colors = {'hot', 'autumn', 'cool', 'gray', 'hsv', 'jet', 'prism', 'spring', 'summer', 'winter'};
for i = 1:numel(colors)
    addContextMenuToFigure(childMenu, colors{i}, {@togglePlotColor, figHandle, colors{i}});
end

% CHILD MENU 5
menuLabel = 'Toggle Surface Plot Face Color';
childMenu = addContextMenuToFigure(parentMenu, menuLabel, '');
faceColors = {'texture', 'interp', 'flat'};
for i = 1:numel(faceColors)
    addContextMenuToFigure(childMenu, faceColors{i}, {@toggleSurfacePlotFaceColor, h(1), faceColors{i}});
end

% CHILD MENU 6
menuLabel = 'Toggle Plot Alpha';
childMenu = addContextMenuToFigure(parentMenu, menuLabel, '');
values = 0:0.1:1;
for i = 1:numel(values)
    addContextMenuToFigure(childMenu, num2str(values(i)), {@togglePlotAlpha, h(1), values(i)});
end

end

