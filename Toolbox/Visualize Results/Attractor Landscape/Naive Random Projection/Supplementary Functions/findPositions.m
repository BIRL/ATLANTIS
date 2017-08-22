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

function [x , y] = findPositions(r, c, positionsNeeded, stateSpaceLen)
% FINDS ROWS AND COLUMNS OF NEAR BY INDICIES

dx = 1; 
dy = 1;
x = zeros(positionsNeeded, 1);
y = zeros(positionsNeeded, 1);
positionsFound = 2;
count = 1;

while positionsFound <= positionsNeeded
    populateXY(0, dy);
    if positionsFound > positionsNeeded
        break;
    end
    populateXY(dx, 0);
    count = count + 1;
    dx = -dx;
    dy = -dy;
end

x = x + r;
y = y + c;

% hold on
% scatter(x, y, 'r');

% REMOVE POINTS OUT OF RANGE
invalidIndicies = x <= 0;
x(invalidIndicies) = [];
y(invalidIndicies) = [];
invalidIndicies = y <= 0;
x(invalidIndicies) = [];
y(invalidIndicies) = [];

invalidIndicies = x > stateSpaceLen;
x(invalidIndicies) = [];
y(invalidIndicies) = [];
invalidIndicies = y > stateSpaceLen;
x(invalidIndicies) = [];
y(invalidIndicies) = [];

% REMOVE THE CENTER POINT
x(1) = [];
y(1) = [];

% scatter(x, y);

    function populateXY(dx, dy)
        for j = 1 : count
            x(positionsFound) = x(positionsFound-1) + dx;
            y(positionsFound) = y(positionsFound-1) + dy;
            positionsFound = positionsFound + 1;
            if positionsFound > positionsNeeded
                break;
            end
        end
    end
end

