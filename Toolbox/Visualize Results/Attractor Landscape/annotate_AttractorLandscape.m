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

function [prominentSteadyStateIndicies, transientStateindicies, attractorIndicies, attractorStateMarks, transientStateMarks, prominentSteadyStateMarks] = annotate_AttractorLandscape(x, y, zData, stateSpaceLen, mappingMethod, randomInd, attractorIndiciesOriginal, transientStateindiciesOriginal, prominentSteadyStateIndiciesOriginal )
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
    attractorIndicies(attractorIndicies == 0) = [];
    transientStateindicies(transientStateindicies == 0) = [];
    prominentSteadyStateIndicies(prominentSteadyStateIndicies == 0) = [];
elseif strcmp(mappingMethod, 'naive')
    Z = zData;
    
    % SHIFT FACTOR
    shiftBy = 1.2*stateSpaceLen/100;
    
    % FIND NEW INDICIES
    [~, attractorIndicies] = ismember(attractorIndiciesOriginal, randomInd);
    [~, transientStateindicies] = ismember(transientStateindiciesOriginal, randomInd);
    [~, prominentSteadyStateIndicies] = ismember(prominentSteadyStateIndiciesOriginal, randomInd);
end

hold on;

% MARK ATTRACTOR STATES
if ~isempty(attractorIndiciesOriginal)        
    % MARKER PROPERTIES
    markerColor =  [0.8216 0.2176 0.8137]; % ATTRACTOR STATE MARKER COLOR
    markerShape  = 'x';
    
    % ADD MARKS
    attractorStateMarks = scatter3(x(attractorIndicies) + shiftBy, ...
        y(attractorIndicies) + shiftBy, Z(attractorIndicies) + 0.005, 40, markerColor, 'Marker', markerShape,'LineWidth', 2);
else
    attractorStateMarks = [];
end

% MARK STATES IN TRAJECTORY
if ~isempty(transientStateindiciesOriginal)
    
    % MARKER PROPERTIES
    markerColor =  [0.3 1 0.1]; % TRANSIENT STATE MARKER
    markerShape  = 'x';
    
    % GENERATE LABELS
    numOfPoints = numel(transientStateindicies);
    pointLabels = cellfun(@num2str, num2cell(1:numOfPoints),'un',0);
    
    % ADD START AND END LABEL IF ANNOTATING TRAJECTORY
    pointLabels(1) = {'Start (1)'};
    pointLabels(end) = {['End', ' (', num2str(numOfPoints),')']};
    
    % ADD MARKS
    transientStateMarks = gobjects(numel(transientStateindicies)*2, 1);
    for i = 1:numel(transientStateindicies)
        index = transientStateindicies(i);
        transientStateMarks(i) = scatter3(x(index) + shiftBy, ...
            y(index) - shiftBy, Z(index) + 0.005, 40, markerColor, 'Marker', markerShape,'LineWidth', 2);
        transientStateMarks(i + numel(transientStateindicies)) = text(x(index) - shiftBy*1.2, y(index) + shiftBy*1.4, Z(index) + 0.02, pointLabels(i), 'Color', [0 0 0]);
    end
else
    transientStateMarks = [];
end

% MARK PROMINENT STATES
if ~isempty(prominentSteadyStateIndiciesOriginal)
    % MARKER PROPERTIES
    markerColor =  [0.1137 0.8667 0.9216]; % PROMINENT STATE MARKER
    markerShape  = 'x';
    
    % ADD MARKS
    prominentSteadyStateMarks = scatter3(x(prominentSteadyStateIndicies) - shiftBy, ...
        y(prominentSteadyStateIndicies) + shiftBy, Z(prominentSteadyStateIndicies) + 0.005, 40, markerColor, 'Marker', markerShape,'LineWidth', 2);
else
    prominentSteadyStateMarks = [];
end

end

