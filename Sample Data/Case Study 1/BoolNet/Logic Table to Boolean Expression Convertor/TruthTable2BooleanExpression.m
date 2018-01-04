%% -----------  Truth Table to Boolean expression generator  ----------- %%

path = 'Node Truth Tables\';
data = dir(fullfile(path, '*.txt'));

logicFiles = {data.name};

% Create a file
fid = fopen('Yeast Cell Cycle Network BoolNet Input.txt','w');

fprintf(fid, 'targets,factors\n');

for i = 1:numel(logicFiles);
    
    % IMPORTING LOGIC FILE
    logicFileInfo = importdata(strcat(path, logicFiles{i}));
    % EXTRACTING NODES
    nodes = lower(logicFileInfo.textdata);
    parentNodes = nodes(1:end-1);
    childNode = nodes(end);
    % EXTRACTING NODE UPDATE LOGIC
    logicTable = logicFileInfo.data;
    % FIND ROWS IN THE CHILDNODE STATE OUTPUT IS == 1
    outputOn = logicTable(:, end) == 1;
    truthTable = logicTable(outputOn, :);
    % INITIATING BOOLEAN EXP STRING
    LogicalExpression = [childNode ', '];
    
    if ~isempty(truthTable) % IF TRUTH TABLE IS NOT EMPTY
        for j = 1:size(truthTable, 1) % FOR EACH ROW OF THE TRUTH TABLE
            % TEMP VARAIBLE TO STORE LOGICAL EXPRESSION CORRESPONDING TO EACH
            % ROW OF TRUTH TABLE
            tempExp = ' (';
            parentNodeStates = truthTable( j, 1:end-1 );            
            for node = 1 : numel(parentNodes) % FOR EACH PARENT NODE (INPUT NODE)
                if ( parentNodeStates(node) == 0 )
                    % ADD "!" BEFORE THE NAME OF THE INPUT NODE WHICH IS INACTIVE
                    tempExp = [tempExp, ' ! ', parentNodes{node}];
                elseif ( parentNodeStates(node) == 1 )
                    % ADD ONLY THE NAME OF THE INPUT NODE WHICH IS ACTIVE
                    tempExp = [tempExp, parentNodes{node}];
                end
                % ADD & BETWEEN TWO BOOL EXPRESSIONS
                if  node ~= numel(parentNodes)
                    tempExp = [tempExp, ' & '];
                end
            end
            % END OF LOGICAL EXPRESSION
            tempExp = [tempExp, ') ' ];
            % ADD | CHARACTER UNTIL J IS THE LAST ROW OF TRUTH TABLE
            if j < size(truthTable, 1)
                tempExp = [tempExp, ' | '];
            end
            % ADD tempExp TO LogicalExpression VAR
            LogicalExpression = [LogicalExpression, tempExp];
        end
    else
        % IF NO ACTIVATORY SIGNAL
        LogicalExpression = [LogicalExpression, '0'];
    end
    
    LogicalExpression = strjoin(LogicalExpression, ' ');
    if i < numel(logicFiles)
        LogicalExpression = [LogicalExpression, '\n'];
    end
    fprintf(fid, LogicalExpression);
end
fprintf(fid, '\n');
fclose(fid);
% clear