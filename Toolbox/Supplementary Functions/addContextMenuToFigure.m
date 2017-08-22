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

function parent = addContextMenuToFigure(root, menuLabel, callBack)
% ADD CONTEXT MENU TO FIGURE THAT CAN EXPORT FIGURE

try
%     if isempty(figHandle.UIContextMenu)
%         % ASSIGN THE UICONTEXTMENU TO THE FIGURE
%         topMenu = uicontextmenu(figHandle);
%         figHandle.UIContextMenu = topMenu;
%     else
%         topMenu = figHandle.UIContextMenu;
%     end
    
    % ADD UIMENU FOR EXPORTING FIGURE
    parent = uimenu(root, 'Label', menuLabel, 'Callback', callBack);
catch
    disp('Error while adding context menu');
end

end