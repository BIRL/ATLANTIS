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

function bool = classify_Attractors(obj)

try
    % GET CELL FATE LOGIC
    cellFateDeterminationLogic = obj.CellFateDeterminationLogic;
    
    % GENERATE ATTRACTOR LIST
    uniqueAttractors = obj.AttractorTable(:,1);
    partialAttractorList = cellfun(@(a) a(:, obj.OutputNodesIndices),...
        uniqueAttractors, 'un', 0);
    
    % SET UPPER AND LOWER BOUND OF AVERAGE NODE ACTIVITY THAT WILL BE CLASSIFIED
    % AS CYCLIC ATTRACTOR
    upperbound = 0.2;
    lowerbound = 0.2;
    
    % SUMMARIZE ATTRACTOR STATE AVCTIVITY
    [attractorSummaryInFraction, attractorSummaryAsWhole] = ...
        cellfun(@(a)summarize_AttractorActivity (a, upperbound, ...
        lowerbound), partialAttractorList, 'un', 0);
    
    % FIND CELL FATES CORRESPONDING TO EACH ATTRACTORS
    associatedCellFates = cellfun(@(attr) associate_CellFates...
        (cellFateDeterminationLogic, attr,  numel(obj.UniqueCellFates)), ...
        attractorSummaryAsWhole);
    
    % CREATE ATTRACTOR TABLE
    attractorTable = obj.AttractorTable(:, 1:3);
    attractorTable = horzcat(attractorTable, associatedCellFates);
    
    % FIND UNIQUE ASSOCIATED CELL FATES
    [uniqueAssociatedCellFates , ~, ~] = unique(associatedCellFates);
    
    % FIND FREQUENCY OF EACH FATE
    fatePropensities = cell(numel(uniqueAssociatedCellFates), 1);
    
    for i = 1:numel(fatePropensities)
        fatePropensities{i}  = sum([attractorTable{ismember...
            (associatedCellFates, uniqueAssociatedCellFates(i)), 3}], 2);
    end
    
    % CREATE CELL FATE LANDSCAPE
    cellFateLandscape        = cell(numel(uniqueAssociatedCellFates), 2);
    cellFateLandscape(:,1)   = uniqueAssociatedCellFates;
    cellFateLandscape(:,2)   = fatePropensities;
    
    % UPDATE NETWORK PROPERTIES
    obj.AttractorSummaryInFraction = attractorSummaryInFraction;
    obj.AttractorSummaryAsWhole    = attractorSummaryAsWhole;
    obj.AttractorTable             = attractorTable;
    obj.CellFateLandscape          = flipud(sortCellArr(cellFateLandscape, 2));
    
    % SUCCESS
    bool = 1;
    
catch
    bool = 0;
end

end