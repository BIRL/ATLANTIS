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

function varargout = NetworkInputMenu2(varargin)
% NetworkInputMenu2 MATLAB code for NetworkInputMenu2.fig
%      NetworkInputMenu2, by itself, creates a new NetworkInputMenu2 or raises the existing
%      singleton*.
%
%      H = NetworkInputMenu2 returns the handle to a new NetworkInputMenu2 or the handle to
%      the existing singleton*.
%
%      NetworkInputMenu2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NetworkInputMenu2.M with the given input arguments.
%
%      NetworkInputMenu2('Property','Value',...) creates a new NetworkInputMenu2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RulesBasedMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RulesBasedMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NetworkInputMenu2

% Last Modified by GUIDE v2.5 19-Jun-2017 02:10:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RulesBasedMenu_OpeningFcn, ...
    'gui_OutputFcn',  @RulesBasedMenu_OutputFcn, ...
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


% --- Executes just before NetworkInputMenu2 is made visible.
function RulesBasedMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NetworkInputMenu2 (see VARARGIN)

% Choose default command line output for NetworkInputMenu2
handles.output = hObject;

% Add images to buttons
path = 'Supplementary Functions\Images\';
OpenFileImage = imread([path,'\OpenFile.jpg']);
OpenFileImageResize = imresize(OpenFileImage, [20 20]);
set(handles.BrowseNodeLogicTables, 'CData', OpenFileImageResize);
set(handles.BrowseNodeList, 'CData', OpenFileImageResize);

% SET POSITION TO CENTER
movegui(hObject, 'center');

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);

% UIWAIT makes NetworkInputMenu2 wait for user response (see UIRESUME)
% uiwait(handles.NetworkInputMenu2);


% --- Outputs from this function are returned to the command line.
function varargout = RulesBasedMenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseNodeLogicTables.
function BrowseNodeLogicTables_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseNodeLogicTables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
nodeLogicInput = get(hObject, 'UserData');

if ~isempty(nodeLogicInput)
    tempDirectory = nodeLogicInput{1};
    [~, deepestFolder, ~] = fileparts(tempDirectory);
    choice = questdlg(['You already selected "', deepestFolder,...
        '" folder. Do you want to replace this folder?'], ...
        'Exit', 'Yes', 'No', 'No');
    
    switch choice
        case 'Yes'
        otherwise
            return;
    end
end

% GET DIRECTORY CONTAINING LOGIC FILES
directory = uigetdir;

% CHECK DIRECTORY SELECTION VALIDITY
if directory == 0
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFolder, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Folder selection cancelled by user.');
    % ERROR DLG
    uiwait(errordlg('Folder selection cancelled by user. Please select folder containing logic tables to proceed.', 'Selection cancelled'));
    return;
end

% GETTING ALL THE .TXT IN THE SELECTED DIRECTORY
logicFileDirectory = dir(fullfile(directory, '*.txt'));

% CHECK PRESENCE OF CORRECT FILES IN THE DIRECTORY
if size(logicFileDirectory, 1) == 0
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Selected folder is empty or does not contain valid files. Please select a folder containing logic tables.');
    % ERROR DLG
    uiwait(errordlg('Selected folder is empty or does not contain valid files. Please select a folder containing logic tables.', 'Invalid selection'));
    return;
end

% SAVE THE DIRECTORY IN THE USER DATA
set(hObject, 'UserData', {directory, logicFileDirectory});

% REPLACE BROWSE FILE WITH FILE NAME
[~, deepestFolder, ~] = fileparts(directory);
set(handles.BrowseFolder, 'String', deepestFolder, 'ForegroundColor', [1 0.3 0.5]);

% UPDATE CONSOLE
nodeList = get(handles.BrowseNodeList, 'UserData');
if isempty(nodeList)
    set(handles.Console, 'String', 'Folder conatiaining node update logic files selected. Please select file containing node list to proceed.');
else
    set(handles.Console, 'String', 'Data loaded. Press Ok to procced.');
    uiwait(msgbox('Press "Ok" to load data.', 'Press Ok'));
end

% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);



% --- Executes on button press in BrowseNodeList.
function BrowseNodeList_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseNodeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
nodeList = get(hObject, 'UserData');

if ~isempty(nodeList)
    choice = questdlg(['You already selected "', nodeList{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
    
    switch choice
        case 'Yes'
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
    uiwait(errordlg('File selection cancelled by user. Please select file containing node list to proceed.', 'Selection cancelled'));
    return;
end

% LOAD FILE
nodeList = importdata(fullfile(pathname, filename));

% CHECK IF FILE IS VALID
if ~iscellstr(nodeList) || ~( size(nodeList, 1) == 1 || size(nodeList, 2) == 1 ) || sum(size(nodeList)) <= 2
    set(handles.Console, 'String', 'The selected node list file is invalid. Please see help to see format details.');
    uiwait(errordlg('The selected node list file is invalid. Please see help to see format details.', 'Invalid input'));
    return;
end

% SAVE THE DIRECTORY IN THE USER DATA
set(hObject, 'UserData', {pathname, filename, nodeList});

% REPLACE BROWSE FILE WITH FILE NAME
set(handles.BrowseFile, 'String', filename, 'ForegroundColor', [1 0.3 0.5]);

% UPDATE CONSOLE
nodeLogicInput = get(handles.BrowseNodeLogicTables, 'UserData');
if isempty(nodeLogicInput)
    set(handles.Console, 'String', 'Node list selected. Please select folder containing node update logic tables to proceed.');
else
    set(handles.Console, 'String', 'Data loaded. Press Ok to proceed.');
    uiwait(msgbox('Press "Ok" to load data.', 'Press Ok'));
end
        
% SAVE CHANGES IN GUIDATA
guidata(hObject, handles);


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING IF USER INPUT IS COMPLETE
nodeLogicInput = get(handles.BrowseNodeLogicTables, 'UserData');
nodeList = get(handles.BrowseNodeList, 'UserData');

if ~isempty(nodeLogicInput) && ~isempty(nodeList)
    
    % CREATING NETWORK OBJECT
    myNetwork = NetworkDataStructure();
    myNetwork.NetworkType = 'RulesBased';
    
    % OUTPUT FOLDER NAME
    myNetwork.ResultFolderName = generate_OutputFolderName(nodeList{2});
    
    % EXTRACTING FOLDER PATH
    folderPath = nodeLogicInput{1};

    % PARSING DATA
    bool = parse_LogicTables(myNetwork, folderPath, nodeList{3});
    
    if bool 
        % SAVE NETWORK LOGIC
        set(0, 'UserData', myNetwork);
        
        % SAVE CHANGES IN GUIDATA
        guidata(hObject, handles);
        
        % DELETE THE NETWORK MENU
        delete(NetworkInputMenu2);
    
        % ENABLE ATLANTIS
        enableATLANTIS;
        
        % UPDATE THE ATLANTIS BUTTONS
        updateGraphics;
    end
else
    % IF THE INPUTS ARE NOT COMPLETE GIVE ERROR MSG
    if isempty(nodeLogicInput) && isempty(nodeList)
        uiwait(errordlg('Node list and Node state update logic tables input missing. Please add input to proceed.', 'Missing input'));
    elseif isempty(nodeList)
        uiwait(errordlg('Node list input missing. Please select add node list to proceed.', 'Missing input'));
    else
        uiwait(errordlg('Node state update logic tables missing. Please add logic tables to proceed.', 'Missing input'));
    end
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


% --- Executes when user attempts to close NetworkInputMenu2.
function NetworkInputMenu2_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to NetworkInputMenu2 (see GCBO)
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
