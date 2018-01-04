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

function plot_BasinSizeLandscape(x, y, stateSpace, myNetwork, PlottingOptions2)
% PLOTS BASIN SIZE LANDSCAPE

errmsg = 'Error While Plotting Basin Size Landscape';

try
    % PROCESS Z DATA POTENTIAL ENERGIES
    z = zeros(size(stateSpace, 1), 1);
    
    for i = 1:size(myNetwork.AttractorTable, 1)
        attractor = myNetwork.AttractorTable{i, 1};
        [~, indicies] = ismember(attractor, stateSpace, 'rows');
        z(indicies) = myNetwork.AttractorTable{i, 3};
    end
    
%     % GET ATTRACTORS
%     attractors = myNetwork.AttractorTable(:,1);
%     
%     % ATTRACTOR SIZES
%     attrSizes = cellfun(@(x) size(x, 1), attractors);
%     
%     % CONVERT ATTRACTORS TO MATRIX
%     [~, statePos] = ismember(cell2mat(attractors), stateSpace,'rows');
%     
%     row = 0;
%     
%     for s = 1:numel(attrSizes)
%         z(statePos(row + 1: row + attrSizes(s))) = myNetwork.AttractorTable{s, 3};
%         row = attrSizes(s);
%     end
    
    PlottingOptions2.plotTypes = 'BS';
    
    % PLOT LANDSCAPE
    [figHandle, bool, h, gridToolTipData, gridData] = plot_AttractorLandscape(myNetwork...
        , x, y, z, PlottingOptions2, stateSpace);
    
    % ADD CONTEXT MENU
    menuLabel = 'Export Figure';
    callBack = {@figExportCallBack, figHandle};
    addContextMenuToFigure(figHandle.UIContextMenu, menuLabel, callBack);
    
    % IF PLOTTING SUCCESSFUL
    if bool
        % LABEL Z AXIS
        zlabel('Basin Sizes');
        
        mappingMethod = PlottingOptions2.mappingMethod;
        if PlottingOptions2.showToolTip && strcmp(mappingMethod, 'naive')
            % ADD DATAPOINT
            [r, c] = find(cellfun(@isempty, gridToolTipData) == 0, 1);
            customToolTips_NaiveMapping(h, {c, r}, {gridToolTipData, gridData});
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
            str =  ' - Basin Size Landscape';
            
            % EXPORT FIGRE
            bool = exportFigure(figHandle, myNetwork, resVal, str, selectedFormat);
            
            if ~bool
                errmsg = 'Error while saving basin size landscape plot';
                undefined/0; %#ok<*VUNUS>
            end
        end
        
        movegui(figHandle,'center');
    else
        undefined/0;
    end
catch
    errordlg(errmsg, 'Error');
end

end

