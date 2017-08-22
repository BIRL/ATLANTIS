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

function varargout = ProbabilisticAnalysisMenu(varargin)
% PROBABILISTICANALYSISMENU MATLAB code for ProbabilisticAnalysisMenu.fig
%      PROBABILISTICANALYSISMENU, by itself, creates a new PROBABILISTICANALYSISMENU or raises the existing
%      singleton*.
%
%      H = PROBABILISTICANALYSISMENU returns the handle to a new PROBABILISTICANALYSISMENU or the handle to
%      the existing singleton*.
%
%      PROBABILISTICANALYSISMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROBABILISTICANALYSISMENU.M with the given input arguments.
%
%      PROBABILISTICANALYSISMENU('Property','Value',...) creates a new PROBABILISTICANALYSISMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProbabilisticAnalysisMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProbabilisticAnalysisMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to ok (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProbabilisticAnalysisMenu

% Last Modified by GUIDE v2.5 30-Jun-2017 09:22:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProbabilisticAnalysisMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @ProbabilisticAnalysisMenu_OutputFcn, ...
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


% --- Executes just before ProbabilisticAnalysisMenu is made visible.
function ProbabilisticAnalysisMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProbabilisticAnalysisMenu (see VARARGIN)

% Choose default command line output for ProbabilisticAnalysisMenu
handles.output = hObject;

% Add Images to Open File Button
path = 'Supplementary Functions\Images\';
OpenFileImage = imread([path, 'OpenFile.jpg']);
OpenFileImageResize = imresize(OpenFileImage, [20 20]);
set(handles.BrowseFixNodeStates, 'CData', OpenFileImageResize);
set(handles.BrowseCellFateLogic, 'CData', OpenFileImageResize);
set(handles.BrowseTrajectoryBounds, 'CData', OpenFileImageResize);

% RESTORE PREVIOUS INPUTS
cellFateInfo = getappdata(0, 'CellFateLogic');
inputNodeStatesInfo = getappdata(0, 'InputNodeStates');
trajectoryBoundInfo = getappdata(0, 'TrajectoryBounds');

if ~isempty(inputNodeStatesInfo)
    set(handles.BrowseFile1, 'String', inputNodeStatesInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
end

if ~isempty(cellFateInfo)
    set(handles.BrowseFile2, 'String', cellFateInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
end

if ~isempty(trajectoryBoundInfo)
    set(handles.BrowseFile3, 'String', trajectoryBoundInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
end

MapTrajectory_Callback(handles.MapTrajectory, eventdata, handles);

% SET POSITION TO CENTER
movegui(hObject, 'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProbabilisticAnalysisMenu wait for user response (see UIRESUME)
% uiwait(handles.ProbabilisticAnalysisMenu);


% --- Outputs from this function are returned to the command line.
function varargout = ProbabilisticAnalysisMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% GET MAT FILE INPUT FROM USER
[filename, pathname] = uigetfile({'*.mat', 'MATLAB data file'; '*.csv',...
    'Comma seperated values file'},'Select mat file containing network state list');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
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
catch
    % ERROR DLG
    uiwait(errordlg('The selected file is invalid. Possible reasons: 1) No variable in the mat file, 2) is not boolean, 3) variables in state list differ from node count. Please press help for more information on data input.', 'Invalid data input'));
    
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Invalid user input.');
    return;
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

% GET TEXT OR CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.txt', 'Plain text';'*.csv','Comma seperated values file'},...
                             'Select file containing nodes whose states are to be fixed and the state to be fixed in.');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
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

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
                         
% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
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
    
    % SAVE EXPANDED LOGIC TO CSV
    networkFileName = getappdata(0, 'NetworkfileName');
    str =  ' - Cell Fate Logic';
    FileName = [networkFileName, str, '.csv'];
    PathName = myNetwork.ResultFolderName;
    [~, ~] = mkdir(PathName); % MAKE FOLDER
    
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


% --- Executes on button press in BrowseTrajectoryBounds.
function BrowseTrajectoryBounds_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseTrajectoryBounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHECKING FOR PREVIOUS INPUT
fileInfo = getappdata(0, 'TrajectoryBounds');

% GET NETWORK
myNetwork = get(0, 'UserData');

if ~isempty(fileInfo)
    choice = questdlg(['You already selected "', fileInfo{2},...
        ' ". Do you want to replace this file?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            % REMOVE PREVIOUS INPUT INFO
            setappdata(0, 'TrajectoryBounds', []);
            % REMOVE CELL FATE LOGIC FROM NETWORK
            myNetwork.TrajectoryBounds = [];
            % REVERT TO DEFAULT BROWSE FILE
            set(handles.BrowseFile3, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end

% GET TEXT OR CSV FILE FROM THE USER
[filename, pathname] = uigetfile({'*.csv','Comma seperated values file' ; '*.txt', 'Plain text'},...
                             'Select file containing start and end states of the trajectory.');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    return;
end                        

% PARSE FILE
bool = parse_TrajectoryBounds(myNetwork, filename, pathname);

if bool
    % UDPATE BROWSE FILE
    set(handles.BrowseFile3, 'String', filename, 'ForegroundColor', [1 0.3 0.5]);
    
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Start and end state of the successfully integrated into the network.');
    
    % MSG
    uiwait(msgbox('Start and end state of the successfully integrated into the network.', 'Success'));
    
    % SAVE CELL FATE LOGIC IN ROOT
    setappdata(0, 'TrajectoryBounds', {pathname, filename});
else
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile3, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Invalid file input.');
    % ERROR MESSAGE
    uiwait(errordlg('The selected file is not properly formated. Please enter a valid file or press help for more information on the file formatting.', 'Invalid input'));
end

% SAVE GUI CHANGES
guidata(hObject, handles);


% --- Executes on button press in MapTrajectory.
function MapTrajectory_Callback(hObject, eventdata, handles)
% hObject    handle to MapTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MapTrajectory

% SEE IF FIND TRANSIENT STATES OPTION CHECKED
bool = get(hObject, 'Value');

% GET NETWORK
myNetwork = get(0, 'UserData');

if bool
    % SET TRAJECTORY MAPPING TO TRUE
    myNetwork.MapTrajectory = 1;
    
    % ACTIVATE TRAJECTOR MAPPING OPTION
    trajectoryBoundsInfo = getappdata(0, 'TrajectoryBounds');
    if isempty(trajectoryBoundsInfo)
        set(handles.BrowseFile3, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    else
        set(handles.BrowseFile3, 'String', trajectoryBoundsInfo{2}, 'ForegroundColor', [1 0.3 0.5]);
    end
    set(handles.BrowseTrajectoryBounds, 'Enable', 'on');
else
    % SET TRAJECTORY MAPPING TO OFF
    myNetwork.MapTrajectory = [];
    % DISABLE TRAJECTORY MAPPING OPTION
    set(handles.BrowseFile3, 'ForegroundColor', [204 204 204]./250);
    set(handles.BrowseTrajectoryBounds, 'Enable', 'inactive');
end

% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

% CHECK: IF NETWORK STATE LIST IS PRESENT
if isempty(myNetwork.NetworkStateList)
    uiwait(errordlg('Network state list missing. Please generate or input custom network state list to proceed.', 'Missing network state list.'));
    return;
end

if size(myNetwork.NetworkStateList, 1) < 2^(myNetwork.NodeCount)
    choice = questdlg('Random sampling has been used to generate a reduced state space. However, probabilistic analysis requires complete state space to work correctly. Do you want continue regardless?', ...
    'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
        otherwise
            uiwait(msgbox('Please generate complete state space.', 'Warning'));
            return;
    end
end

% CHECK IF NOISE HAS BEEN ENTERED
noise = str2num(get(handles.EditNoise, 'String'));
if isempty(noise) || size(noise, 1) > 1 || size(noise, 2) > 1
    uiwait(errordlg('Please enter appropiate noise value.', 'Missing or Invalid input.'));
    return; 
elseif noise < 0
    uiwait(errordlg('Noise cannot be negative. Please enter a positive value.', ...
    'Warning'));
    return;
elseif noise > 1000
    uiwait(errordlg('Please enter a appropiate noise value.', ...
    'Warning'));
    return;
else
    % UPDATE NOISE
    myNetwork.Noise = noise;
end

% CHECK IF DEGRADATION CONSTANT HAS BEEN ENTERED
degradationConstant = str2num(get(handles.EditDegradationConstant, 'String'));
if isempty(degradationConstant) || size(degradationConstant, 1) > 1 || size(degradationConstant, 2) > 1
    uiwait(errordlg('Please enter appropiate degradation constant value (Between 0 and 1).', 'Missing or Invalid input.'));
    return; 
elseif degradationConstant < 0 || degradationConstant > 1
    uiwait(errordlg('Degradation constant value has to be inbetween 0 and 1. Please input a valid value.', ...
    'Warning'));
    return;
else
    myNetwork.DegradationConstant = degradationConstant;
end

% CHECK IF SIMULATION TIME HAS BEEN ENTERED
simulationTime = str2num(get(handles.EditSimulationTime, 'String'));
if isempty(simulationTime) || size(simulationTime, 1) > 1 || size(simulationTime, 2) > 1
    uiwait(errordlg('Please enter appropiate value for simulation time steps.', 'Missing or Invalid input.'));
    return; 
elseif simulationTime < 1
    uiwait(errordlg('Simulation time value should be more than 1. Please enter a valid value', 'Error'));
    return;
elseif simulationTime > 50000 && simulationTime < 200000
    choice = questdlg('Specified simulation time is very large. Please not this will take long time. Do you want to continue ?', ...
    'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            myNetwork.TimeSteps = simulationTime;
        otherwise
            uiwait(msgbox('Please update simulation time steps value to proceed.', 'Warning'));
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
elseif simulationTime > 200000
    uiwait(errordlg('Invalid simulation time. Please enter a valid value', 'Error'));
    return;
else
    myNetwork.TimeSteps = simulationTime;
end

% CHECK IF STEADY STATE PRECISION HAS BEEN ENTERED
steadyStatePrecision = str2num(get(handles.EditSteadyStatePrecision, 'String'));
if isempty(steadyStatePrecision) || size(steadyStatePrecision, 1) > 1 || size(steadyStatePrecision, 2) > 1
    uiwait(errordlg('Please enter steady state precision value.', 'Missing or Invalid input.'));
    return; 
elseif steadyStatePrecision <= 0
    uiwait(errordlg('Steady state precision cannot be 0 or less. Please enter an integer greater than 0.', 'Error'));
    return;
elseif steadyStatePrecision > 2 && steadyStatePrecision < 10
    choice = questdlg('Specified steady state precision value is quite large. The system may take a long time to reach steady state. Do you want to continue?', ...
    'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            myNetwork.SteadyStatePrecision = steadyStatePrecision;
        otherwise
            uiwait(msgbox('Please update steady state precision value to proceed.', 'Warning'));
            return;
    end
elseif steadyStatePrecision > 10
    uiwait(errordlg('Invalid steady state precision value. Please enter an integer greater than 0 and less than 10.', 'Error'));
    return;
else
    myNetwork.SteadyStatePrecision = steadyStatePrecision;
end

% CHECK IF TRAJECTORY MAPPING OPTION IS ENABLED
mapTrajectory = get(handles.MapTrajectory, 'Value');
if mapTrajectory == 1
    trajectoryBoundsInfo = getappdata(0, 'TrajectoryBounds');
    if isempty(trajectoryBoundsInfo)
        uiwait(errordlg('Trajectroy bounds input is missing. Please input this to proceed with analysis or uncheck option of finding transient states.', 'Error'));
        return;
    end
    myNetwork.MapTrajectory = 1;
else
    myNetwork.MapTrajectory = 0;
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
    choice = questdlg('Cell fate logic is missing. Please note steady states would not be characterized and associated with cell fates. Do you want to continue without entering cell fate logic?', ...
        'Warning', 'Yes', 'No', 'No');
    switch choice
        case 'Yes'
        otherwise
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
            return;
    end
end

choice = questdlg('Begin probabilistic analysis?', ...
        'Warning', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        % SAVE GUI DATA
        guidata(hObject, handles);
        
        % SAVE NETWORK
        set(0, 'UserData', myNetwork);       
        
        % GIVE A GREEN LIGHT
        setappdata(0, 'ProbabilisticAnalysis', 1);
    otherwise
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
end

% SAVE?
choice = questdlg('Save results after the job(s) is/are completed?', ...
    'Warning', 'Yes', 'No', 'No');
switch choice
    case 'Yes'
        setappdata(0, 'SaveProbabilisticAnalysis', 1);
    otherwise
        setappdata(0, 'SaveProbabilisticAnalysis', 0);
end

% CLOSE MENU
delete(handles.ProbabilisticAnalysisMenu);

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


% --- Executes when user attempts to close ProbabilisticAnalysisMenu.
function ProbabilisticAnalysisMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ProbabilisticAnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
choice = questdlg('Close this menu?', ...
                         'Exit', ...
                         'Yes', 'No', 'No');
enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
% Handle response
switch choice
    case 'Yes'
        % RESET PROBABILISTIC ANALYSIS
        setappdata(0, 'ProbabilisticAnalysis', []);
        % CLOSE MENU
        delete(hObject);
    otherwise
        enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');
        return;
end
