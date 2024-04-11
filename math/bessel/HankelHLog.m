% =========================================================================
% INTRO
%   - The Log of Hankel function of first kind
% INPUT
%   - n: order
% =========================================================================

function H = HankelHLog(n, z, varargin)

    validateattributes(n, {'numeric'}, {'size', [nan, 1]});
    
    ip = inputParser;
    ip.addParameter('z_large', 1e3);
    ip.addParameter('nu0', 0, @(x)validateattributes(x, {'numeric'}, ...
        {'scalar', '>=', 0, '<', 1}));   
    ip.addParameter('kind', 1, ...
        @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 1, '<=', 2}));
    ip.parse(varargin{:});
    ip = ip.Results;

    N = max(abs(n));

    n_full = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    H = 0 * n_full .* z_row;

    idx_z_large = abs(z_row) > ip.z_large;
    idx_z_small = abs(z_row) <= ip.z_large;
    z_small = z_row(idx_z_small);
    z_large = z_row(idx_z_large);

    if sum(idx_z_small(:)) > 0
        H(:,idx_z_small) = HankelHLog_Rothwell(N, z_small, 'nu0', ip.nu0, ...
            'kind', ip.kind);
    end
    if sum(idx_z_large(:)) > 0
        H(:,idx_z_large) = HankelH_Asym(n_full+ip.nu0, z_large, ...
            'approx_order', N+5, 'is_log', true, 'kind', ip.kind);
    end
    
    H = H(:, idx_z_row);
    H = H(abs(n)+1, :);
    if ~isempty(n(n<0))
        H(n<0,:) = H(n<0, :) + log(-1) .* n(n<0);
    end
    H = reshape(H, size(n .* z));
end

