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

function updateGraphics
% Makes the ATLANTIS gui buttons active and updates the CDATA

% GET ALTANTIS HANDLES
handles = guidata(findall(0, 'tag','ATLANTIS_Main'));

% GET NETWORK OBJECT
myNetwork = get(0, 'UserData');

% CONVERT TO OBJECT
if iscell(myNetwork)
    myNetwork = myNetwork{1};
end

% CHECK IF THE OBJECT IS VALID
if isobject(myNetwork)
    
    % CHECK IF ANY ANALYSIS IS PERFORMED
    analysis = 0;
    if ~isempty(myNetwork.AttractorTable) || ~isempty(myNetwork.SteadyStateProbabilities)
        analysis = 1; 
    end
    
    % UPDATE BUTTON GRAPHICS AND SET TO ACTIVE
    set(handles.ModifyNetwork, 'Enable', 'on');
    set(handles.SketchNetwork, 'Enable', 'on');
    set(handles.DeterministicAnalysis, 'Enable', 'on');
    set(handles.ProbabilisticAnalysis, 'Enable', 'on');
        
    if strcmp(myNetwork.NetworkType, 'RulesBased') 
        % Button-5: PROBABILISTIC ANALYSIS BUTTON
        set(handles.ProbabilisticAnalysis, 'Enable', 'off');
    end
            
    if (analysis)
        % Button-6: VIEW RESULTS BUTTON
        set(handles.VisualizeResults, 'Enable', 'on');
    end
else
        
    % Button-2: MODIFY NETWORK BUTTON
    set(handles.ModifyNetwork, 'Enable', 'off');

    % Button-3: SKETCH NETWORK BUTTON
    set(handles.SketchNetwork, 'Enable', 'off');
    
    % Button-4: DETERMINISTIC ANALYSIS BUTTON
    set(handles.DeterministicAnalysis, 'Enable', 'off');

    % Button-5: PROBABILISTIC ANALYSIS BUTTON
    set(handles.ProbabilisticAnalysis, 'Enable', 'off');
        
    % Button-6: VIEW RESULTS BUTTON
    set(handles.VisualizeResults, 'Enable', 'off');
    
end

guidata(findall(0, 'tag','ATLANTIS_Main'), handles);

end

