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

function errmsg = generate_CellFateLandscape
% PLOTS CELL FATE LANDSCAPE

% DEFAULT ERROR MESSAGE
errmsg = '';

% GET NETWORK 
myNetwork = get(0, 'UserData');

% EXTRACT PLOTTING OPTIONS
PlottingOptions1 = myNetwork.CellFateLandscapePlottingOptions;

try
    % EXTRACT PLOTTING OPTIONS
    plotTitle = PlottingOptions1.plotTitle;
    showLegends = PlottingOptions1.showLegends;
    annotateBoxes = PlottingOptions1.annotateBoxes;
    selectedColorScheme = PlottingOptions1.selectedColorScheme;
    saveFigure = PlottingOptions1.saveFigure;

    % PLOT CELL FATE LANDSCAPE
    bool = plot_CellFateLandscape(myNetwork, plotTitle, showLegends, annotateBoxes, ...
        selectedColorScheme, myNetwork.CellFateLandscape);
    
    figHandle = gcf;
    
    % ADD EXPORT FIGURE UIMENU
    menuLabel = 'Export Figure';
    callBack = {@figExportCallBack, figHandle};
    addContextMenuToFigure(figHandle.UIContextMenu, menuLabel, callBack);
    
    % IF PLOTTING SUCCESSFUL
    if bool
        % SAVE FIGURE
        if saveFigure
            % EXTRACT FORMAT AND RESOLUTION
            selectedFormat = ['-',PlottingOptions1.selectedFormat];
            resVal = PlottingOptions1.resolution;

            % FILE NAME
            str =  ' - Cell Fate Landscape';

            % EXPORT FIGRE
            bool = exportFigure(figHandle, myNetwork, resVal, str, selectedFormat);
            enableDisableFig(findall(0, 'tag','ATLANTIS_Main'), 'off');

            if ~bool
                if ~isempty(myNetwork.FileName)
                    errmsg = ['Error while exporting figure for ', myNetwork.FileName];
                else
                    errmsg = ['Error while exporting figure'];
                end
                undefined/0;
            end
        end
    else
        if ~isempty(myNetwork.FileName)
            errmsg = ['Error while plotting cell fate landscape for ', myNetwork.FileName];
        else
            errmsg = 'Error while plotting cell fate landscape';
        end
        undefined/0;
    end
catch
end

end

