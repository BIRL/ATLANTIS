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
function bool = exportFigure(figHandle, myNetwork, resVal, str, selectedFormat)
% SAVES FIGURE IN THE CHOOSEN FORMAT AND RESOLUTION

try
    % IF VERY HIGH RESOLUTION SET TO 2000
    if resVal > 2000
        resVal = 2000;
    end
    
    if resVal < 100
        resVal = 100;
    end
    
    resolution = ['-r', num2str(resVal)];
    
    % CREATE NAME
    if ~isempty(myNetwork.FileName)
        FileName = strrep(myNetwork.FileName, ' - ', '');
        PathName = strcat(myNetwork.ResultFolderName, strrep(myNetwork.FileName, ' - ', '\'));
    else
        FileName = getappdata(0, 'NetworkfileName');
        PathName = strcat(myNetwork.ResultFolderName);
    end
    
    % MAKE RESULTS FOLDER
    
    [~, ~] = mkdir(PathName);
    
    FileName = [FileName, str];
    
    set(gcf, 'Name', FileName, 'NumberTitle', 'off');
    
    set(figHandle, 'UserData', figHandle.UIContextMenu);
    set(figHandle, 'WindowButtonMotionFcn', @restoreUImenus);
    
    % EXPORT MATLAB FIG
    savefig(figHandle, strcat(PathName, FileName, '.fig'), 'compact');
    progressbar(0.2);
    
    set(figHandle, 'WindowButtonMotionFcn', []);
    
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
    progressbar(0.6);
    export_fig(strcat(PathName, FileName), selectedFormat, resolution, figHandle);
    progressbar(8);
    
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
    
    % SUCCESS
    bool = 1;
    
catch
    % FAILURE
    bool = 0;
end

end

