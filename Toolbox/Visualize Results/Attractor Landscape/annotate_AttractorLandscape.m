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
function [prominentSteadyStateIndicies, transientStateindicies, attractorIndicies, attractorStateMarks, transientStateMarks, prominentSteadyStateMarks, arrowsObj] = annotate_AttractorLandscape(x, y, zData, stateSpaceLen, mappingMethod, randomInd, attractorIndiciesOriginal, transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal )
% ANNOTATES ATTRACTOR STATES, STATES IN TRACED TRACJECTORY AND PROMINENT
% STATES

if strcmp(mappingMethod, 'sammon')
    z = zData{1};
    Z = zData{2};
    
    % SET TOLERANCE
    precision = length(num2str(10*(x(1)-floor(Z(1)))))/4;
    tol = 10^-(precision);
    
    % SHIFT FACTOR
    shiftBy = 0.2*stateSpaceLen/100;
    
    % FIND NEW INDICIES
    [~, attractorIndicies] = ismembertol(z(attractorIndiciesOriginal), Z(:), tol, 'ByRows', true);
    [~, transientStateindicies] = ismembertol(z(transientStateindiciesOriginal), Z(:), tol, 'ByRows', true);
    [~, prominentSteadyStateIndicies] = ismembertol(z(prominentSteadyStateIndiciesOriginal), Z(:), tol, 'ByRows', true);
elseif strcmp(mappingMethod, 'naive')
    Z = zData;
    
    % SHIFT FACTOR
    shiftBy = 1.2*stateSpaceLen/100;
    
    % FIND NEW INDICIES
    [~, attractorIndicies] = ismember(attractorIndiciesOriginal, randomInd);
    [~, transientStateindicies] = ismember(transientStateindiciesOriginal, randomInd);
    [~, prominentSteadyStateIndicies] = ismember(prominentSteadyStateIndiciesOriginal, randomInd);
end

attractorIndicies(attractorIndicies == 0) = [];
transientStateindicies(transientStateindicies == 0) = [];
prominentSteadyStateIndicies(prominentSteadyStateIndicies == 0) = [];
    
hold on;

zShift = 0.005;
infac = 0.02;

% MARK ATTRACTOR STATES
if ~isempty(attractorIndiciesOriginal)        
    % MARKER PROPERTIES
    markerColor =  [0.8216 0.2176 0.8137]; % ATTRACTOR STATE MARKER COLOR
    markerShape  = '*';
    
    % ADD MARKS
    attractorStateMarks = scatter3(x(attractorIndicies), ...
        y(attractorIndicies), Z(attractorIndicies) + zShift, 120, markerColor, 'Marker', markerShape,'LineWidth', 2);
    
    zShift = zShift + infac;
else
    attractorStateMarks = [];
end

% MARK STATES IN TRAJECTORY
if ~isempty(transientStateindiciesOriginal)
    
    % MARKER PROPERTIES
    markerColor =  [0.3 1 0.1]; % TRANSIENT STATE MARKER
    markerShape  = '+';
    
    % GENERATE LABELS
    numOfPoints = numel(transientStateindicies);
    pointLabels = cellfun(@num2str, num2cell(1:numOfPoints),'un',0);
    
    % ADD START AND END LABEL IF ANNOTATING TRAJECTORY
    pointLabels(1) = {'Start (1)'};
    pointLabels(end) = {['End', ' (', num2str(numOfPoints),')']};
    pointLabels = fliplr(pointLabels);
    
    % ARROW PROPERTIES
    Length = 3;
    BaseAngle = 30;
    TipAngle = 60;
    Width = 1;
    
    % ADD MARKS
    transientStateMarks = gobjects(numel(transientStateindicies)*2, 1);
    
    % ADD ARROWS
    arrowsObj = gobjects(numel(transientStateindicies)-1, 1);
    
    colorS = jet(numel(transientStateindicies));
    
    for i = 1:numel(transientStateindicies)
        index = transientStateindicies(i);
        transientStateMarks(i) = scatter3(x(index), ...
            y(index), Z(index) + zShift, 40, markerColor, 'Marker', markerShape,'LineWidth', 2);
        
        if i == 1 || i == numel(transientStateindicies)
            fontSizE = 15;
        else
            fontSizE = 12;
        end
        transientStateMarks(i + numel(transientStateindicies)) = text(x(index) + shiftBy*1.2, y(index) + shiftBy*1.2, Z(index) + zShift, pointLabels(i), 'Color', [0 0 0], 'FontSize', fontSizE, 'FontWeight', 'bold');
        
        if i < numel(transientStateindicies)
            % ADD ARROWS
            startInd = transientStateindicies(i + 1) ;
            Start = [x(startInd), y(startInd), Z(startInd)];
            Stop = [x(index), y(index), Z(index)];

            arrowsObj(i) = arrow(Start, Stop, Length, BaseAngle, TipAngle, Width, 'FaceColor', [0 0 0], 'EdgeColor', colorS(i, :));% [255 140 0.1]./260);
            arrowsObj(i).Visible = 'off';
        end
    end
    zShift = zShift + infac;
else
    arrowsObj = [];
    transientStateMarks = [];
end

% MARK PROMINENT STATES
if ~isempty(prominentSteadyStateIndiciesOriginal)
    % MARKER PROPERTIES
    markerColor =  [0.1137 0.4667 0.9216]; % PROMINENT STATE MARKER
    markerShape  = 'x';
    
    % ADD MARKS
    prominentSteadyStateMarks = scatter3(x(prominentSteadyStateIndicies), ...
        y(prominentSteadyStateIndicies), Z(prominentSteadyStateIndicies) + zShift, 80, markerColor, 'Marker', markerShape,'LineWidth', 2);
else
    prominentSteadyStateMarks = [];
end

end

