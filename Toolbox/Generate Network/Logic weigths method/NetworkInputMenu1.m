%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ATLANTIS: Attractor Landscape Analysis Toolbox for        %
%              Cell Fate Discovery and Reprogramming               %
%                           Version 1.0.0                          %
%     Copyright (c) Biomedical Informatics Research Laboratory,    %
%      Lahore University of Management Sciences Lahore (LUMS),     %
%                            Pakistan.                             %
%                 http://biolabs.lums.edu.pk/birl)                 %
%                     (safee.ullah@gmail.com)                      %
%                  Last Modified on: 09-August-2017                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = NetworkInputMenu1(varargin)
% NetworkInputMenu1 MATLAB code for NetworkInputMenu1.fig
%      NetworkInputMenu1, by itself, creates a new NetworkInputMenu1 or raises the existing
%      singleton*.
%
%      H = NetworkInputMenu1 returns the handle to a new NetworkInputMenu1 or the handle to
%      the existing singleton*.
%
%      NetworkInputMenu1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NetworkInputMenu1.M with the given input arguments.
%
%      NetworkInputMenu1('Property','Value',...) creates a new NetworkInputMenu1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NetworkInputMenu1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NetworkInputMenu1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NetworkInputMenu1

% Last Modified by GUIDE v2.5 19-Jun-2017 21:09:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @NetworkInputMenu1_OpeningFcn, ...
    'gui_OutputFcn',  @NetworkInputMenu1_OutputFcn, ...
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


% --- Executes just before NetworkInputMenu1 is made visible.
function NetworkInputMenu1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NetworkInputMenu1 (see VARARGIN)

% Choose default command line output for NetworkInputMenu1
handles.output = hObject;

% Add Images to Open File Button
path = 'Supplementary Functions\Images\';
OpenFileImage = imread([path, 'OpenFile.jpg']);
OpenFileImageResize = imresize(OpenFileImage, [20 20]);
set(handles.BrowseNetworkFile, 'CData', OpenFileImageResize);

% SET POSITION TO CENTER
movegui(hObject, 'center');

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);

% UIWAIT makes NetworkInputMenu1 wait for user response (see UIRESUME)
% uiwait(handles.NetworkInputMenu1);


% --- Outputs from this function are returned to the command line.
function varargout = NetworkInputMenu1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseNetworkFile.
function BrowseNetworkFile_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseNetworkFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
networkFile = get(hObject, 'UserData');

if ~isempty(networkFile)
    choice = questdlg(['You already selected "', networkFile{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            set(hObject, 'UserData', []);
            set(0, 'UserData', []);
        otherwise
            return;
    end
end

% GET NETWORK TEXT OR CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.txt', 'Plain text'; '*.csv',...
                            'Comma seperated values file'},...
                             'Select file containing network information');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    return;
end

% CREATING NETWORK OBJECT
myNetwork = NetworkDataStructure();
myNetwork.NetworkType = 'WeightsBased';

try
    % PARSING NETWORK FILE
    bool = parse_NetworkFile(myNetwork, filename, pathname);
    
    if bool
        % REPLACE BROWSE FILE WITH FILE NAME
        set(handles.BrowseFile, 'String', filename, 'ForegroundColor', [1 0.3 0.5]);
        
        % UPDATE CONSOLE
        set(handles.Console, 'String', 'Valid file selected. Press ok to continue');
        
        % SAVE DATA IN BROWSE NETWORK HANDLE
        set(hObject, 'UserData', {pathname, filename});
        
        % SAVE NETWORK OBJECT IN ROOT
        set(0, 'UserData', myNetwork);
        
        % OUTPUT FOLDER NAME
        myNetwork.ResultFolderName = generate_OutputFolderName(filename);
        
        % MSG BOX
        uiwait(msgbox('Network successfully generated. Please proceed with network modification, sketching or analysis.'));
       
        % UPDATE GUIDATA
        guidata(hObject, handles);
    else 
        undefined;
    end
    
catch
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String','Invalid file selected. Enter a valid file. To see network file format details press help.');
    % ERROR MESSAGE
    uiwait(errordlg('Please input a valid network file. Press help for more information.', 'Invalid Input'));
end

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET MYNETWORK
myNetwork = get(0, 'UserData');

if isobject(myNetwork)
    % DELETE THE NETWORK MENU
    delete(NetworkInputMenu1);
    
    % ENABLE FIGURE
    enableATLANTIS;
    
    % UPDATE THE ATLANTIS BUTTONS
    updateGraphics;
else
    uiwait(errordlg('Please select a network file or press help for more information.', 'Invalid Input'));
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
                

% --- Executes when user attempts to close NetworkInputMenu1.
function NetworkInputMenu1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to NetworkInputMenu1 (see GCBO)
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
