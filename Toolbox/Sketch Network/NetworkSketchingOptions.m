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

function varargout = NetworkSketchingOptions(varargin)
% NETWORKSKETCHINGOPTIONS MATLAB code for NetworkSketchingOptions.fig
%      NETWORKSKETCHINGOPTIONS, by itself, creates a new NETWORKSKETCHINGOPTIONS or raises the existing
%      singleton*.
%
%      H = NETWORKSKETCHINGOPTIONS returns the handle to a new NETWORKSKETCHINGOPTIONS or the handle to
%      the existing singleton*.
%
%      NETWORKSKETCHINGOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NETWORKSKETCHINGOPTIONS.M with the given input arguments.
%
%      NETWORKSKETCHINGOPTIONS('Property','Value',...) creates a new NETWORKSKETCHINGOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NetworkSketchingOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NetworkSketchingOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NetworkSketchingOptions

% Last Modified by GUIDE v2.5 28-Dec-2017 07:00:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NetworkSketchingOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @NetworkSketchingOptions_OutputFcn, ...
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


% --- Executes just before NetworkSketchingOptions is made visible.
function NetworkSketchingOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NetworkSketchingOptions (see VARARGIN)

% Choose default command line output for NetworkSketchingOptions
handles.output = hObject;

% DISABLE ATLANTIS GUI
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% RESET APPDATA
setappdata(0, 'SketchingEngine', []);

% SET POSITION TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NetworkSketchingOptions wait for user response (see UIRESUME)
% uiwait(handles.SketchNetworkMenu);


% --- Outputs from this function are returned to the command line.
function varargout = NetworkSketchingOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotUsingBiograph = get(handles.BioGraph, 'Value');

if plotUsingBiograph
    % BIOGRAPH ENGINE
    engine = 'Biograph';
else
    % GRAPHVIZ ENGINE
    engine = 'GraphViz';
end

% UPDATE APPDATA ACCORDING TO USER SELECTION
setappdata(0, 'SketchingEngine', engine);
delete(handles.SketchNetworkMenu);


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

setappdata(0, 'SketchingEngine', []);

% Handle response
switch choice
    case 'Yes'
        delete(hObject);
    otherwise
        return;
end
