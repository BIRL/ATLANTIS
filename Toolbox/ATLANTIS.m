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


function varargout = ATLANTIS(varargin)
% ATLANTIS MATLAB code for ATLANTIS.fig
%      ATLANTIS, by itself, creates a new ATLANTIS or raises the existing
%      singleton*.
%
%      H = ATLANTIS returns the handle to a new ATLANTIS or the handle to
%      the existing singleton*.
%
%      ATLANTIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATLANTIS.M with the given input arguments.
%
%      ATLANTIS('Property','Value',...) creates a new ATLANTIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ATLANTIS_OpeningFcn gets called.  An
%      unrecognized property name or invalidvalue makes property application
%      stop.  All inputs are passed to ATLANTIS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ATLANTIS

% Last Modified by GUIDE v2.5 09-Aug-2017 21:27:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ATLANTIS_OpeningFcn, ...
    'gui_OutputFcn',  @ATLANTIS_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ATLANTIS is made visible.
function ATLANTIS_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ATLANTIS (see VARARGIN)

% Choose default command line output for ATLANTIS
handles.output = hObject;

% ADD THE PATH OF ALL DEPENDENCIES TO MATLAB DIRECTORY
currentpath = mfilename('fullpath');
[path, ~, ~] = fileparts(currentpath);
allPaths = genpath(path);
addpath(allPaths);
setappdata(0, 'ATLANTISpaths', allPaths);

% IMAGE PATH
graphicsFilePath = ['Images', filesep, 'Active', filesep];

% Add ATLANTIS Logo
LogoImage = imread([graphicsFilePath, 'Logo.jpg']);
LogoImageResize = imresize(LogoImage, [68 95]);
set(handles.LogoButton, 'CData', LogoImageResize);

% ADDING IMAGES TO ALL THE ATLANTIS_MAIN PAGE BUTTON
resizeFactor = [145 173];

% Button-1: GENERATE NETWORK BUTTON
GenerateNetworkImage = imread([graphicsFilePath, 'Create Network.jpg']);
GenNetImageResize = imresize(GenerateNetworkImage, resizeFactor);
set(handles.GenerateNetwork, 'CData', GenNetImageResize);

% Button-2: MODIFY NETWORK BUTTON
EditNetworkImage = imread([graphicsFilePath, 'Edit Network.jpg']);
EditNetImageResize = imresize(EditNetworkImage, resizeFactor);
set(handles.ModifyNetwork, 'CData', EditNetImageResize, 'Enable', 'off');

% Button-3: SKETCH NETWORK BUTTON
SketchNetworkImage = imread([graphicsFilePath, 'Sketch Network.jpg']);
SketchNetImageResize = imresize(SketchNetworkImage, resizeFactor);
set(handles.SketchNetwork, 'CData', SketchNetImageResize, 'Enable', 'off');

% Button-4: DETERMINISTIC ANALYSIS BUTTON
DeterministicAnalysisNetworkImage = imread([graphicsFilePath, 'Deterministic Analysis.jpg']);
DeterministicAnalysisImageResize = imresize(DeterministicAnalysisNetworkImage, resizeFactor);
set(handles.DeterministicAnalysis, 'CData', DeterministicAnalysisImageResize, 'Enable', 'off');

% Button-5: PROBABILISTIC ANALYSIS BUTTON
ProbabilisticAnalysisNetworkImage = imread([graphicsFilePath, 'Probabilistic Analysis.jpg']);
ProbabilisticAnalysisImageResize = imresize(ProbabilisticAnalysisNetworkImage, resizeFactor);
set(handles.ProbabilisticAnalysis, 'CData', ProbabilisticAnalysisImageResize, 'Enable', 'off');

% Button-6: VIEW RESULTS BUTTON
ViewResultsImage = imread([graphicsFilePath, 'View Results.jpg']);
ViewResultsImageResize = imresize(ViewResultsImage, resizeFactor);
set(handles.VisualizeResults, 'CData', ViewResultsImageResize, 'Enable', 'off');

% UDPATE VERSION HISTORY
try
    data = importdata('ATLANTIS_Version.txt');
    set(handles.versionHistory, 'String', data);
catch
end

% MOVE GUI TO CENTER
movegui(hObject, 'center');

% SET OPENGL TO SOFTWARE
% opengl software;

updateGraphics

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);

% UIWAIT makes ATLANTIS wait for user response (see UIRESUME)
% uiwait(handles.ATLANTIS_Main);


% --- Outputs from this function are returned to the command line.
function varargout = ATLANTIS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% THIS IS WHERE THE BUTTONS AND THEIR CALL BACKS BEGIN
% --- Executes on button press in GenerateNetwork.
function GenerateNetwork_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to GenerateNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

if iscell(myNetwork) || isobject(myNetwork)
    choice = questdlg('Do you want to replace previous network?', ...
        'Warning', 'Yes', 'No', 'No');
    % HANDLE RESPONSE
    switch choice
        case 'Yes'
            % REMOVE NETWORK
            set(0, 'UserData', 0);
            
            % REMOVE PREVIOUS INPUT INFORMATION
            appdatas = {'MutationFiles', 'NetworkfileName', 'CellFateLogic', 'InputNodeStates', 'TrajectoryBounds'};
            for i = 1:numel(appdatas)
                try
                    rmappdata(0, appdatas{i});
                catch
                end
            end
            
            % UPDATE GRAPHICS
            updateGraphics;
            
            % CALL GENERATE NETWORK MENU
            GenerateNetwork;
        otherwise
            return;
    end
else
    GenerateNetwork;
end


% --- Executes on button press in ModifyNetwork.
function ModifyNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to ModifyNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% GET MUTATION INFO
mutationInfo = getappdata(0, 'MutationFiles');

if ~isempty(mutationInfo) % IF NOT EMPTY
    choice = questdlg('Do you want to remove previously added mutations?', ...
        'Warning', 'Yes', 'No', 'No');
    % HANDLE RESPONSE
    switch choice
        case 'Yes'
            % REMOVE PREVIOUS MUTATION INFO
            if iscell(myNetwork)
                myNetwork = myNetwork{1}.NetworkBackUp;
            else
                myNetwork = myNetwork.NetworkBackUp;
            end
            
            % REMOVE PREVIOUS INPUT INFORMATION
            appdatas = {'MutationFiles', 'CellFateLogic', 'InputNodeStates', 'TrajectoryBounds'};
            for i = 1:numel(appdatas)
                try
                    rmappdata(0, appdatas{i});
                catch
                end
            end
            
            % RESTORE PREVIOUS NETWORK
            set(0, 'UserData', myNetwork);
            
            % SAVE CHANGES IN GUIDATA
            guidata(hObject, handles);
        otherwise
            return;
    end
end

% CALL MODIFY NETWORK MENU
ModifyNetwork;


% --- Executes on button press in SketchNetwork.
function SketchNetwork_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to SketchNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

if isobject(myNetwork)
    referenceNetwork = myNetwork;
elseif iscell(myNetwork) % CHECK IF MULTIPLE JOBS
    
    % LET USER TO SELECT NETWORK(S) TO SKETCHED.
    fileNames = getappdata(0, 'MutationFiles');
    
    [selection, ~] = listdlg('PromptString','Select networks for sketching:',...
        'SelectionMode','single',...
        'ListString',fileNames);
    
    if isempty(selection)
        return;
    end
    
    % REFERENCE NETWORK
    referenceNetwork = myNetwork{selection(1)};
    
    % UPDATE NETWORK
    set(0, 'UserData', referenceNetwork);
end

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% GET USER DEFINED SKETCHING OPTIONS
uiwait(NetworkSketchingOptions);

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% GET GRAPH SKETCHING OPTIONS
sketchingEngine = getappdata(0, 'SketchingEngine');

% IF SOMETHING GOES WRONG THEN
if isempty(sketchingEngine)
    
    % ENABLE ATLANTIS
    enableATLANTIS;
    
    % RESTORE THE NETWORKS
    if iscell(myNetwork)
        set(0, 'UserData', myNetwork);
    end
    
    return;
else
    
    % DEFAULT
    bool = 0;
    
    % IF EVERTHING THEN MOVE PROCEED WITH NETWORK SKETCHING
    try
        % DEFAULT ERROR MESSAGE
        message = 'Error while sketching the network';
        
        if strcmp(sketchingEngine, 'GraphViz')    
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            
            % GET SKETCHING OPTIONS
            uiwait(GraphVizMenu);
            
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            
            sketchingOptions = getappdata(0, 'SketchingOptions');
            
            if ~isempty(sketchingOptions)
                % GET DOT FILE
                dotFile = referenceNetwork.DotFileInfo;
                
                % SKETCHING USING BIOGRAPH
                [bool, figHandle] = sketchGraphUsingGraphViz(dotFile);
            
                if ~bool
                    message = 'Network sketching failed. Error plotting sketching network using GraphViz';
                    undefined/0;
                end
            else
                message = 'Sketching process cancelled by the user';
                undefined/0;
            end
        elseif strcmp(sketchingEngine, 'Biograph')
            
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            
            % SKETCH NETWORK USING BIOGRAPH
            [bool, figHandle, ~] = sketchGraphUsingBiograph(referenceNetwork);
            movegui(figHandle, 'center');
            
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            
            % IF NO ERRORS
            if bool
                % FILE NAME
                figName = 'legend';
                
                % CREATE LEGENDS
                addLegendsForBiograph(figName)
            else
                message = 'Network sketching failed. Error plotting sketching network using Biographs';
                undefined/0;
            end
        end
        
    catch
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        % THROW ERROR MESSAGE IF SOMETHING GOES WRONG
        uiwait(errordlg(message, 'Error'));
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'on');
        bringToFocus(findall(0, 'tag','ATLANTIS_Main'));
    end
end

% RESTORE NETWORK ARRAY ONCE DONE (IN CASE OF MULTIPLE NETWORKS)
if iscell(myNetwork)
    set(0, 'UserData', myNetwork);
end

% RESET DETERMINISTIC ANALYSIS
setappdata(0, 'SketchingEngine', []);

% ENABLE ATLANTIS GUI
enableATLANTIS;

% BRING FOCUS TO THE NETWORK SKETCH
if bool
    try
        bringToFocus(figHandle)
    catch
    end
end

% SAVE GUI DATA
guidata(hObject, handles);


% --- Executes on button press in DeterministicAnalysis.
function DeterministicAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to DeterministicAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

if isobject(myNetwork)
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % PREPARE FOR DETERMINISTIC ANALYSIS
    uiwait(DeterministicAnalysisMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % CHECK IF ALL DATA FOR ANALYSIS IS PRESENT
    bool = getappdata(0, 'DeterministicAnalysis');
    
    if isempty(bool)
        enableATLANTIS;
        return;
    end 
    
    progressbar('Total Progress', 'Finding Attractors. Please Wait...');
    
    try
        
%         time = 'Peforming DA'; %$
        
%         tic; %$
        
        % PERFORM DETERMINISTIC ANALYSIS
        [bool, message] = perform_DeterministicAnalysis(myNetwork, 0);

%         time = [time, '   ', 'total time taken by DA + Cell Fate Association: ', num2str(toc)]; %$
        
        progressbar(1, 1);
        
        if bool && getappdata(0, 'SaveDeterministicAnalysis')
            
%             myNetwork.Time = time; %$
            
            bool = save_DeterministicAnalysisResults(myNetwork);
             
            if ~bool
                message = 'Analysis complete. However, results could not be saved due to an error. Please check if the matlab directory is set to ATLANTIS toolbox folder and then re-try. Also, if you are using an ATLANTIS .exe, then run as administrator. If the problem persists than kindly email us at safee.ullah@gmail.com.';
                undefined/0; %#ok<*VUNUS>
            end
            
            % MESSAGE
            uiwait(msgbox(['Results saved in "', myNetwork.ResultFolderName, '"'], 'Notification'));
            
            % SAVE GUI DATA
            guidata(hObject, handles);
        elseif bool == 1
            uiwait(msgbox('Deterministic analysis completed successfully.', 'Success'));
            % SAVE GUI DATA
            guidata(hObject, handles);
        elseif bool == 0
            undefined/0;
        end
        
    catch
        uiwait(errordlg(message, 'Error'));
        enableATLANTIS;
        updateGraphics;
        return;
    end
    
elseif iscell(myNetwork) % CHECK IF MULTIPLE JOBS
    
    % LET USER TO SELECT NETWORK(S) TO BE DETERMINISTICALLY ANALYZED
    fileNames = getappdata(0, 'MutationFiles');
    
    [selection, ~] = listdlg('PromptString','Select networks for analysis:',...
        'SelectionMode','multiple',...
        'ListString',fileNames);
    
    if isempty(selection)
        return;
    end
    
    % PREPARE FOR DETERMINISTIC ANALYSIS
    set(0, 'UserData', myNetwork{selection(1)});
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    uiwait(DeterministicAnalysisMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % CHECK IF ALL DATA FOR ANALYSIS IS PRESENT
    bool = getappdata(0, 'DeterministicAnalysis');
    
    if isempty(bool)
        % SAVE NETWORK
        set(0, 'UserData', myNetwork);
        enableATLANTIS;
        updateGraphics;
        return;
    end
    
    % REFERENCE NETWORK
    referenceNetwork = myNetwork{selection(1)};
    
    % ERROR LOG
    errorlog = [];
    
    totalProgress = 0;
    
    for i = 1:numel(selection)
        set(0, 'UserData', myNetwork{selection(i)});
        
        if i ~= 1
            myNetwork{selection(i)}.AttractorSearchDuration = referenceNetwork.AttractorSearchDuration;
            myNetwork{selection(i)}.NetworkStateList = referenceNetwork.NetworkStateList;
            
            myNetwork{selection(i)}.CellFateDeterminationLogic = referenceNetwork.CellFateDeterminationLogic;
            myNetwork{selection(i)}.OutputNodes = referenceNetwork.OutputNodes;
            myNetwork{selection(i)}.OutputNodesIndices = referenceNetwork.OutputNodesIndices;
            myNetwork{selection(i)}.AssociatedCellFates = referenceNetwork.AssociatedCellFates;
            myNetwork{selection(i)}.UniqueCellFates = referenceNetwork.UniqueCellFates;
        end
        
        try
            progressbar('Total Progress', 'Finding Attractors. Please Wait...');
                        
            % PERFORM DETERMINISTIC ANALYSIS
            [bool, message] = perform_DeterministicAnalysis(myNetwork{selection(i)}, totalProgress);
                        
            totalProgress = i/numel(selection);
            progressbar(totalProgress, 0);
            
            if bool && getappdata(0, 'SaveDeterministicAnalysis')
                % SAVE RESULTS
                                
                bool = save_DeterministicAnalysisResults(myNetwork{selection(i)});
                
                if ~bool
                    undefined/0;
                end
            elseif bool == 0
                undefined/0;
            end
            
        catch
            errorlog = [errorlog, ' "', myNetwork{selection(i)}.FileName, '", '];
        end
        set(0, 'UserData', myNetwork);
    end
    
    % SAVE NETWORK
    set(0, 'UserData', myNetwork);
    
    % CHECK FOR ERROR MESSAGES
    if ~isempty(message)
        uiwait(errordlg(message, 'Error'));
    end
    
    if ~isempty(errorlog)
        % PARTIAL SUCCESS
        uiwait(errordlg(['The following jobs: ', errorlog, ' were not successful. The results of rest of the jobs saved in ', referenceNetwork.ResultFolderName, '"'], 'Error'));
    else
        if getappdata(0, 'SaveDeterministicAnalysis')
            % COMPLETE SUCCESS
            uiwait(msgbox(['All the jobs were successfully carried out. Results saved in ', referenceNetwork.ResultFolderName, '"'], 'Success'));
        else
            uiwait(msgbox('All the jobs were successfully carried out.', 'Success'));
        end
    end
    
else
    uiwait(errordlg('Please generate a network first', 'Error'));
    updateGraphics;
    enableATLANTIS;
    return;
end

% RESET DETERMINISTIC ANALYSIS
setappdata(0, 'DeterministicAnalysis', []);

% ENABLE GRAPHICS
enableATLANTIS;

% UDPATE ATLANTIS_MAIN PAGE
updateGraphics;

% SAVE GUI DATA
guidata(hObject, handles);


% --- Executes on button press in ProbabilisticAnalysis.
function ProbabilisticAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to ProbabilisticAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

if isobject(myNetwork)
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % PREPARE FOR PROBABILISTIC ANALYSIS
    uiwait(ProbabilisticAnalysisMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % CHECK IF ALL DATA FOR ANALYSIS IS PRESENT
    bool = getappdata(0, 'ProbabilisticAnalysis');
    
    if isempty(bool)
        enableATLANTIS;
        updateGraphics;
        return;
    end
    
    message = 'PA FAILED';
    
    progressbar('Total Progress', 'Populating State Transition Probabilities Matrix', 'Finding Steady States. Please Wait....');
    
    try        
        
        % PERFORM PROBABILISTIC ANALYSIS
        [bool, message] = perform_ProbabilisticAnalysis(myNetwork, 0);
                
        progressbar(1, 1, 1);
        
        % TRAJECTORY MAPPING
        if myNetwork.MapTrajectory == 1
            
            booL = map_Trajectory(myNetwork);
                        
            if ~booL
                uiwait(errordlg('Could not trace trajectory between the specified start and end states. Possible reason might be that the start state has higher probability than end state.', 'Warning'));
            end
        end
        
        if bool && getappdata(0, 'SaveProbabilisticAnalysis')
            % SAVE RESULTS
                        
            bool = save_ProbabilisticAnalysisResults(myNetwork);
                        
            if ~bool
                message = 'Analysis complete. However, results could not be saved due to an error. Please check if the matlab directory is set to ATLANTIS toolbox folder and then re-try. Also, if you are using an ATLANTIS .exe, then run as administrator. If the problem persists than kindly email us at safee.ullah@gmail.com.';
                undefined/0;
            end
            
            % MESSAGE
            uiwait(msgbox(['Results saved in "', myNetwork.ResultFolderName, '"'], 'Notification'));
            
            % SAVE GUI DATA
            guidata(hObject, handles);
        elseif bool == 1
            uiwait(msgbox('Probabilistic analysis completed successfully.', 'Success'));
            % SAVE GUI DATA
            guidata(hObject, handles);
        elseif bool == 0
            undefined/0;
        end
    catch
        uiwait(errordlg(message, 'Error'));
        enableATLANTIS;
        updateGraphics;
        return;
    end
    
elseif iscell(myNetwork) % CHECK IF MULTIPLE JOBS
    
    % LET USER TO SELECT NETWORK(S) TO BE PROBABILISTICALLY ANALYZED
    fileNames = getappdata(0, 'MutationFiles');
    
    [selection, ~] = listdlg('PromptString','Select networks for analysis:',...
        'SelectionMode','multiple',...
        'ListString',fileNames);
    
    if isempty(selection)
        return;
    end
    
    % PREPARE FOR PROBABILISTIC ANALYSIS
    set(0, 'UserData', myNetwork{selection(1)});
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    uiwait(ProbabilisticAnalysisMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % CHECK IF ALL DATA FOR ANALYSIS IS PRESENT
    bool = getappdata(0, 'ProbabilisticAnalysis');
    
    if isempty(bool)
        % SAVE NETWORK
        set(0, 'UserData', myNetwork);
        enableATLANTIS;
        updateGraphics;
        return;
    end
    
    % REFERENCE NETWORK
    referenceNetwork = myNetwork{selection(1)};
    
    % ERROR LOG
    errorlog = [];
    
    totalProgress = 0;
    
    for i = 1:numel(selection)
        set(0, 'UserData', myNetwork{selection(i)});
        
        if i ~= 1
            % UPDATE ALL NETWORKS
            myNetwork{selection(i)}.OutputNodes = referenceNetwork.OutputNodes;
            myNetwork{selection(i)}.OutputNodesIndices = referenceNetwork.OutputNodesIndices;
            
            myNetwork{selection(i)}.AssociatedCellFates = referenceNetwork.AssociatedCellFates;
            myNetwork{selection(i)}.UniqueCellFates = referenceNetwork.UniqueCellFates;
            myNetwork{selection(i)}.CellFateDeterminationLogic = referenceNetwork.CellFateDeterminationLogic;
            
            myNetwork{selection(i)}.ErrorThreshold = referenceNetwork.ErrorThreshold;
            myNetwork{selection(i)}.Noise = referenceNetwork.Noise;
            myNetwork{selection(i)}.DegradationConstant = referenceNetwork.DegradationConstant;
            myNetwork{selection(i)}.TimeSteps = referenceNetwork.TimeSteps;
            myNetwork{selection(i)}.TrajectoryBounds = referenceNetwork.TrajectoryBounds;
            myNetwork{selection(i)}.MapTrajectory = referenceNetwork.MapTrajectory;
            myNetwork{selection(i)}.NetworkStateList = referenceNetwork.NetworkStateList;
            myNetwork{selection(i)}.PruneStateSpace = referenceNetwork.PruneStateSpace;
        end
        
        try
            progressbar('Total Progress', 'Populating State Transition Probabilities Matrix', 'Finding Steady States. Please Wait....');
                        
            % PERFORM DETERMINISTIC ANALYSIS
            [bool, message] = perform_ProbabilisticAnalysis(myNetwork{selection(i)}, totalProgress);
                        
            totalProgress = i/numel(selection);
            progressbar(totalProgress, 0, 0);
            
            % TRAJECTORY MAPPING
            if bool && myNetwork{selection(i)}.MapTrajectory == 1
                bool = map_Trajectory(myNetwork);

                if ~bool
                    message = [message, ' Error while mapping trajectory for ', myNetwork{selection(i)}.FileName,', '];
                end
            end
            
            if bool && getappdata(0, 'SaveProbabilisticAnalysis')
                % SAVE RESULTS                
                bool = save_ProbabilisticAnalysisResults(myNetwork{selection(i)});
                
                if ~bool
                    message = [message, 'Error while saving results for', myNetwork{selection(i)}.FileName,', '];
                end
            elseif bool == 0
                message = [message, ' for ', myNetwork{selection(i)}.FileName,', '];
                undefined/0;
            end
            
        catch
            errorlog = [errorlog, ' "', myNetwork{selection(i)}.FileName, '", ']; %#ok<*AGROW>
        end
        set(0, 'UserData', myNetwork);
    end
    
    % CHECK FOR ERROR MESSAGES
    if ~isempty(message)
        uiwait(errordlg(message, 'Error'));
    end
    
    % SAVE NETWORK
    set(0, 'UserData', myNetwork);
    
    if ~isempty(errorlog)
        % PARTIAL SUCCESS
        uiwait(errordlg(['The following jobs: ', errorlog, ' were not successful. The results of rest of the jobs saved in ', referenceNetwork.ResultFolderName, '"'], 'Error'));
    else
        if getappdata(0, 'SaveProbabilisticAnalysis')
            % COMPLETE SUCCESS
            uiwait(msgbox(['All the jobs were successfully carried out. Results saved in ', referenceNetwork.ResultFolderName, '"'], 'Success'));
        else
            uiwait(msgbox('All the jobs were successfully carried out.', 'Success'));
        end
    end
    
else
    uiwait(errordlg('Please generate a network first', 'Error'));
    enableATLANTIS;
    updateGraphics;
    return;
end

% RESET DETERMINISTIC ANALYSIS
setappdata(0, 'ProbabilisticAnalysis', []);

% ENABLE ATLANTIS FIGURE
enableATLANTIS;

% UDPATE ATLANTIS_MAIN PAGE
updateGraphics;

% SAVE GUI DATA
guidata(hObject, handles);


% --- Executes on button press in GenerateNetwork.
function VisualizeResults_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

if isobject(myNetwork)
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % PREPARE FOR PROBABILISTIC ANALYSIS
    uiwait(VisualizeResultsMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    bool = getappdata(0, 'PerformVisualization');
    
    if ~bool
        enableATLANTIS;
        return;
    end
    
    % USER CHOICES
    plotCellFateLandscape = getappdata(0, 'PlotCellFateLandscape');
    plotAttractorLandscape = getappdata(0, 'PlotAttractorLandscape');
    
    progressbar('Plotting Landscapes. Please Wait...');
    
    errormsg = '';
        
    % PLOT CELL FATE LANDSCAPE
    if plotCellFateLandscape        
        errormsg1 = generate_CellFateLandscape;
        drawnow;
        errormsg = [errormsg, errormsg1];
    end
    
    progressbar(0.5);
    
    % PLOT ATTRACTOR LANDSCAPE LANDSCAPE
    if plotAttractorLandscape        
        errormsg2 = generate_AttractorLandscape;
        drawnow;
        errormsg = [errormsg, errormsg2];
    end
    
    progressbar(1);
    
    if ~isempty(strtrim(errormsg))
        uiwait(errordlg(errormsg, 'Error'));
    end
    
%     figName = 'Legends ';
%     
%     addLegendsForAttractorPlots(figName)
    
elseif iscell(myNetwork) % CHECK IF MULTIPLE JOBS
    
    % LET USER TO SELECT NETWORK(S) TO BE PROBABILISTICALLY ANALYZED
    fileNames = getappdata(0, 'MutationFiles');
    
    [selection, ~] = listdlg('PromptString','Select networks for analysis:',...
        'SelectionMode','multiple',...
        'ListString',fileNames);
    
    if isempty(selection)
        return;
    end
    
    % PREPARE FOR PROBABILISTIC ANALYSIS
    set(0, 'UserData', myNetwork{selection(1)});
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    uiwait(VisualizeResultsMenu);
    
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    
    % CHECK IF ALL DATA FOR ANALYSIS IS PRESENT
    bool = getappdata(0, 'PerformVisualization');
    
    if ~bool
        set(0, 'UserData', myNetwork);
        enableATLANTIS;
        return;
    end
    
    % REFERENCE NETWORK
    referenceNetwork = myNetwork{selection(1)};
    
    % ERROR LOG
    errorlog = [];
    
    % USER CHOICES
    plotCellFateLandscape = getappdata(0, 'PlotCellFateLandscape');
    plotAttractorLandscape = getappdata(0, 'PlotAttractorLandscape');
    
    totalProgress = 0;
    
    for i = 1:numel(selection)
        set(0, 'UserData', myNetwork{selection(i)});
        
        progressbar('Total Progress.', 'Plotting Landscapes. Please Wait...');
        progressbar(totalProgress, 0.2);
        
        if i ~= 1
            % UPDATE ALL NETWORKS
            myNetwork{selection(i)}.CellFateLandscapePlottingOptions = referenceNetwork.CellFateLandscapePlottingOptions;
            myNetwork{selection(i)}.AttractorLandscapePlottingOptions = referenceNetwork.AttractorLandscapePlottingOptions;
        end

        
        % PLOT CELL FATE LANDSCAPE
        if plotCellFateLandscape
            generate_CellFateLandscape;
            drawnow;
        end
        
        progressbar('Total Progress.', 'Plotting Landscapes. Please Wait...');
        progressbar(totalProgress, 0.4);
        
        % PLOT ATTRACTOR LANDSCAPE LANDSCAPE
        if plotAttractorLandscape
            
            generate_AttractorLandscape;
            drawnow;            
            progressbar(totalProgress, 0.6);
        end
        
        progressbar('Total Progress.', 'Plotting Landscapes. Please Wait...');
        progressbar(totalProgress, 1);
        
        totalProgress = i/numel(selection);
        
        % SET NETWORK
        set(0, 'UserData', myNetwork);
    end
    
    % SAVE NETWORK
    set(0, 'UserData', myNetwork);
    
    if ~isempty(errorlog)
        % PARTIAL SUCCESS
        uiwait(errordlg(['The following jobs: ', errorlog, ' were not successful. The results of rest of the jobs saved in ', referenceNetwork.ResultFolderName, '"'], 'Error'));
    else
        % COMPLETE SUCCESS
        uiwait(msgbox(['All the jobs were successfully carried out. Results saved in ', referenceNetwork.ResultFolderName, '"'], 'Success'));
    end
    
else
    uiwait(errordlg('Please generate a network first', 'Error'));
    enableATLANTIS;
    return;
end

progressbar(1, 1);

% ENABLE FIGURE
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'on');

% SAVE GUI DATA
guidata(hObject, handles);


% --- Executes when user attempts to close ATLANTIS_Main.
function ATLANTIS_Main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ATLANTIS_Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

choice = questdlg('Make sure to save data before quitting. All data will be removed. Do you want to Exit?', ...
    'Exit ATLANTIS', ...
    'Yes', 'No', 'No');
% HANDLE RESPONSE
switch choice
    case 'Yes'
        % REMOVE PATHS
        allPaths = getappdata(0, 'ATLANTISpaths');
        rmpath(allPaths);
        % REMOVE APP DATA
        appdata = get(0,'ApplicationData');
        fields = fieldnames(appdata);
        for i = 1:numel(fields)
            rmappdata(0,fields{i});
        end
        % REMOVE NETWORK
        set(0, 'UserData', []);
        delete(hObject);
    otherwise
        return;
end
