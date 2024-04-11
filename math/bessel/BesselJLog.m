% =========================================================================
% INTRO
%   - The Log of Bessel function of first kind
% INPUT
%   - n: order
% =========================================================================

function J = BesselJLog(n, z, varargin)

    ip = inputParser;
    ip.addParameter('z_large', 1e3);
    ip.addParameter('nu0', 0, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 0, '<', 1}));
    ip.parse(varargin{:});
    ip = ip.Results;

    N = max(abs(n));

    n_full = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    J = 0 * n_full .* z_row;

    idx_z_large = abs(z_row) > ip.z_large;
    idx_z_small = abs(z_row) <= ip.z_large;
    z_small = z_row(idx_z_small);
    z_large = z_row(idx_z_large);

    if sum(idx_z_small(:)) > 0
        J(:,idx_z_small) = BesselJLog_Rothwell(N, z_small, 'nu0', ip.nu0);
    end
    if sum(idx_z_large(:)) > 0
        J(:,idx_z_large) = BesselJ_Asym(n_full+ip.nu0, z_large, ...
            'approx_order', N+5, 'is_log', true);
    end
    
    J(1, z_row==0) = log(1);
    J(2:end, z_row==0) = log(0);
    J = J(abs(n)+1,:);
    if ~isempty(n(n<0))
        J(n<0,:) = J(n<0, :) + log(-1) .* n(n<0);
    end

    J = J(:, idx_z_row);
    J = reshape(J, size(n .* z));
end

