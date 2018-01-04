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

classdef NetworkDataStructure < matlab.mixin.Copyable
    
    properties (SetAccess = public)
        
        %>>>>>>>>>>>>>>>>>>>>    Method Variables    <<<<<<<<<<<<<<<<<<<<<%
        
        %#   1. General variables
        
        NodeCount; % TOTAL GENES/PROTEINS IN THE NETWORK
        NodeNames; % NAMES OF GENES/PROTEINS IN THE NETWORK 
        EdgeWeights; % STORES INFORMATION ON THE INTERACTIONS B/W NODES
        BasalValues; % BASAL EXPRESSION OF THE NODES
        NetworkStateList; % INITIAL NETWORK STATE LIST
        FileName; % MUTATION FILE NAMES
        ResultFolderName; % SAVES RESULT FOLDER NAME
        NetworkType; % NETWORK TIME: "RULES BASED" OR "WEIGHTS BASED"
        NetworkBackUp; % STORES NETWORK BACKUP
        Time;
        InteractionMatrix;
        DotFileInfo;
        

        %#   2. Variables to be used in Probabilistic analysis
        
        Noise; % PERTURBATION FACTOR
        DegradationConstant; % NODE SELF DEGRADATION RATE
        TimeSteps; % MAX NUMBER OF ITERATIONS FOR WHICH MASTER EQUATION WILL RUN
        SteadyStateTimeStep; % ITERATION AT WHICH STEADY STATES WERE REACHED
        StateTransitionProbabilities; % STORES STATE TRANSITION PROBABILITY MATRIX
        SteadyStateProbabilities; % STORES THE COMPUTED STEADY STATE PROBABILITES
        Trajectory; 
        TrajectoryBounds;
        ErrorThreshold;
        MapTrajectory;
        AttractorLandscapePlottingOptions
        AssociatedCellFates;
        StateSpacePA;
        PrunnedStateSpacePA;
        PruneStateSpace;
        
        
        %#    3. Variables to be used in Deterministic analysis  
        
        SteadyStates;     % stores steady states found from deterministic
        AttractorTypes;  % stores the attractor types for the corresponding
        SearchFor; % stores information on which attractor to search for
        AttractorSearchDuration; % Defines the number of times a state will 
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
        TruthTables;
        
        
        %#   4.  Visualization Cell fate characterization variables
        
        CellFateLandscape; % Stores all the cell fates inferred from the attractor landscape and their propensities
        MappingResults;
        OutputNodes;
        OutputNodesIndices;
        CellFateLandscapePlottingOptions;
        RandomIndicies;
        ModifiedStateSpace;
        

        %<<<<<<<<<<<<<<<<<<<<<<       END       >>>>>>>>>>>>>>>>>>>>>>>>>>%
        
    end
    
end