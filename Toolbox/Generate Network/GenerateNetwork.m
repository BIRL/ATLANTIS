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

function varargout = GenerateNetwork(varargin)
% GenerateNetwork MATLAB code for GenerateNetwork.fig
%      GenerateNetwork, by itself, creates a new GenerateNetwork or raises the existing
%      singleton*.
%
%      H = GenerateNetwork returns the handle to a new GenerateNetwork or the handle to
%      the existing singleton*.
%
%      GenerateNetwork('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GenerateNetwork.M with the given input arguments.
%
%      GenerateNetwork('Property','Value',...) creates a new GenerateNetwork or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GenerateNetwork_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GenerateNetwork_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GenerateNetwork

% Last Modified by GUIDE v2.5 14-Jun-2017 23:09:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GenerateNetwork_OpeningFcn, ...
    'gui_OutputFcn',  @GenerateNetwork_OutputFcn, ...
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


% --- Executes just before GenerateNetwork is made visible.
function GenerateNetwork_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GenerateNetwork (see VARARGIN)

% Choose default command line output for GenerateNetwork
handles.output = hObject;

% DISABLE ATLANTIS
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% SET POSITION TO CENTER
movegui(hObject, 'center');

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);

% UIWAIT makes GenerateNetwork wait for user response (see UIRESUME)
% uiwait(handles.GenerateNetwork);


% --- Outputs from this function are returned to the command line.
function varargout = GenerateNetwork_OutputFcn(hObject, eventdata, handles)
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

GenerationMethod = get(handles.NetworkType1, 'Value');

if GenerationMethod == 1
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Method 1 selected.');
    % CALL NETWOKR MENU
    NetworkInputMenu1;
    % CLOSE GENERATE NETWORK MENU AFTER A PAUSE
    pause(0.4);
    delete(handles.GenerateNetworkMenu);
elseif GenerationMethod == 0
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Method 2 selected.');
    % CALL NETWOKR MENU
    NetworkInputMenu2;
    % CLOSE GENERATE NETWORK MENU AFTER A PAUSE
    pause(0.4);
    delete(handles.GenerateNetworkMenu);
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



% --- Executes when user attempts to close GenerateNetworkMenu.
function GenerateNetworkMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to GenerateNetworkMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
                         'Exit', ...
                         'Yes', 'No', 'No');              

% Handle response
switch choice
    case 'Yes'
        enableATLANTIS;
        delete(hObject);
    otherwise
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
end
