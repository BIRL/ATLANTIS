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

function plot_PotentialEnergyLandscape(x, y, stateSpace, myNetwork, PlottingOptions2)
% PLOTS POTENTIAL ENERGY LANDSCAPE

errmsg = 'Error While Plotting Potential Energy Landscape';

try
    % NOISE REDUCTION
    rawPE = -log(myNetwork.SteadyStateProbabilities);
    PE = rawPE - max(rawPE);
    PE = PE.^PlottingOptions2.noiseReductionFactor;
    PE = PE / min(PE);
    
    % PLOT LANDSCAPE
    PlottingOptions2.plotTypes = 'PE';
    [figHandle, bool, h, gridToolTipData, gridData] = plot_AttractorLandscape(myNetwork, x, y, PE, ...
        PlottingOptions2, stateSpace);
    
    % ADD CONTEXT MENU
    menuLabel = 'Export Figure';
    callBack = {@figExportCallBack, figHandle};
    addContextMenuToFigure(figHandle.UIContextMenu, menuLabel, callBack);
    
    % IF PLOTTING SUCCESSFUL
    if bool
        % LABEL Z AXIS
        zlabel('Normalized Transformed Potential Energies');
        
        mappingMethod = PlottingOptions2.mappingMethod;
        if PlottingOptions2.showToolTip && strcmp(mappingMethod, 'naive')
            % ADD DATAPOINT
            [r, c] = find(cellfun(@isempty, gridToolTipData) == 0, 1);
            customToolTips_NaiveMapping(h, {r, c}, {gridToolTipData, gridData});
        elseif PlottingOptions2.showToolTip && strcmp(mappingMethod, 'sammon')
            % ADD DATAPOINT
            index = gridData{2};
            customToolTips_SammonMapping(h, index(1), {gridToolTipData, gridData{1}});
        end
        
        % SAVE FIGURE
        if PlottingOptions2.saveFigure
            % EXTRACT FORMAT AND RESOLUTION
            selectedFormat = ['-',PlottingOptions2.selectedFormat];
            resVal = PlottingOptions2.resolution;
            
            % FILE NAME
            str =  ' - Potential Energy Landscape';
            
            % EXPORT FIGRE
            bool = exportFigure(figHandle, myNetwork, resVal, str, selectedFormat);
            
            if ~bool
                errmsg = 'Error while saving potential energy landscape plot';
                undefined/0; %#ok<*VUNUS>
            end
        end
        
        movegui(figHandle,'center');
    else
        errmsg = 'Error While Plotting Potential Energy Landscape';
        undefined/0;
    end
catch
    errordlg(errmsg, 'Error');
end

end

