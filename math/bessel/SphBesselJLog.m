% =========================================================================
% INTRO
%   - Log of the spherical Bessel function of first kind
% -------------------------------------------------------------------------
% INPUT
%   - n: order
% -------------------------------------------------------------------------
% DIMENSION
%   - n before z
% =========================================================================

function [j, j_prime] = SphBesselJLog(n, z, varargin)

    validateattributes(n, {'numeric'}, {'>=', 0});

    ip = inputParser;
%     ip.addParameter('z_large', 1e3);
    % ip.addParameter('is_log', false, 
    ip.addParameter('is_cal_derivative', false, ...
        @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    N = max(abs(n));

    n_full = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    j = BesselJLog(n_full, z_row, 'nu0', .5) + 1/2 .* log(pi./2./z_row);

    j(1,z_row==0) = log(1);
    j(2:end, z_row == 0) = log(0);

    j = j(n+1,:);

    j = j(:, idx_z_row);
    j = reshape(j, size(n .* z));
end

