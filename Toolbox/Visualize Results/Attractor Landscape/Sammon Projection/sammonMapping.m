function [y, E] = sammonMapping(x, n, opts)
% Copyright   : (c) Dr Gavin C. Cawley, November 2007.

% PROGRESSBAR
progressbar('Projecting State Space Using Sammon Mapping...');

% use the default options structure
if nargin < 3
    opts.Display        = 'NOiter';
    opts.Input          = 'raw';
    opts.MaxHalves      = 40;
    opts.MaxIter        = 500;
    opts.TolFun         = 1e-9;
    opts.Initialisation = 'pca';
    
end

% the user has requested the default options structure
if nargin == 0
    y = opts;
    return;
end

% Create a two-dimensional map unless dimension is specified
if nargin < 2
    n = 2;
end

% Set level of verbosity
if strcmp(opts.Display, 'iter')
    display = 2;
elseif strcmp(opts.Display, 'on')
    display = 1;
else
    display = 0;
end

% Create distance matrix unless given by parameters
if strcmp(opts.Input, 'distance')
    D = x;
else
    D = euclid(x, x);
end

% Remaining initialisation
N     = size(x, 1);
scale = 0.5 / sum(D(:));
D     = D + eye(N);
Dinv  = 1 ./ D;
if strcmp(opts.Initialisation, 'pca')
    [UU,DD] = svd(x);
    y       = UU(:,1:n)*DD(1:n,1:n);
else
    y = randn(N, n);
end
one   = ones(N,n);
d     = euclid(y,y) + eye(N);
dinv  = 1./d;
delta = D - d;
E     = sum(sum((delta.^2).*Dinv));

% Get on with it
for i=1:opts.MaxIter
    
    progressbar(i/opts.MaxIter);
    
    % Compute gradient, Hessian and search direction (note it is actually
    % 1/4 of the gradient and Hessian, but the step size is just the ratio
    % of the gradient and the diagonal of the Hessian so it doesn't
    % matter).
    delta    = dinv - Dinv;
    deltaone = delta * one;
    g        = delta * y - y .* deltaone;
    dinv3    = dinv .^ 3;
    y2       = y .^ 2;
    H        = dinv3 * y2 - deltaone - 2 * y .* (dinv3 * y) + y2 .* (dinv3 * one);
    s        = -g(:) ./ abs(H(:));
    y_old    = y;
    
    % Use step-halving procedure to ensure progress is made
    for j=1:opts.MaxHalves
        y(:) = y_old(:) + s;
        d     = euclid(y, y) + eye(N);
        dinv  = 1 ./ d;
        delta = D - d;
        E_new = sum(sum((delta .^ 2) .* Dinv));
        if E_new < E
            break;
        else
            s = 0.5*s;
        end
    end
    
    % Bomb out if too many halving steps are required
    if j == opts.MaxHalves
        warning('MaxHalves exceeded. Sammon mapping may not converge...');
    end
    
    % Evaluate termination criterion
    if abs((E - E_new) / E) < opts.TolFun
        if display
            fprintf(1, 'Optimisation terminated - TolFun exceeded.\n');
        end
        progressbar(1);
        break;
    end
    
    % Report progress
    E = E_new;
    if display > 1
        fprintf(1, 'epoch = %d : E = %12.10f\n', i, E * scale);
    end
end

% Fiddle stress to match the original Sammon paper
E = E * scale;

    function d = euclid(x, y)
        d = sqrt(sum(x.^2,2)*ones(1,size(y,1))+ones(size(x,1),1)*sum(y.^2,2)'-2*(x*y'));
    end
end