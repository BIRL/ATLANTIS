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

function varargout = ExportFigureMenu(varargin)
% FIGUREEXPORTMENU MATLAB code for FigureExportMenu.fig
%      FIGUREEXPORTMENU, by itself, creates a new FIGUREEXPORTMENU or raises the existing
%      singleton*.
%
%      H = FIGUREEXPORTMENU returns the handle to a new FIGUREEXPORTMENU or the handle to
%      the existing singleton*.
%
%      FIGUREEXPORTMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGUREEXPORTMENU.M with the given input arguments.
%
%      FIGUREEXPORTMENU('Property','Value',...) creates a new FIGUREEXPORTMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExportFigureMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExportFigureMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FigureExportMenu

% Last Modified by GUIDE v2.5 18-Aug-2017 01:36:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExportFigureMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @ExportFigureMenu_OutputFcn, ...
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


% --- Executes just before FigureExportMenu is made visible.
function ExportFigureMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FigureExportMenu (see VARARGIN)

% Choose default command line output for FigureExportMenu
handles.output = hObject;

% INITIALIZE APPDATA
setappdata(0, 'ExportOptions', []);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FigureExportMenu wait for user response (see UIRESUME)
% uiwait(handles.FigureExportMenu);


% --- Outputs from this function are returned to the command line.
function varargout = ExportFigureMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function EditResolution_Callback(hObject, eventdata, handles)
% hObject    handle to EditResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditResolution as text
%        str2double(get(hObject,'String')) returns contents of EditResolution as a double
str = get(hObject, 'String');

digits = isstrprop(str,'digit');
if ~all(digits)
    set(hObject, 'String', str(digits));
end

% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% INTIALLY NOT READY TO PERFORM VISUALIZATION
setappdata(0, 'ExportOptions', []);

% FIGURE EXPORT OPTIONS
formats = get(handles.SelectFormat, 'String');
selectedFormat = get(handles.SelectFormat, 'Value');
resolution = round(abs(str2num(get(handles.EditResolution, 'String'))), 0);

% CREATE STRUCT
fields = {'selectedFormat', 'resolution'};

figExportOptions = struct(fields{1}, formats{selectedFormat},...
    fields{2}, resolution);

% SET APPDATA
setappdata(0, 'ExportOptions', figExportOptions);

% CLOSE MENU
delete(handles.FigureExportMenu);

% --- Executes when user attempts to close FigureExportMenu.
function FigureExportMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FigureExportMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
    'Exit', ...
    'Yes', 'No', 'No');
% Handle response
switch choice
    case 'Yes'
        delete(hObject);
        setappdata(0, 'ExportOptions', []);
    otherwise
        return;
end
