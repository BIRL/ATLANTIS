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

function addLegendsForAttractorPlots

% ATTRACTORS
le(1) = plot(NaN,NaN,'*');
le(1).Color = [0.8216 0.2176 0.8137];
le(1).LineWidth = 2;
le(1).MarkerSize = 10;

% STATES IN THE TRAJECTORY
le(2) = plot(NaN,NaN,'+');
le(2).Color = [0.3 1 0.1];
le(2).LineWidth = 2;
le(2).MarkerSize = 6;

% PROMINENT STATES
le(3) = plot(NaN,NaN,'x');
le(3).Color = [0.1137 0.4667 0.9216];
le(3).LineWidth = 2;
le(3).MarkerSize = 8;

% TOOLTIP CURSOR
le(4) = plot(NaN,NaN,'Ok');
le(4).LineWidth = 1;
le(4).MarkerSize = 12;

% fig = gcf;
% ax = findall(fig.Children, 'type', 'Axes');
% 
% ax1 = axes('Position',[0 0 1 1],'Visible','off');
% axes(ax1) % sets ax1 to current axes
% a = text(0.01, 0.02, -1, 'Right Click on the Figure For More Options', 'FontWeight', 'Bold');

% % RIGHT CLICK
le(5) = plot(NaN,NaN, '-w'); %, 'MarkerFaceColor', fiG.Color, 'MarkerSize', 12, 'MarkerEdgeColor', fiG.Color);

legendsObj = legend(le,{'Attractor States','States in the Mapped Trajectory','Robust/High Probability States', 'Tooltip Data Cursor', 'Note: Right Click for More Options'}, 'location', 'BestOutside', 'FontSize', 10, 'FontWeight', 'bold');

% pos = legendsObj.Position;
% legendsObj.Position = [pos(1), pos(2), pos(3), pos(4)*1.2];
% axes(ax);

end