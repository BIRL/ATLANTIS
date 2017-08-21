function restoreUImenus(figHandle, ~)
%

if isempty(figHandle.UIContextMenu)
    figHandle.UIContextMenu = figHandle.UserData;
end

end