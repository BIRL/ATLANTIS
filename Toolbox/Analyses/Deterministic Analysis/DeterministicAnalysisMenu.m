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

function varargout = DeterministicAnalysisMenu(varargin)
% DETERMINISTICANALYSISMENU MATLAB code for DeterministicAnalysisMenu.fig
%      DETERMINISTICANALYSISMENU, by itself, creates a new DETERMINISTICANALYSISMENU or raises the existing
%      singleton*.
%
%      H = DETERMINISTICANALYSISMENU returns the handle to a new DETERMINISTICANALYSISMENU or the handle to
%      the existing singleton*.
%
%      DETERMINISTICANALYSISMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETERMINISTICANALYSISMENU.M with the given input arguments.
%
%      DETERMINISTICANALYSISMENU('Property','Value',...) creates a new DETERMINISTICANALYSISMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeterministicAnalysisMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeterministicAnalysisMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeterministicAnalysisMenu

% Last Modified by GUIDE v2.5 01-Jul-2017 13:02:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DeterministicAnalysisMenu_OpeningFcn, ...
    'gui_OutputFcn',  @DeterministicAnalysisMenu_OutputFcn, ...
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


% --- Executes just before DeterministicAnalysisMenu is made visible.
function DeterministicAnalysisMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeterministicAnalysisMenu (see VARARGIN)

% Choose default command line output for DeterministicAnalysisMenu
handles.output = hObject;

% Add Images to Open File Button
path = 'Images\';
OpenFileImage = imread([path, 'OpenFile.jpg']);
OpenFileImageResize = imresize(OpenFileImage, [20 20]);
set(handles.BrowseFixNodeStates, 'CData', OpenFileImageResize);
set(handles.BrowseCellFateLogic, 'CData', OpenFileImageResize);

% RESTORE PREVIOUS INPUTS
cellFateInfo = getappdata(0, 'CellFateLogic');
inputNodeStatesInfo = getappdata(0, 'InputNodeStates');

if ~isempty(cellFateInfo)
    set(handles.BrowseFile2, 'String', cellFateInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
end

if ~isempty(inputNodeStatesInfo)
    set(handles.BrowseFile1, 'String', inputNodeStatesInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
end

% MOVE GUI TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DeterministicAnalysisMenu wait for user response (see UIRESUME)
% uiwait(handles.DeterministicAnalysisMenu);


% --- Outputs from this function are returned to the command line.
function varargout = DeterministicAnalysisMenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CustomStates.
function CustomStates_Callback(hObject, eventdata, handles)
% hObject    handle to CustomStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');
nodeCount = myNetwork.NodeCount;

% NETWORK STATE LIST
networkStateList = myNetwork.NetworkStateList;

if ~isempty(networkStateList)
    choice = questdlg('Network state list was already selected. Do you want to modify it?', ...
        'Warning', 'Yes', 'No', 'No');
    % HANDLE RESPONSE
    switch choice
        case 'Yes'
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end

% GET MAT FILE INPUT FROM USER
[filename, pathname] = uigetfile({'*.mat', 'MATLAB data file'; '*.csv',...
    'Comma seperated values file'},'Select mat file containing network state list');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
end

% CHECK FILE FORMAT
if strfind(filename, '.mat')
    
    % LOAD MAT FILE
    fileHandle = load(fullfile(pathname, filename));
    varName = fieldnames(fileHandle);
    
    % CHECK HOW MANY VAR IN MAT FILE
    if numel(varName) == 0 || numel(varName) > 1
        uiwait(errordlg('The selected mat file is either empty or contains multiple variables. Please input mat file containing only one network state list.', 'Invalid mat file'));
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
    end
    
    stateCombinations = getfield(fileHandle, varName{1});
    clear fileHandle;
    
elseif strfind(filename, '.csv')
    
    % IMPORT FILE DATA
    fileInfo = importdata(fullfile(pathname, filename));
    
    % CHECK IF EMPTY AND IS CONTAINS NUMERIC DATA
    if isempty(fileInfo)
        uiwait(errordlg('The selected csv file is empty. Please input valid csv. Press help for more information.', 'Invalid mat file'));
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
    end
    
    if iscell(fileInfo)
        % GET NUMERIC DATA
        try
            stateCombinations = fileInfo{2,:, :};
        catch
            stateCombinations = [];
        end
    else
        stateCombinations = fileInfo;
    end 
end

try
    % SANITY CHECK 1: ISEMPTY?
    if isempty(stateCombinations)
        undefined/0;
    end

    % SANITY CHECK 2: ISNUMERIC?
    isboolean = all((stateCombinations == 1) == (stateCombinations ~= 0));
    if ~isboolean
        undefined/0;
    end
    clear isboolean;

    % SANITY CHECK 3: LENGHT OF STATE == nodeCount?
    if ~(size(stateCombinations, 2) == nodeCount)
        undefined/0;
    end

    % UPDATE NETWORK STATE LIST
    myNetwork.NetworkStateList = stateCombinations;
    
    % SAVE NETWORK
    set(0, 'UserData', myNetwork);
    
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Selected network state list input added to the network.');
    
    % MSGBOX
    uiwait(msgbox('Selected network state list input added to the network', 'Success'));
catch
    % ERROR DLG
    uiwait(errordlg('The selected file is invalid. Possible reasons: 1) No variable in the mat file, 2) is not boolean, 3) variables in state list differ from node count. Please press help for more information on data input.', 'Invalid data input'));
    
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Invalid user input.');
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
end
   

% --- Executes on button press in GenerateStates.
function GenerateStates_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% NETWORK STATE LIST
networkStateList = myNetwork.NetworkStateList;

if isempty(networkStateList)
    run GenerateStates.m
else
    choice = questdlg('Network state list already generated. Do you want to modify it?', ...
        'Warning', 'Yes', 'No', 'No');
    % HANDLE RESPONSE
    switch choice
        case 'Yes'
            GenerateStates;
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end


% --- Executes on button press in BrowseFixNodeStates.
function BrowseFixNodeStates_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseFixNodeStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
fileInfo = getappdata(0, 'InputNodeStates');

% GET NETWORK
myNetwork = get(0, 'UserData');

if ~isempty(fileInfo)
    choice = questdlg(['You already selected "', fileInfo{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            % GET NETWORK STATE LIST BACK UP
            oldNetworkStateList = getappdata(0, 'NetworkStateList');
            % RESTORE BACKUP
            myNetwork.NetworkStateList = oldNetworkStateList;
            % REMOVE PREVIOUS INPUT INFO
            setappdata(0, 'InputNodeStates', []);
            % REVERT TO DEFAULT BROWSE FILE
            set(handles.BrowseFile1, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end


% GET TXT OR CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.csv','Comma seperated values file';'*.txt', 'Plain text'},...
                             'Select file containing nodes whose states are to be fixed and the state to be fixed in.');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
end

% FIX INPUT NODE STATES
[bool, inputNodes] = fix_NodeStates(myNetwork, fullfile(pathname, filename));
    
if bool 
    % UDPATE BROWSE FILE
    set(handles.BrowseFile1, 'String', filename, 'ForegroundColor', [1 0.3 0.5]);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Specified nodes states successfully fixed.');
    % MSG
    uiwait(msgbox(['The states of the following nodes: ', joinStr_CellArr(inputNodes, ', '), ' were fixed.'], 'Success'));
    % SAVE A COPY IN ROOT
    setappdata(0, 'InputNodeStates', {pathname, filename});
else
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile1, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Invalid file input.');
    % ERROR MESSAGE
    uiwait(errordlg('The selected file is not properly formated. Please enter a valid file or press help for more information on the file formatting.', 'Invalid input'));
end

% SAVE GUI CHANGES
guidata(hObject, handles);


% --- Executes on button press in BrowseCellFateLogic.
function BrowseCellFateLogic_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseCellFateLogic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
fileInfo = getappdata(0, 'CellFateLogic');

% GET NETWORK
myNetwork = get(0, 'UserData');

if ~isempty(fileInfo)
    choice = questdlg(['You already selected "', fileInfo{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            % REMOVE PREVIOUS INPUT INFO
            setappdata(0, 'CellFateLogic', []);
            % REMOVE CELL FATE LOGIC FROM NETWORK
            myNetwork.CellFateDeterminationLogic = [];
            % REVERT TO DEFAULT BROWSE FILE
            set(handles.BrowseFile2, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end


% GET CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.csv','Comma seperated values file'},...
                             'Select file containing cell fate determination logic.');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
end

% GENERATE CELL FATE LOGIC
[bool, logic] = parse_CellFateLogic(myNetwork, filename, pathname);

if bool 
    % UDPATE BROWSE FILE
    set(handles.BrowseFile2, 'String', filename, 'ForegroundColor', [1 0.3 0.5]);
    
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Cell fate logic successfully integrated into the network.');
    
    % MSG
    uiwait(msgbox('Cell fate logic successfully integrated into the network.', 'Success'));
    
    % SAVE CELL FATE LOGIC IN ROOT
    setappdata(0, 'CellFateLogic', {pathname, filename});
    
    % MAKE RESULTS FOLDER
    PathName = myNetwork.ResultFolderName;
    [~, ~] = mkdir(PathName);
    
    % SAVE EXPANDED LOGIC TO CSV
    networkFileName = getappdata(0, 'NetworkfileName');
    str =  ' - Cell Fate Logic';
    FileName = [networkFileName, str, '.csv'];
    
    try
        cell2csv(strcat(PathName, FileName), logic);
    catch
    end
    
else
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile2, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Invalid file input.');
    % ERROR MESSAGE
    uiwait(errordlg('The selected file is not properly formated. Please enter a valid file or press help for more information on the file formatting.', 'Invalid input'));
end

% SAVE GUI CHANGES
guidata(hObject, handles);


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% CHECK: IF NETWORK STATE LIST IS PRESENT
if isempty(myNetwork.NetworkStateList)
    uiwait(errordlg('Network state list missing. Please generate or input custom network state list to proceed.', 'Missing network state list.'));
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
end

% CHECK CYCLE SIZE IS ENTERED
attractorSearchDuration = str2num(get(handles.EditSearchDuration, 'String'));
if isempty(attractorSearchDuration) || size(attractorSearchDuration, 1) > 1 || size(attractorSearchDuration, 2) > 1
    uiwait(errordlg('Please enter appropiate cycle size value.', 'Missing or Invalid input.'));
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return; 
elseif attractorSearchDuration <= 10
    uiwait(errordlg('Attractor search duration cannot less than 10. Please enter an appropiate value.', 'Error'));
    enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
    return;
elseif attractorSearchDuration > 1000
    choice = questdlg('Specified attractor search duration is very large. This might make the analysis slower. Do you still continue with this value?', ...
    'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            myNetwork.AttractorSearchDuration = attractorSearchDuration;
        otherwise
            uiwait(msgbox('Please update search duration value.', 'Warning'));
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
else
    myNetwork.AttractorSearchDuration = attractorSearchDuration;
end

% CHECK: INPUT NODES HAVE BEEN FIXED
inputNodeStatesInfo = getappdata(0, 'InputNodeStates');
if isempty(inputNodeStatesInfo)
    choice = questdlg('States of input nodes have not been fixed. Do you want to continue without fixing input node states?', ...
        'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end

% CHECK: CELL FATE LOGIC IS PRESENT
cellFateInfo = getappdata(0, 'CellFateLogic');
if isempty(cellFateInfo)
    choice = questdlg('Cell fate logic is missing. Cell fate association with attractors and cell fate landscape plotting will be unavailable. Do you want to continue without entering cell fate logic?', ...
        'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end

% BEGIN?
choice = questdlg('Begin deterministic analysis?', ...
        'Warning', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        % SAVE GUI DATA
        guidata(hObject, handles);
        
        % SAVE NETWORK
        set(0, 'UserData', myNetwork);       
        
        % GIVE A GREEN LIGHT
        setappdata(0, 'DeterministicAnalysis', 1);
    otherwise
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
end

% SAVE?
choice = questdlg('Save results after the job(s) is/are completed?', ...
    'Warning', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        setappdata(0, 'SaveDeterministicAnalysis', 1);
    otherwise
        setappdata(0, 'SaveDeterministicAnalysis', 0);
end

% CLOSE MENU
delete(handles.DeterministicAnalysisMenu);

% CHARACTERIZE NETWORK STATE LIST
if ~isempty(myNetwork.CellFateDeterminationLogic)
    attractorList = cellfun(@(a) a(:, myNetwork.OutputNodesIndices), ...
                num2cell(myNetwork.NetworkStateList, 2), 'un', 0);
            
    myNetwork.AssociatedCellFates = cellfun(@(attr) associate_CellFates...
                (myNetwork.CellFateDeterminationLogic, attr, ...
                numel(myNetwork.UniqueCellFates)), attractorList); 
end

% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when user attempts to close DeterministicAnalysisMenu.
function DeterministicAnalysisMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to DeterministicAnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
    'Exit', 'Yes', 'No', 'No');
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
% HANDLE RESPONSES
switch choice
    case 'Yes'
        % RESET DETERMINISTIC ANALYSIS
        setappdata(0, 'DeterministicAnalysis', []);
        
        % CLOSE MENU
        delete(hObject);
    otherwise
        return;
end
