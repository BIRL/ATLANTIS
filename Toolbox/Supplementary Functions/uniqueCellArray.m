function [AA, AI, BI] = uniqueCellArray(A)
% Finds unique strings in cell array containing strings
% By  Jan Simon on 19 Aug 2012 at Mathworks

nA = numel(A);
if nA > 1
    [As, SV] = sort(A(:));
    if nargout < 3
        UV(SV)  = [1; strcmp(As(2:nA), As(1:nA - 1)) == 0];
        AI      = find(UV);
    else  % Indices requested:
        UV      = [1; strcmp(As(2:nA), As(1:nA - 1)) == 0];
        UVs(SV) = UV;
        AI      = find(UVs);
        % Complex creation of BI so that AA(BI) == A:
        v      = zeros(1, nA);
        v(AI)  = 1:length(AI);    % Sequence related to AA
        vs     = v(SV);           % Sorted like A
        vf     = vs(find(vs));    %#ok<FNDSB> % Just the filled entries
        BI(SV) = vf(cumsum(UV));  % Inflate multiple elements
    end
elseif nA  % Comparison of subsequent elements fails for nA == 1
    AI = 1;
    BI = 1;
else
    AI = [];
    BI = [];
end
AA = A(AI);

end