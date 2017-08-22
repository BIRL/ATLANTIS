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

function varargout = StateSpaceSizeSelectionMenu(varargin)
% STATESPACESIZESELECTIONMENU MATLAB code for StateSpaceSizeSelectionMenu.fig
%      STATESPACESIZESELECTIONMENU, by itself, creates a new STATESPACESIZESELECTIONMENU or raises the existing
%      singleton*.
%
%      H = STATESPACESIZESELECTIONMENU returns the handle to a new STATESPACESIZESELECTIONMENU or the handle to
%      the existing singleton*.
%
%      STATESPACESIZESELECTIONMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATESPACESIZESELECTIONMENU.M with the given input arguments.
%
%      STATESPACESIZESELECTIONMENU('Property','Value',...) creates a new STATESPACESIZESELECTIONMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StateSpaceSizeSelectionMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StateSpaceSizeSelectionMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StateSpaceSizeSelectionMenu

% Last Modified by GUIDE v2.5 18-Jul-2017 18:55:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StateSpaceSizeSelectionMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @StateSpaceSizeSelectionMenu_OutputFcn, ...
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


% --- Executes just before StateSpaceSizeSelectionMenu is made visible.
function StateSpaceSizeSelectionMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StateSpaceSizeSelectionMenu (see VARARGIN)

% Choose default command line output for StateSpaceSizeSelectionMenu
handles.output = hObject;

% RESET APP DATA
setappdata(0, 'StateSpaceOption', 0); % 1 for optimal, 0 for cancel visualization

% DISABLE VISUALIZE RESULTS MENU
enableDisableFig(findall(0, 'tag', 'VisualizeResults'), 'off');

% MOVE GUI TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StateSpaceSizeSelectionMenu wait for user response (see UIRESUME)
% uiwait(handles.StateSpaceSizeSelectionMenu);


% --- Outputs from this function are returned to the command line.
function varargout = StateSpaceSizeSelectionMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in StateSpaceSelection.
function StateSpaceSelection_Callback(hObject, eventdata, handles)
% hObject    handle to StateSpaceSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StateSpaceSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StateSpaceSelection

% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OptimalSize.
function OptimalSize_Callback(hObject, eventdata, handles)
% hObject    handle to OptimalSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OptimalSize

set(handles.StateSpaceSelection, 'Enable', 'off');


% --- Executes on button press in CustomSize.
function CustomSize_Callback(hObject, eventdata, handles)
% hObject    handle to CustomSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CustomSize

set(handles.StateSpaceSelection, 'Enable', 'on');

% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECK FOR USER SELECTION

optimal = get(handles.OptimalSize, 'Value');

setappdata(0, 'StateSpaceOption', 0); 

if optimal
    setappdata(0, 'StateSpaceOption', 1); 
else
    % GET THE SELECTED STATE SPACE
    allStateOptions = get(handles.StateSpaceSelection, 'String');
    selection = get(handles.StateSpaceSelection, 'Value');
    setappdata(0, 'StateSpaceOption', allStateOptions{selection}); 
end

% CLOSE MENU
delete(handles.StateSpaceSizeSelectionMenu);

try
    enableDisableFig(findall(0, 'tag', 'VisualizeResults'), 'on');
    warning('off', 'all');
    jPeer = get(findall(0, 'tag', 'VisualizeResults'), 'JavaFrame');
    jPeer.getAxisComponent.requestFocus;
    warning('on', 'all');
catch
end

% --- Executes when user attempts to close StateSpaceSizeSelectionMenu.
function StateSpaceSizeSelectionMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to StateSpaceSizeSelectionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Are you sure? Exiting this menu would end the visualization process.', ...
    'Exit', ...
    'Yes', 'No', 'No');
% Handle response
switch choice
    case 'Yes'
        uiwait(errordlg('Visualization process was cancelled by the user. Stopping visualization process.', 'Warning'));
        delete(hObject);
        try
            enableDisableFig(findall(0, 'tag', 'VisualizeResults'), 'on');
            warning('off', 'all');
            jPeer = get(findall(0, 'tag', 'VisualizeResults'), 'JavaFrame');
            jPeer.getAxisComponent.requestFocus;
            warning('on', 'all');
        catch
        end
    case 'No'
        return;
end
