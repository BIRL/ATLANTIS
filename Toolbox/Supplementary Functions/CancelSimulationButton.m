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

function varargout = CancelSimulationButton(varargin)
% CANCELSIMULATIONBUTTON MATLAB code for CancelSimulationButton.fig
%      CANCELSIMULATIONBUTTON, by itself, creates a new CANCELSIMULATIONBUTTON or raises the existing
%      singleton*.
%
%      H = CANCELSIMULATIONBUTTON returns the handle to a new CANCELSIMULATIONBUTTON or the handle to
%      the existing singleton*.
%
%      CANCELSIMULATIONBUTTON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANCELSIMULATIONBUTTON.M with the given input arguments.
%
%      CANCELSIMULATIONBUTTON('Property','Value',...) creates a new CANCELSIMULATIONBUTTON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CancelSimulationButton_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CancelSimulationButton_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CancelSimulationButton

% Last Modified by GUIDE v2.5 31-Dec-2017 17:28:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CancelSimulationButton_OpeningFcn, ...
                   'gui_OutputFcn',  @CancelSimulationButton_OutputFcn, ...
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


% --- Executes just before CancelSimulationButton is made visible.
function CancelSimulationButton_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CancelSimulationButton (see VARARGIN)

% Choose default command line output for CancelSimulationButton
handles.output = hObject;

setappdata(0, 'CancelSimulation', []);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CancelSimulationButton wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CancelSimulationButton_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0, 'CancelSimulation', 1);
set(hObject, 'String', 'Cancelling...');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
end
