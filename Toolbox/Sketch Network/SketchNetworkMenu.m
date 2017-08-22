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

function varargout = SketchNetworkMenu(varargin)
% SketchNetworkMenu MATLAB code for SketchNetworkMenu.fig
%      SketchNetworkMenu, by itself, creates a new SketchNetworkMenu or raises the existing
%      singleton*.
%
%      H = SketchNetworkMenu returns the handle to a new SketchNetworkMenu or the handle to
%      the existing singleton*.
%
%      SketchNetworkMenu('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SketchNetworkMenu.M with the given input arguments.
%
%      SketchNetworkMenu('Property','Value',...) creates a new SketchNetworkMenu or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SketchNetworkMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SketchNetworkMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SketchNetworkMenu

% Last Modified by GUIDE v2.5 10-Aug-2017 00:40:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SketchNetworkMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @SketchNetworkMenu_OutputFcn, ...
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

% --- Executes just before SketchNetworkMenu is made visible.
function SketchNetworkMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SketchNetworkMenu (see VARARGIN)

% GET NETWORK
myNetwork = get(0, 'UserData');

% Choose default command line output for SketchNetworkMenu
handles.output = hObject;

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% RESET APPDATA
setappdata(0, 'SketchingOptions', []);

% SET DEFAULT PLOT TITLE
try
    fileName = getappdata(0, 'NetworkfileName');
    if ~isempty(myNetwork.FileName)
        set(handles.PlotTitle, 'String', [fileName , ' - ', strrep(myNetwork.FileName, ' - ', '')]);
    else
        set(handles.PlotTitle, 'String', fileName);
    end
catch
end

% SET POSITION TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes SketchNetworkMenu wait for user response (see UIRESUME)
% uiwait(handles.SketchNetworkMenu);


% --- Outputs from this function are returned to the command line.
function varargout = SketchNetworkMenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CustomDotFile.
function CustomDotFile_Callback(hObject, eventdata, handles)
% hObject    handle to CustomDotFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% CHECKING FOR PREVIOUS INPUT
dotFile = get(hObject, 'UserData');

if ~isempty(dotFile)
    choice = questdlg(['You already selected "', dotFile{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            set(hObject, 'UserData', []);
        otherwise
            return;
    end
end

% GET NETWORK TEXT OR CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.dot', 'Dot File'},...
                             'Select a dot file containing information on network sketching');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    set(hObject, 'Value', 0);
    set(handles.MatlabGeneratedDotFile, 'Value', 1);
    return;
end

% SAVE DATA IN BROWSE NETWORK HANDLE
set(hObject, 'UserData', {pathname, filename});

% SAVE DOT FILE NAME
myNetwork.DotFileInfo = {filename, pathname};
        
% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);


% --- Executes on button press in Draw.
function Draw_Callback(hObject, eventdata, handles)
% hObject    handle to Draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% RESET APPDATA
setappdata(0, 'SketchingOptions', []);

% CHECK IF MATLAB GENERATED DOT FILE OPTION WAS SELECTED
if get(handles.MatlabGeneratedDotFile, 'Value')
    
    % GENERATE DOT FILE
    bool = generateDotFile(myNetwork);
    
    if ~bool
        errordlg('Failed to generate the dot file', 'Failure');
        return;
    end
end

dotFile = myNetwork.DotFileInfo;

if ~isempty(dotFile)
    
    ShowLabels = get(handles.EdgeLabels, 'Value');
    FigureBackgrounds = get(handles.SelectedBGColor, 'String');
    selectedBG = FigureBackgrounds(get(handles.SelectedBGColor, 'Value'));
    Engines = get(handles.SelectedPlotType, 'String');
    selectedEngine = Engines(get(handles.SelectedPlotType, 'Value'));
    plotTitle = get(handles.PlotTitle, 'String');
    
    % CREATE STRUCT
    fields = {'ShowLabels', 'FigureBackground', 'Engine', 'PlotTitle'};

    sketchingOptions = struct(fields{1}, ShowLabels,...
        fields{2}, selectedBG, fields{3}, selectedEngine...
        , fields{4}, plotTitle);
    
    % SET APPDATA
    setappdata(0, 'SketchingOptions', sketchingOptions);
    
    % CLOSE MENU
    delete(handles.SketchNetworkMenu);
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


% --- Executes when user attempts to close SketchNetworkMenu.
function SketchNetworkMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SketchNetworkMenu (see GCBO)
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
        delete(hObject);
    otherwise
        return;
end
