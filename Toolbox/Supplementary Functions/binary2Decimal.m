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

function decVec = binary2Decimal( binVec )
    % Converts a vector containing binary numbers to its corresponding
    % values in decimal. The input argument should be a matrix with
    % each row representing patterns and each column representing
    % variables
    % e.g. binVec = [1 0 1 ; 0 0 1];
    % binary2Decimal( binVec );
    % Result = [5 ; 1];
    
    decVec = binVec*(2.^(size(binVec,2)-1:-1:0))';
end