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

function addToggleAnnotationMenu(rootMenu, prominentSteadyStateIndicies, transientStateindicies, attractorIndicies, prominentSteadyStateMarks, transientStateMarks, attractorStateMarks)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% PARENT MENU
menuLabel = 'Toggle Annotations';
parentMenu = addContextMenuToFigure(rootMenu, menuLabel, '');

% ADD CONTEXT MENU TO TOGGLE ANNOTATIONS
if ~isempty(prominentSteadyStateIndicies)
    % CHILD MENU
    menuLabel = 'Hide Prominent Steady States';
    addContextMenuToFigure(parentMenu, menuLabel, {@toggleAnnotations, prominentSteadyStateMarks});
end

if ~isempty(transientStateindicies)
    % CHILD MENU
    menuLabel = 'Hide States Present in Trajectory';
    addContextMenuToFigure(parentMenu, menuLabel, {@toggleAnnotations, transientStateMarks});
end

if ~isempty(attractorIndicies)
    % CHILD MENU
    menuLabel = 'Hide Attractor States';
    addContextMenuToFigure(parentMenu, menuLabel, {@toggleAnnotations, attractorStateMarks});
end

end

