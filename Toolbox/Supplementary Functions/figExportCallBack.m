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

function figExportCallBack(source, callBackData, figHandle)
try
    % GET USER DEFINED FIGURE EXPORT OPTIONS
    uiwait(ExportFigureMenu);
    
    % EXRACT FIGURE EXPORT OPTIONS
    figExportOptions = getappdata(0, 'ExportOptions');
    
    % CLEAR EXPORT OPTIONS
    setappdata(0, 'ExportOptions', []);
    
    if isempty(figExportOptions)
        return;
    end
    
    % IF VERY HIGH RESOLUTION SET TO 2000
    if figExportOptions.resolution > 2000
        figExportOptions.resolution = 2000;
    end
    
    % IF VERY LOW RESOLUTION SET TO 100
    if figExportOptions.resolution < 100
        figExportOptions.resolution = 100;
    end
    
    % SET RESOLUTION
    resolution = ['-r', num2str(figExportOptions.resolution)];
    
    % SET FIGURE EXPORT FORMAT
    figFormat = figExportOptions.selectedFormat;
    
    % SETTING DEFAULT FILE NAME AND PATH
    currPath = pwd;
    defaultFileName = get(figHandle, 'Name');
    
    % EXPORT FIGURE TO DESIRED LOCATION WTIH CUSTOM NAME
    [fileName, pathName, ~] = uiputfile({['*.', figFormat], ' '},'Save Image',...
        fullfile(currPath, defaultFileName));
    
    if ~ischar(pathName)
        return;
    end
    
    % REMOVE NUMBER TITLE AND UPDATE FIGURE TITLE
    set(figHandle, 'Name', strrep(fileName, ['.', figFormat], ''), 'NumberTitle', 'off');
    
    % EXPORTING FIGURE
    progressbar('Exporting Figure. Please wait...');
    set(figHandle, 'units','normalized','outerposition',[0 0 1 1]);
    try
        warning('off', 'all');
        FigurejFrame = get(figHandle,'JavaFrame');
		FigurejFrame.setMinimized(1);
        warning('on', 'all');
    catch 
    end
    enableDisableFig(figHandle, 'off');
    
    % EXPORT FIGURE
    progressbar(0.2);
    export_fig(strcat(pathName, fileName), ['-', figFormat], resolution, figHandle);
    progressbar(0.8);
    
    % ENABLE FIGURE
    try
        warning('off', 'all');
        FigurejFrame = get(figHandle,'JavaFrame');
		FigurejFrame.setMaximized(1);
        warning('on', 'all');
    catch 
    end
    enableDisableFig(figHandle, 'on');
    set(figHandle, 'units','normalized','outerposition',[0.3125 0.3861 0.3740 0.5898]);
    progressbar(1);
catch
    progressbar(1);
    errordlg('Error Saving Figure', 'Error');
end
end
