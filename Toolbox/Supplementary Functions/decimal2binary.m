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

function binVec = decimal2binary( dVec, n )
    % Converts a vector 'dVec' containing decimal numbers to its binary 
    % equivalent of length 'n'. 
    % e.g. dVec = [5 ; 1];
    % decimal2binary(binVec, 3);
    % Result = [1 0 1 ; 0 0 1];
    
    row = zeros(1, n);
    binVec = zeros(size(dVec, 1), n);

    for i = 1:size(dVec, 1)
        val = dVec(i);
        for j = 1:n
            r = floor(val / 2);
            row(n+1-j) = val - 2*r;
            val = r;
        end
        binVec(i, :) = row;
    end
    
end