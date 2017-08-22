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

function varargout = VisualizeResultsMenu(varargin)
% VisualizeResultsMenu MATLAB code for VisualizeResultsMenu.fig
%      VisualizeResultsMenu, by itself, creates a new VisualizeResultsMenu or raises the existing
%      singleton*.
%
%      H = VisualizeResultsMenu returns the handle to a new VisualizeResultsMenu or the handle to
%      the existing singleton*.
%
%      VisualizeResultsMenu('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VisualizeResultsMenu.M with the given input arguments.
%
%      VisualizeResultsMenu('Property','Value',...) creates a new VisualizeResultsMenu or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VisualizeResultsMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VisualizeResultsMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to dd VisualizeResultsMenu

% Last Modified by GUIDE v2.5 21-Aug-2017 03:48:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VisualizeResultsMenu_OpeningFcn, ...
    'gui_OutputFcn',  @VisualizeResultsMenu_OutputFcn, ...
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


% --- Executes just before VisualizeResultsMenu is made visible.
function VisualizeResultsMenu_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisualizeResultsMenu (see VARARGIN)

% Choose default command line output for VisualizeResultsMenu
handles.output = hObject;

% INTIALLY NOT READY TO PERFORM VISUALIZATION
setappdata(0, 'PlotAttractorLandscape', 0);
setappdata(0, 'PlotCellFateLandscape', 0);
setappdata(0, 'PerformVisualization', 0);

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

if ~isempty(getappdata(0, 'mappingType'))
    mappingMethod = getappdata(0, 'mappingType');
    if strcmp(mappingMethod, 'sammon')
        set(handles.SammonProjection, 'Value', 1);
        set(handles.NaiveProjection, 'Value', 0);
    else
        set(handles.SammonProjection, 'Value', 0);
        set(handles.NaiveProjection, 'Value', 1);
    end
end

% SET DEFAULT PLOT TITLE
try
    fileName = getappdata(0, 'NetworkfileName');
    set(handles.EditTreemapTitle, 'String', fileName);
    set(handles.EditAttractorLandscapeTitle, 'String', fileName );
catch
end

% MOVE GUI TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VisualizeResultsMenu wait for user response (see UIRESUME)
% uiwait(handles.VisualizeResultsMenu);


% --- Outputs from this function are returned to the command line.
function varargout = VisualizeResultsMenu_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CheckPELandscape.
function CheckPELandscape_Callback(hObject, ~, handles) %#ok<*DEFNU>
% hObject    handle to CheckPELandscape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckPELandscape

myNetwork = get(0, 'UserData');

if isempty(myNetwork.SteadyStateProbabilities)
    set(hObject, 'Value', 0);
    set(handles.SelectedNoiseReductionFactor, 'Enable', 'off');
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'off');
    uiwait(errordlg('Perform probabilistic analysis to plot this landscapes.', 'Error'));
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'on');
    try
        warning('off', 'all');
        jPeer = get(findall(0, 'tag','VisualizeResultsMenu'), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
        warning('on', 'all');
    catch
    end
    return;
end

if get(hObject, 'Value')
    status = 'on'; status1 = 'on';
else
    status1 = 'off';
    if ~(get(handles.CheckBasinValues, 'Value') || get(handles.CheckProbabilityLandscape, 'Value'))
        status = 'off';
    else
        status = 'on';
    end
end

set(handles.SammonProjection, 'Enable', status);
set(handles.NaiveProjection, 'Enable', status);
set(handles.EditAttractorLandscapeTitle, 'Enable', status);
set(handles.SelectedNoiseReductionFactor, 'Enable', status1);
set(handles.AnnotateAttractors, 'Enable', status); 
set(handles.SelectedColorSchemeAttractorLandscape, 'Enable', status); 
set(handles.ShowToolTip, 'Enable', status); 
set(handles.ExportAttractorLandscape, 'Enable', status); 
set(handles.GroupCyclicAttractors, 'Enable', status); 


% --- Executes on button press in CheckBasinValues.
function CheckBasinValues_Callback(hObject, ~, handles)
% hObject    handle to CheckBasinValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBasinValues

myNetwork = get(0, 'UserData');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

if isempty(myNetwork.AttractorTable)
    set(hObject, 'Value', 0);
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'off');
    uiwait(errordlg('Perform deterministic analysis to plot this landscape.', 'Error'));
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'on');
    try
        warning('off', 'all');
        jPeer = get(findall(0, 'tag','VisualizeResultsMenu'), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
        warning('on', 'all');
    catch
    end
    return; 
end

if get(hObject, 'Value')
    status = 'on';
else
    if ~(get(handles.CheckPELandscape, 'Value') || get(handles.CheckProbabilityLandscape, 'Value'))
        status = 'off';
    else
        status = 'on';
    end
end

set(handles.SammonProjection, 'Enable', status);
set(handles.NaiveProjection, 'Enable', status);
set(handles.EditAttractorLandscapeTitle, 'Enable', status);
set(handles.AnnotateAttractors, 'Enable', status); 
set(handles.SelectedColorSchemeAttractorLandscape, 'Enable', status); 
set(handles.ShowToolTip, 'Enable', status); 
set(handles.ExportAttractorLandscape, 'Enable', status);   
set(handles.GroupCyclicAttractors, 'Enable', status); 

% --- Executes on button press in CheckProbabilityLandscape.
function CheckProbabilityLandscape_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to CheckProbabilityLandscape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckProbabilityLandscape

myNetwork = get(0, 'UserData');

if isempty(myNetwork.SteadyStateProbabilities)
    set(hObject, 'Value', 0);
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'off');
    uiwait(errordlg('Perform probabilistic analysis to plot this landscapes.', 'Error'));
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'on');
    try
        warning('off', 'all');
        jPeer = get(findall(0, 'tag','VisualizeResultsMenu'), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
        warning('on', 'all');
    catch
    end
    return;
end

if get(hObject, 'Value')
    status = 'on';
else
    if ~(get(handles.CheckBasinValues, 'Value') || get(handles.CheckPELandscape, 'Value'))
        status = 'off';
    else
        status = 'on';
    end
end

set(handles.SammonProjection, 'Enable', status);
set(handles.NaiveProjection, 'Enable', status);
set(handles.EditAttractorLandscapeTitle, 'Enable', status);
set(handles.AnnotateAttractors, 'Enable', status); 
set(handles.SelectedColorSchemeAttractorLandscape, 'Enable', status); 
set(handles.ShowToolTip, 'Enable', status); 
set(handles.ExportAttractorLandscape, 'Enable', status); 
set(handles.GroupCyclicAttractors, 'Enable', status); 

% --- Executes on button press in CheckTreeMap.
function CheckTreeMap_Callback(hObject, eventdata, handles)
% hObject    handle to CheckTreeMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckTreeMap

myNetwork = get(0, 'UserData');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

if isempty(myNetwork.CellFateLandscape)
    set(hObject, 'Value', 0);
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'off');
    uiwait(errordlg('Perform deterministic analysis and associate cell fates with attractors to plot this landscape.', 'Error'));
    enableDisableFig(findall(0, 'tag','VisualizeResultsMenu'), 'on');
    try
        warning('off', 'all');
        jPeer = get(findall(0, 'tag','VisualizeResultsMenu'), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
        warning('on', 'all');
    catch
    end
    return; 
end

if get(hObject, 'Value')
    status = 'on';
else
    status = 'off';
end

set(handles.EditTreemapTitle, 'Enable', status);
set(handles.SelectedColorSchemeTreeMap, 'Enable', status);
set(handles.AnnotateBoxes, 'Enable', status);
set(handles.ExportTreeMap, 'Enable', status);


% --- Executes on button press in ExportAttractorLandscape.
function ExportAttractorLandscape_Callback(hObject, eventdata, handles)
% hObject    handle to ExportAttractorLandscape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExportAttractorLandscape

if get(hObject, 'Value')
    status = 'on';
else
    status = 'off';
end

set(handles.EditResolutionAttractorLandscape, 'Enable', status);
set(handles.EditFormatAttractorLandscape, 'Enable', status);


% --- Executes on button press in ExportTreeMap.
function ExportTreeMap_Callback(hObject, eventdata, handles)
% hObject    handle to ExportTreeMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExportTreeMap

if get(hObject, 'Value')
    status = 'on';
else
    status = 'off';
end

set(handles.EditResolutionTreemap, 'Enable', status);
set(handles.EditFormatTreeMap, 'Enable', status);


function EditResolutionTreemap_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to EditResolutionTreemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditResolutionTreemap as text
%        str2double(get(hObject,'String')) returns contents of EditResolutionTreemap as a double
str = get(hObject, 'String');

digits = isstrprop(str,'digit');

if ~all(digits)
    set(hObject, 'String', str(digits));
end


% --- Executes on button press in SammonProjection.
function SammonProjection_Callback(hObject, eventdata, handles)
% hObject    handle to SammonProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SammonProjection

% GET NETWORK
myNetwork = get(0, 'UserData');

% CHECK STATE SPACE
if 2^(myNetwork.NodeCount) < 2^7
    uiwait(errordlg('Sammon mapping does not work well for state space smaller than 2^7', ''));
    set(hObject, 'Value', 0);
    set(handles.NaiveProjection, 'Value', 1);
else
    % CHECK IF THE STATE SPACE IS APPORPIATE
    len = size(myNetwork.NetworkStateList, 1);
    if (len ~= 2^7 && len ~= 2^8 && len ~= 2^9 && len ~= 2^10 && len ~= 2^11 && len ~= 2^12) || len > 2^12
        
        len1 = size(myNetwork.ModifiedStateSpace, 1);
        
        if (len1 ~= 2^7 && len1 ~= 2^8 && len1 ~= 2^9 && len1 ~= 2^10 && len1 ~= 2^11 && len1 ~= 2^12) || len1 > 2^12
        
            % WARN USER ABOUT THE STATE SPACE ISSUE
            uiwait(errordlg('Sammon mapping requires the state space to be 2^x, where x can be from 7-12. Current state space is not suitable to be projected to 2-Dimensions using sammon mapping. Size of state space needs to be modified. ', 'Warning'));

            % ASK USER FOR USER OPINION
            uiwait(StateSpaceSizeSelectionMenu);
            userChoice = getappdata(0, 'StateSpaceOption');

            % SELECT APPROPIATE ACTION
            if userChoice == 0 % CANCEL
                set(hObject, 'Value', 0);
                set(handles.NaiveProjection, 'Value', 1);
                return;
            % STATE SPACE MODIFICATION
            elseif userChoice == 1 % OPTIMAL
                possibleSizes = [2^7, 2^8, 2^9, 2^10, 2^11, 2^12];
                [~, mostSimilar] = min(abs(possibleSizes - size(len, 1)));
                newStateSpace = generate_StateCombinations_randomSampling(myNetwork, possibleSizes(mostSimilar));
            else % USER SELECTED
                newStateSpace = generate_StateCombinations_randomSampling(myNetwork, str2num(userChoice));
            end

            myNetwork.ModifiedStateSpace = newStateSpace;
        end
    end
end


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% INTIALLY NOT READY TO PERFORM VISUALIZATION
setappdata(0, 'PlotAttractorLandscape', 0);
setappdata(0, 'PlotCellFateLandscape', 0);
setappdata(0, 'PerformVisualization', 0);

% DRAW CELL FATE LANDSCAPE?
plotCellFateLandscape = get(handles.CheckTreeMap, 'Value');
if plotCellFateLandscape
    % CHECK USER INPUTS
    plotTitle = get(handles.EditTreemapTitle, 'String');
    showToolTip = 1;
    annotateBoxes = get(handles.AnnotateBoxes, 'Value');
    saveFigure = get(handles.ExportTreeMap, 'Value');
    colorSchemes = get(handles.SelectedColorSchemeTreeMap, 'String');
    selectedColorScheme = get(handles.SelectedColorSchemeTreeMap, 'Value'); 

    % PICTURE SAVING OPTIONS
    formats = get(handles.EditFormatTreeMap, 'String');
    selectedFormat = get(handles.EditFormatTreeMap, 'Value');
    resolution = round(abs(str2num(get(handles.EditResolutionTreemap, 'String'))), 0); %#ok<*ST2NM>
    
    % CREATE STRUCT
    fields = {'selectedColorScheme','selectedFormat', 'plotTitle', 'showLegends', 'annotateBoxes'...
        , 'saveFigure', 'resolution'};

    treemapPlottingOptions = struct(fields{1}, colorSchemes{selectedColorScheme},...
        fields{2}, formats{selectedFormat}, fields{3}, plotTitle, fields{4},...
        showToolTip, fields{5}, annotateBoxes, fields{6}, saveFigure, ...
        fields{7}, resolution);

    % SAVE PLOTTING OPTIONS
    myNetwork.CellFateLandscapePlottingOptions = treemapPlottingOptions;

    % UPDATE APP DATA
    setappdata(0, 'PlotCellFateLandscape', 1);
end

% DRAW ATTRACTOR LANDSCAPE?
plotPELandscape = get(handles.CheckPELandscape, 'Value');
plotBSFateLandscape = get(handles.CheckBasinValues, 'Value');
plotPL = get(handles.CheckProbabilityLandscape, 'Value');
if plotPELandscape || plotBSFateLandscape || plotPL
    
    % PLOT TYPES
    if plotPELandscape && plotBSFateLandscape && plotPL
        plotTypes = 'All';
    elseif plotPELandscape && plotBSFateLandscape
        plotTypes = 'PE & BS';
    elseif plotPELandscape && plotPL
        plotTypes = 'PE & P';
    elseif plotBSFateLandscape && plotPL
        plotTypes = 'BS & P';
    elseif plotPELandscape
        plotTypes = 'PE';
    elseif plotBSFateLandscape
        plotTypes = 'BS';
    elseif plotPL
        plotTypes = 'P';
    end
    
    % MAPPING METHOD
    if get(handles.SammonProjection, 'Value')
        mappingMethod = 'sammon';
    else
        mappingMethod = 'naive';
    end
    
    if isempty(getappdata(0, 'mappingType'))
        setappdata(0, 'mappingType', mappingMethod);
    elseif ~(strcmp(mappingMethod, getappdata(0, 'mappingType')))
        setappdata(0, 'mappingType', mappingMethod);
        myNetwork.MappingResults = [];
    end

    % CHECK USER INPUTS
    plotTitle = get(handles.EditAttractorLandscapeTitle, 'String');
    annotateAttractors = get(handles.AnnotateAttractors, 'Value');
    showToolTip = get(handles.ShowToolTip, 'Value');
    saveFigure = get(handles.ExportAttractorLandscape, 'Value');
    colorSchemes = get(handles.SelectedColorSchemeAttractorLandscape, 'String');
    selectedColorScheme = get(handles.SelectedColorSchemeAttractorLandscape, 'Value');
    noiseReductionFactor = get(handles.SelectedNoiseReductionFactor, 'String');
    selectedFactor = str2num(noiseReductionFactor{get(handles.SelectedNoiseReductionFactor, 'Value')});
    factors = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21];
    groupCyclicAttractors = get(handles.GroupCyclicAttractors, 'Value');
    
    % PICTURE SAVING OPTIONS
    formats = get(handles.EditFormatAttractorLandscape, 'String');
    selectedFormat = get(handles.EditFormatAttractorLandscape, 'Value');
    resolution = round(abs(str2num(get(handles.EditResolutionAttractorLandscape, 'String'))), 0);
    
    % CREATE STRUCT
    fields = {'selectedColorScheme','selectedFormat', 'plotTitle', 'showToolTip', ...
        'AnnotateAttractors', 'saveFigure', 'noiseReductionFactor', ...
        'resolution', 'mappingMethod', 'plotTypes', 'groupCyclicAttractors'};

    attrLandscapePlottingOptions = struct(fields{1}, colorSchemes{selectedColorScheme},...
        fields{2}, formats{selectedFormat}, fields{3}, plotTitle, fields{4},...
        showToolTip, fields{5}, annotateAttractors, fields{6}, saveFigure, fields{7},...
        factors(selectedFactor), fields{8}, resolution, fields{9}, mappingMethod,...
        fields{10}, plotTypes, fields{11}, groupCyclicAttractors);

    % SAVE PLOTTING OPTIONS
    myNetwork.AttractorLandscapePlottingOptions = attrLandscapePlottingOptions;
    setappdata(0, 'PlotAttractorLandscape', 1);
end

plot1 = getappdata(0, 'PlotAttractorLandscape');
plot2 = getappdata(0, 'PlotCellFateLandscape');

if plot1 || plot2
    setappdata(0, 'PerformVisualization', 1);
    % CLOSE MENU
    delete(handles.VisualizeResultsMenu);
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
else
    uiwait(errordlg('There is nothing to plot. No option selected.', 'Warning'));
    return;
end


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Open ATLANTIS GitHub Page?', ...
    'Help', ...
    'Yes', 'No', 'No');
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
% Handle response
switch choice
    case 'Yes'
        url = 'https://github.com/BIRL/ATLANTIS';
        web(url,'-browser');
    otherwise
        return;
end


% --- Executes when user attempts to close VisualizeResultsMenu.
function VisualizeResultsMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to VisualizeResultsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
    'Exit', ...
    'Yes', 'No', 'No');
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
% Handle response
switch choice
    case 'Yes'
        setappdata(0, 'PlotAttractorLandscape', 0);
        setappdata(0, 'PlotCellFateLandscape', 0);
        setappdata(0, 'PerformVisualization', 0);
        delete(hObject);
    otherwise
        return;
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
