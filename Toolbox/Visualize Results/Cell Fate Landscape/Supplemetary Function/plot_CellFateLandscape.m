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

function bool = plot_CellFateLandscape(myNetwork, plotTitle, showLegends, annotateBoxes, selectedColorScheme, CellFateLandsacpe)
% PLOTS CELL FATE LANDSCAPE USING TREEPMAPS

try
    % PROCESS DATA
    dataSize = size(CellFateLandsacpe, 1); %#ok<NASGU>
    basinRatios = round(cell2mat(CellFateLandsacpe(:,2)), 2, 'significant');
    basinRatiosCell = cellstr(num2str(basinRatios));
    
    % SET COLORS
    colors = eval(['(', selectedColorScheme, '(dataSize) + 1)', '/2']);
    
    % START PLOTTING
    figHandle = figure;
    landscape = treemap(basinRatios);
    
    % ADD CONTEXT MENU TO FIGURE
    rootMenu = uicontextmenu(figHandle);
    figHandle.UIContextMenu = rootMenu;
        
    % ADD ANNOTATIONS AND COLORS
    if annotateBoxes
        [textObj, patchObj] = plotRectangles(landscape, basinRatiosCell, colors);
        
        % PARENT MENU 1
        menuLabel = 'Hide Annotations';
        addContextMenuToFigure(rootMenu, menuLabel, {@toggleAnnotations, textObj});
    else
        [~, patchObj] = plotRectangles(landscape, {}, colors);
    end
    
    % PARENT MENU 2
    menuLabel = 'Toggle Box Colors';
    childMenu = addContextMenuToFigure(rootMenu, menuLabel, '');
    colors = {'hot', 'autumn', 'cool', 'gray', 'hsv', 'jet', 'prism', 'spring', 'summer', 'winter'};
    
    % CHILD MENUS
    for ii = 1:numel(colors)
        addContextMenuToFigure(childMenu, colors{ii}, {@toggleBoxColors, patchObj, colors{ii}, dataSize});
    end
    
    % REMOVE NUMBER TITLE AND UPDATE FIGURE TITLE
    if ~isempty(myNetwork.FileName)
        str = strrep(myNetwork.FileName, ' - ', '');
        if isempty(strtrim(plotTitle))
            title([plotTitle, str]);
        else
            title([plotTitle, ' - ', str]);
        end
    else
        str = getappdata(0, 'NetworkfileName');
        title(plotTitle);
    end
    set(figHandle, 'Name', ['Cell Fate Landscape - ', str], 'NumberTitle', 'off');
    
    % ADD OUTLINES
    outline(landscape);
    
    % ADD LEGENDS
    if showLegends
        labels = CellFateLandsacpe(:,1);
        empty = cellfun(@isempty, labels);
        if empty == 0
            empty = [];
        end
        labels(empty) = {'Uncharacterized'};
        legend(cellfun(@(a,b) [a, ' ( ', b, ' )'], labels, basinRatiosCell, 'un', 0), 'location', 'bestoutside');
    end
    
    % SUCCESS
    bool = 1;
catch
    % FAILURE
    bool = 0;
end

    function rectangles = treemap(data,w,h)
        %TREEMAP   Partition a rectangular area.
        %   rectangles = treemap(data,w,h) partitions the rectangle [0,0,w,h]
        %   into an array of rectangles, one for each element of the vector "data"
        %   The areas of the rectangles are proportional to the values in data and
        %   the aspect ratio of the rectangles are close to one.
        %
        %   The algorithm used is as follows. The data are sorted from largest to
        %   smallest. We then lay out a row or column along the shortest side (w or h)
        %   of the remaining rectangle. Blocks are added to this new row or column
        %   until adding a new block would worsen the average aspect ratio of the
        %   blocks in the row or column. Once this row or column is laid out, we
        %   recurse on the remaining blocks and the remaining rectangle.
        %
        %   Examples:
        %                    treemap(rand(20,1))
        %
        %                    r = treemap(1:15,1.6,1);
        %                    plotrectangles(r)
        %                    outline(r)
        %
        %
        %   Work by Joe Hicklin (https://www.mathworks.com/matlabcentral/fileexchange/17192-treemap)
        %   Copyright 2007-2013 The MathWorks, Inc.
        %
        
        % default recursion limit of 500 is for wimps.
        set(0,'RecursionLimit',5000)
        
        if (nargin == 0)
            % make up some random data
            data = abs(randn(1,80)) .^ 2;
        end
        
        % if you don't specify a rectangle, we use the unit square
        if(nargin < 2)
            w = 1;
            h = 1;
        end
        
        % this is the ratio of rectangle area to data values
        areaRatio = (w * h) / sum(data);
        
        % we lay out the date from largest to smallest
        [v,sortIndex] = sort(data,'descend');
        
        % this chooses the number of blocks in each row or column
        p = partitionArea(v,w,h);
        
        % this leaves us with the task of assigning rectangles to each element.
        
        % storage for the result
        rectangles = zeros(4,length(data));
        
        % these hold the origin for each row
        oX = 0;
        oY = 0;
        
        % the index of the first value in v for the current row
        first = 1;
        % where to put the resulting rectangles in the rectangles array
        resultIndex = 1;
        % for each row to layout...
        for i = 1:length(p)
            % which values are we placing
            last = first + p(i) - 1;
            chunk = v(first:last);
            % for the next iteration
            first = last + 1;
            
            % how much area should each block have?
            blockArea = chunk * areaRatio;
            
            % how much area must the entire column have?
            columnArea = sum(blockArea);
            
            % the origin for the blocks starts as the origin for the column
            blockX = oX;
            blockY = oY;
            
            % are we laying out a row or a column?
            if((w < h)) % a row
                % so how thick must the row be?
                columnHeight = columnArea / w;
                % lets place each value
                for j = 1:p(i)
                    % so how wide should it be?
                    blockWidth = blockArea(j) / columnHeight;
                    % remember the rectangle
                    rectangles(:,sortIndex(resultIndex)) = [blockX,blockY,blockWidth,columnHeight];
                    resultIndex = resultIndex + 1;
                    % move the origin for the nextblock
                    blockX = blockX + blockWidth;
                end
                % move the origin for the next row
                oY = oY + columnHeight;
                h = h - columnHeight;
            else % a column
                columnWidth = columnArea / h;
                % lets place each value
                for j = 1:p(i)
                    % so how high should it be?
                    blockHeight = blockArea(j) / columnWidth;
                    % if one corner is at oX,oY, where is the opposite corner?
                    rectangles(:,sortIndex(resultIndex)) = [blockX,blockY,columnWidth,blockHeight];
                    resultIndex = resultIndex + 1;
                    % move the origin for the nextblock
                    blockY = blockY  +  blockHeight;
                end
                % move the origin for the next row
                oX = oX + columnWidth;
                w = w - columnWidth;
            end
        end
        
        % show the results if they are not returned
        if(nargout == 0)
            plotRectangles(rectangles)
        end
    end

    function partition = partitionArea(v,w,h)
        % return a vector that tells us how many blocks go in each column or
        % row. Sum(partition) == length(v);
        
        % the rest of the code only wands to deal with long side and short
        % side. It is not interested in orientation (w or h)
        if(w>h)
            longSide = w;
            shortSide = h;
        else
            longSide = h;
            shortSide = w;
        end
        
        % this is the ratio of value units to associated area.
        areaRatio = (w * h) / sum(v);
        
        % we want to minimize cost
        bestAverageAspectRatio = inf;
        
        % we will return an array of integers that tell how many blocks to
        % place in each row (or column)
        partition = [];
        
        % How many blocks should go in the next column of rectangles?
        % i is our current guess. We'll keep incrementing it until aspect ratio
        % (cost) gets worse.
        for i = 1:length(v)
            columnTotal = sum(v(1:i));
            columnArea = columnTotal * areaRatio;
            columnWidth = columnArea / shortSide;
            
            % this is the cost associated with this value of i.
            sumOfAspectRatio = 0;
            % for each block in the column
            for j = 1:i
                % what is the aspect ratio
                blockArea = v(j) * areaRatio;
                blockHeight = blockArea / columnWidth;
                aspectRatio = blockHeight / columnWidth;
                if(aspectRatio < 1)
                    aspectRatio = 1 / aspectRatio;
                end
                sumOfAspectRatio = sumOfAspectRatio + aspectRatio;
            end
            
            averageAspectRatio = sumOfAspectRatio/i;
            
            % if the cost of this value of i worse than for (i-1) we are done
            % and we will use i-i blocks in this column.
            if(averageAspectRatio >= bestAverageAspectRatio)
                if(partition < i) % if we are not done yet, we recurse
                    p = partitionArea(v(i:end),shortSide,longSide - columnWidth);
                    partition = [partition,p]; %#ok<AGROW>
                end
                return
            end
            
            bestAverageAspectRatio = averageAspectRatio;
            partition = i;
        end
        
    end

    function [textObj, patchObj] = plotRectangles(rectangles,labels,colors)
        %PLOTRECTANGLES  Create patches to display rectangles
        %   plotRectangles(rectangles,labels,colors)
        %   rectangles is a 4-by-N matrix where each column is a rectangle in
        %   the form [x0,y0,w,h]. x0 and y0 are the coordinates of the lower
        %   left-most point in the rectangle.
        %
        %   Example:
        %    cla
        %    plotRectangles([0 0 1 1; 1 0 1 1; 0 1 2 1]')
        %
        %   Copyright 2007-2013 The MathWorks, Inc.
        %
        %   See also OUTLINE.
        
        if(nargin < 2)
            labels = [];
        end
        
        if(nargin < 3)
            colors = rand(size(rectangles,2),3).^0.5;
        end
        
        % make a patch for each rectangle
        
        textObj = gobjects(size(rectangles,2), 1);
        patchObj = gobjects(size(rectangles,2), 1);
        
        for i = 1:size(rectangles,2)
            r = rectangles(:,i);
            xPoints = [r(1), r(1), r(1) + r(3),r(1) + r(3)];
            yPoints = [r(2), r(2)+ r(4), r(2)+ r(4),r(2)];
            patchObj(i) = patch(xPoints, yPoints, colors(i,:),'EdgeColor','none');
            if(~isempty(labels))
                textObj(i) = text(r(1) + r(3)/2,r(2) + r(4)/2, 1, labels{i}, ...
                    'VerticalAlignment','middle','HorizontalAlignment','center');
            end
        end
        
        axis equal
        axis tight
        axis off
        
    end

    function outline(rectangles)
        %OUTLINE  Outline in black all the rectangles
        %   outline(rectangles)
        %   rectangles is a 4-by-N matrix where each column is a rectangle in
        %   the form [x0,y0,w,h]. x0 and y0 are the coordinates of the lower
        %   left-most point in the rectangle.
        %
        %   Example:
        %    cla
        %    outline([0 0 1 1; 1 0 1 1; 0 1 2 1]')
        %
        %   Copyright 2007-2013 The MathWorks, Inc.
        %
        %   See also PLOTRECTANGLES.
        
        for i = 1:size(rectangles,2)
            r = rectangles(:,i);
            xPoints = [r(1),      r(1), r(1)+r(3), r(1)+r(3)];
            yPoints = [r(2), r(2)+r(4), r(2)+r(4), r(2)     ];
            patch(xPoints,yPoints,[0 0 0],'FaceColor','none')
        end
        
    end

end