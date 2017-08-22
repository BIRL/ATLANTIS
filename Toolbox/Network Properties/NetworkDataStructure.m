%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ATLANTIS: Attractor Landscape Analysis Toolbox for        %
%              Cell Fate Discovery and Reprogramming               %
%                           Version 1.0.0                          %
%     Copyright (c) Biomedical Informatics Research Laboratory,    %
%      Lahore University of Management Sciences Lahore (LUMS),     %
%                            Pakistan.                             %
%                 http://biolabs.lums.edu.pk/birl)                 %
%                     (safee.ullah@gmail.com)                      %
%                  Last Modified on: 09-August-2017                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef NetworkDataStructure < matlab.mixin.Copyable
    
    properties (SetAccess = public)
        
        %>>>>>>>>>>>>>>>>>>>>    Method Variables    <<<<<<<<<<<<<<<<<<<<<%
        
        %-----------------------1. General variables----------------------%
        
        NodeCount; % Total genes/proteins in the network %
        NodeNames;
        EdgeWeights; % weights for interactions between different
        %.. proteins/nodes in the network %
        BasalValues; % basal expression of the nodes decides if the node
        %.. will be on or off in absense of indegree nodes
        NetworkStateList;
        Results;
        FileName;
        ResultFolderName;
        NetworkType;
        NetworkBackUp;
        CharacterizedNetworkStateList;
        InteractionMatrix;
        DotFileInfo;
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        
        %---------2. Variables to be used in Probabilistic analysis-------%
        
        Noise; % Increasing noise increases the perturbation intensity
        %.. in probabilistic analysis %
        DegradationConstant; % determines the degradation rate of
        %.. a node i.e the probility decay %
        TimeSteps; % determines how many times will the master eq
        %.. run %
        SteadyStateTimeStep; % Iteration step at which steady state was
        %.. reached %
        StateTransitionProbabilities;
        SteadyStateProbabilities;
        PotentialEnergies;
        Trajectory;
        TrajectoryBounds;
        SteadyStatePrecision;
        MapTrajectory;
        AttractorLandscapePlottingOptions
        AssociatedCellFates;
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        
        %--------3. Variables to be used in Deterministic analysis -------%
        
        SteadyStates;     % stores steady states found from deterministic
                          %.. analysis %
        AttractorTypes;  % stores the attractor types for the corresponding
                         %.. steady states %
        SearchFor; % stores information on which attractor to search for
        AttractorSearchDuration; % Defines the number of times a state will 
                                 % be updated
        AttractorTable;        
        SourceNodesNames; % Stores names of all the input nodes
        SourceNodeIndices; % Stores source node indicies
        TargetNodeNames; % Stores names of all the output nodes
        TargetNodeIndices; % Stores target node indicies
        NodeUpdateLogic; % Stores the logic table outputs for all target nodes
        MutationInfo; % First column = Nodes, Second column = mutation value                    
        AttractorList; % stores all the attractors
        AttractorSummaryInFraction; % Stores the summarized information of node activities for each attractor
        AttractorSummaryAsWhole;
        CellFateDeterminationLogic; % Stores the logic to associate Attractors with cell fates
        UniqueCellFates;
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        
        %--------4. Visualization Cell fate characterization variables -------%
        
        CellFateLandscape; % Stores all the cell fates inferred from the attractor landscape and their propensities
        MappingResults;
        OutputNodes;
        OutputNodesIndices;
        CellFateLandscapePlottingOptions;
        RandomIndicies;
        ModifiedStateSpace;
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        
        %<<<<<<<<<<<<<<<<<<<<<<       END       >>>>>>>>>>>>>>>>>>>>>>>>>>%
        
    end
    
end