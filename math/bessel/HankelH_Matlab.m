% =========================================================================
% INTRO
%   - Calculate the Hankel function using the built in 
%       function 'besselh'
% INPUT
%   - n: order
%   - z: argument
% =========================================================================
function H = HankelH_Matlab(n, z, varargin)
    validateattributes(n, {'numeric'}, {'size', [nan,1]});
    validateattributes(z, {'numeric'}, {'size', [1,nan,nan,nan,nan,nan,nan]});

    ip = inputParser;
    ip.addParameter('scaled', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.addParameter('kind', 1, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;
    ip.scaled = double(ip.scaled);

    [n_unique, ~, idx_n_unique] = unique(n);
    z_row = z(:).';
    [z_row_unique, ~, idx_z_unique] = unique(z_row);  

    H = n_unique .* z_row_unique .* 0;

    if numel(n_unique) < numel(z_row_unique)
        for i = 1:length(n_unique)
            H(i,:) = besselh(n_unique(i), ip.kind, z_row_unique, ip.scaled);
        end
    else
        for i = 1:length(z_row_unique)
            H(:,i) = besselh(n_unique, ip.kind, z_row_unique(i), ip.scaled);
        end
    end
    H = H(idx_n_unique, idx_z_unique);
    H = reshape(H, size(n.*z));
end
