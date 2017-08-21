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

function varargout = GenerateStates(varargin)
% GenerateStates MATLAB code for GenerateStates.fig
%      GenerateStates, by itself, creates a new GenerateStates or raises the existing
%      singleton*.
%
%      H = GenerateStates returns the handle to a new GenerateStates or the handle to
%      the existing singleton*.
%
%      GenerateStates('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GenerateStates.M with the given input arguments.
%
%      GenerateStates('Property','Value',...) creates a new GenerateStates or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GenerateStates_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GenerateStates_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GenerateStates

% Last Modified by GUIDE v2.5 27-Jun-2017 05:13:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GenerateStates_OpeningFcn, ...
                   'gui_OutputFcn',  @GenerateStates_OutputFcn, ...
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


% --- Executes just before GenerateStates is made visible.
function GenerateStates_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GenerateStates (see VARARGIN)

% Choose default command line output for GenerateStates
handles.output = hObject;

tags = {'ATLANTIS_Main', 'DeterministicAnalysisMenu', 'ProbabilisticAnalysisMenu'};

for i = 1:numel(tags)
    try
        enableDisableFig(findall(0, 'tag', tags{i}), 'off');
    catch 
    end
end

% SET POSITION TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GenerateStates wait for user response (see UIRESUME)
% uiwait(handles.GenerateStates);


% --- Outputs from this function are returned to the command line.
function varargout = GenerateStates_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AllCombinations.
function AllCombinations_Callback(hObject, eventdata, handles)
% hObject    handle to AllCombinations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AllCombinations

% SET EditSampleSize TO OFF
set(handles.EditSampleSize, 'Enable', 'off');


% --- Executes on button press in RandomSample.
function RandomSample_Callback(hObject, eventdata, handles)
% hObject    handle to RandomSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomSample

% SET EditSampleSize TO ON
set(handles.EditSampleSize, 'Enable', 'on');


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% SELECTION
generateAll = get(handles.AllCombinations, 'Value');

if generateAll
    % CHECK IF ENOUGH MEMORY
    [bool, memReq, memAvail] = isMemorySufficient(2^myNetwork.NodeCount * myNetwork.NodeCount);
    
    if bool
        % GENERATE STATE COMBINATIONS
        generate_StatesCombinations(myNetwork);
        % SAVE NETWORK OBJECT IN ROOT
        set(0, 'UserData', myNetwork);
        % MSG BOX
        uiwait(msgbox('All possible state combinations created.'));
        % UPDATE GUIDATA
        guidata(hObject, handles);
        % CLOSE MENU
        delete(GenerateStates);
    else
        errormessage = ['Memory required: ', num2str(memReq/10e6), ' mb. Memory available: ', num2str(memAvail/10e6), ' mb. Consider generating specific number of states instead.'];
        uiwait(errordlg(errormessage, 'Insufficient memory')); 
    end
else
    % CHECK IF ANY VALUE ENTERED IN editSampleSize BOX
    sampleSize = str2num(get(handles.EditSampleSize, 'String'));
    if isempty(sampleSize) || size(sampleSize, 1) > 1 || size(sampleSize, 2) > 1
        uiwait(errordlg('Invalid input. Please enter only numeric characters', 'Invalid input'));
        return;
    end
    
    if sampleSize <= 0
        uiwait(errordlg('Invalid input. Sample size cannot be less than or equal to 0.', 'Invalid input'));
        return;
    end
    
    % Give error if the sample size input > total possible states
    if sampleSize > 2^myNetwork.NodeCount
        errormessage = ['Sample size entered is larger than total number of states. Enter a number smaller than total number of states', ' ( i.e. ', num2str(2^myNetwork.NodeCount) ,' )'];
        uiwait(errordlg(errormessage, 'Invalid input'));
        return;
    end
    
    % UPDATE SAMPLE SIZE
    set(handles.EditSampleSize, 'String', sampleSize);
    
    % CHECK IF ENOUGH MEMORY
    [bool, memReq, memAvail] = isMemorySufficient(sampleSize * myNetwork.NodeCount);
    
    if bool
        % GENERATE STATE COMBINATIONS
        networkStateList = generate_StateCombinations_randomSampling(myNetwork, sampleSize);
        myNetwork.NetworkStateList = networkStateList;
        
        % SAVE NETWORK OBJECT IN ROOT
        set(0, 'UserData', myNetwork);
        % MSG BOX
        uiwait(msgbox('Specified state combinations created.'));
        % UPDATE GUIDATA
        guidata(hObject, handles);
        % CLOSE MENU
        delete(GenerateStates);
    else
        errormessage = ['Memory required: ', num2str(memReq/10e6), ' mb. Memory available: ', num2str(memAvail/10e6), ' mb. Consider generating specific number of states instead.'];
        uiwait(errordlg(errormessage, 'Insufficient memory')); 
    end
end

% REMOVE MAPPING RESULTS
myNetwork.MappingResults = [];
myNetwork.RandomIndicies = [];

tags = {'DeterministicAnalysisMenu', 'ProbabilisticAnalysisMenu'};

for i = 1:numel(tags)
    try
        enableDisableFig(findall(0, 'tag', tags{i}), 'on');
        warning('off', 'all');
        jPeer = get(findall(0, 'tag', tags{i}), 'JavaFrame');
        jPeer.getAxisComponent.requestFocus;
        warning('on', 'all');
    catch 
    end
end

% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close GenerateStates.
function GenerateStates_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to GenerateStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
                         'Exit', ...
                         'Yes', 'No', 'No');
tags = {'ATLANTIS_Main', 'DeterministicAnalysisMenu', 'ProbabilisticAnalysisMenu'};

for i = 1:numel(tags)
    try
        enableDisableFig(findall(0, 'tag', tags{i}), 'off');
    catch 
    end
end
% Handle response
switch choice
    case 'Yes'
        delete(hObject);
        tags = {'DeterministicAnalysisMenu', 'ProbabilisticAnalysisMenu'};

        for i = 1:numel(tags)
            try
                enableDisableFig(findall(0, 'tag', tags{i}), 'on');
                warning('off', 'all');
                jPeer = get(findall(0, 'tag', tags{i}), 'JavaFrame');
                jPeer.getAxisComponent.requestFocus;
                warning('on', 'all');
            catch 
            end
        end
    otherwise
        return;
end
