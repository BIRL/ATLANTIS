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

function varargout = ModifyNetwork(varargin)
% ModifyNetwork MATLAB code for ModifyNetwork.fig
%      ModifyNetwork, by itself, creates a new ModifyNetwork or raises the existing
%      singleton*.
%
%      H = ModifyNetwork returns the handle to a new ModifyNetwork or the handle to
%      the existing singleton*.
%
%      ModifyNetwork('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ModifyNetwork.M with the given input arguments.
%
%      ModifyNetwork('Property','Value',...) creates a new ModifyNetwork or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NetworkModificationMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NetworkModificationMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModifyNetwork

% Last Modified by GUIDE v2.5 23-Jun-2017 04:02:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @NetworkModificationMenu_OpeningFcn, ...
    'gui_OutputFcn',  @NetworkModificationMenu_OutputFcn, ...
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


% --- Executes just before ModifyNetwork is made visible.
function NetworkModificationMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModifyNetwork (see VARARGIN)

% Choose default command line output for ModifyNetwork
handles.output = hObject;

% Add images to buttons
path = 'Supplementary Functions\Images\';
OpenFileImage = imread([path, 'OpenFile.jpg']);
OpenFileImageResize = imresize(OpenFileImage, [20 20]);
set(handles.BrowseMutations, 'CData', OpenFileImageResize);

% SET POSITION TO CENTER
movegui(hObject, 'center');

enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

updateGraphics;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModifyNetwork wait for user response (see UIRESUME)
% uiwait(handles.ModfiyNetworkMenu);


% --- Outputs from this function are returned to the command line.
function varargout = NetworkModificationMenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseLinkModifications.
%function BrowseLinkModifications_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseLinkModifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BrowseMutations.
function BrowseMutations_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseMutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET NETWORK
myNetwork = get(0, 'UserData');

% CHECKING FOR PREVIOUS INPUT
mutationInfo = get(hObject, 'UserData');

if ~isempty(mutationInfo)
    choice = questdlg(['You already selected "', mutationInfo,...
        ' ". Do you want to replace this/these file(s)?'], ...
        'Exit', 'Yes', 'No', 'No');
   
    switch choice
        case 'Yes'
            set(hObject, 'UserData', []);
            if iscell(myNetwork)
                myNetwork = myNetwork{1}.NetworkBackUp;
            else
                myNetwork = myNetwork.NetworkBackUp;
            end
        otherwise
            return;
    end
end

% GET NETWORK TEXT OR CSV FILE FROM THE USER
[filenames, pathname] = uigetfile({'*.txt', 'Plain text'; '*.csv',...
    'Comma seperated values file'},...
    'Select file containing mutational information'...
    , 'MultiSelect', 'on');


% HANDLE USER INPUT CANCELLATION
if ( pathname == 0 )
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'File input cancelled by the user');
    return;
end

% NETWORK GENERATION METHOD
GenerationMethod = myNetwork.NetworkType;

% MAKE FILENAMES CELLSTR IF ONLY SINGLE FILE
if ~iscellstr(filenames)
    filenames = {filenames};
end

bool = 0;

% CREATING MULTIPLE NETWORK OBJECTS IF MORE THAN ONE MUTATIONS FILES
if numel(filenames) > 1
    myNetworks = cell(numel(filenames), 1);
    for i = 1:numel(filenames)
        tempNetwork = copy(myNetwork);
        % ADD MUTATION TO EACH NETWORK
        if strcmp(GenerationMethod, 'RulesBased')
            bool = addMutations_RulesBased(tempNetwork, pathname, filenames{i});
        else
            bool = addMutations_WeightsBased(tempNetwork, pathname, filenames{i});
        end
        
        if bool
            myNetworks{i} = tempNetwork; 
            clear tempNetwork;
        else
            break;
        end
    end
else % IF ONLY MUTATION FILE
    if strcmp(GenerationMethod, 'RulesBased')
        bool = addMutations_RulesBased(myNetwork, pathname, filenames{1});
    else
        bool = addMutations_WeightsBased(myNetwork, pathname, filenames{1});
    end
    myNetworks = myNetwork;
end

% SAVE CHANGES IN ROOT IF VALID
if bool
    % MSGBOX
    uiwait(msgbox('Mutations Succesfully added to the defined network. Press Done to proceed.'));
    % UPDATE BROWSE FILE
    filenames = joinStr_CellArr(filenames, ' , ');
    set(handles.BrowseFile, 'String', filenames, 'ForegroundColor', [1 0.3 0.5]);
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Mutations Succesfully added to the defined network. Press Done to proceed.');
    % SAVING FILENAMES IN THE BROWSE FILE OBJECT
    set(hObject, 'UserData', filenames);
    % SAVING MUTATION FILENAMES IN ROOT
    setappdata(0, 'MutationFiles', strtrim(strsplit(filenames, ',')));
    % SAVING CHANGES IN THE NETWORK
    set(0, 'UserData', myNetworks);
    % SAVE CHANGES IN GUIDATA
    guidata(hObject, handles);
else
    % MSGBOX
    uiwait(msgbox('Please re-input mutation files.'));
    % UPDATE CONSOLE
    set(handles.Console, 'String', 'Please re-input mutation files.');
    % REVERT TO DEFAULT BROWSE FILE
    set(handles.BrowseFile, 'String', 'Browse file...', 'ForegroundColor', [20 43 140]./250);
end


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET BrowseMutations USER DATA
bool = get(handles.BrowseMutations, 'UserData');

if bool
    % MESSAGE
    uiwait(msgbox('Mutations successfully added.', 'Success'));
    
    % SET DETERMINISTIC ANALYSIS CHECK TO NUL
    setappdata(0, 'DeterministicAnalysis', []);
    
    % ENABLE ATLANTIS FIGURE
    enableATLANTIS;
    
    % CLOSE MENU
    delete(handles.ModfiyNetworkMenu);
else
     uiwait(errordlg('Please select mutation file(s) to proceed.', 'Invalid Input'));
end


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close ModfiyNetworkMenu.
function ModfiyNetworkMenu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ModfiyNetworkMenu (see GCBO)
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
