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

function varargout = pauseButton(varargin)
% CANCELBUTTON MATLAB code for cancelbutton.fig
%      CANCELBUTTON, by itself, creates a new CANCELBUTTON or raises the existing
%      singleton*.
%
%      H = CANCELBUTTON returns the handle to a new CANCELBUTTON or the handle to
%      the existing singleton*.
%
%      CANCELBUTTON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANCELBUTTON.M with the given input arguments.
%
%      CANCELBUTTON('Property','Value',...) creates a new CANCELBUTTON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pauseButton_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pauseButton_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cancelbutton

% Last Modified by GUIDE v2.5 31-Dec-2017 17:04:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pauseButton_OpeningFcn, ...
                   'gui_OutputFcn',  @pauseButton_OutputFcn, ...
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


% --- Executes just before cancelbutton is made visible.
function pauseButton_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cancelbutton (see VARARGIN)

% Choose default command line output for cancelbutton
handles.output = hObject;

% setappdata(0, 'CancelSimulation', []);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cancelbutton wait for user response (see UIRESUME)
% uiwait(handles.CancelButton);


% --- Outputs from this function are returned to the command line.
function varargout = pauseButton_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button.
function button_Callback(hObject, eventdata, handles)
% hObject    handle to button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% setappdata(0, 'CancelSimulation', 1);
% delete(hObject);

% --- Executes when user attempts to close CancelButton.
function CancelButton_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Hint: delete(hObject) closes the figure
choice = questdlg('Cancel Simulation?', ...
                         'Exit', ...
                         'Yes', 'No', 'No');
% Handle response
switch choice
    case 'Yes'
        setappdata(0, 'CancelSimulation', 1);
        delete(hObject);
    otherwise
        setappdata(0, 'CancelSimulation', []);
        return;
end
