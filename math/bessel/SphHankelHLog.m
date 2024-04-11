% =========================================================================
% INTRO
%   - The Log of Bessel function of first kind
% INPUT
%   - n: order
% DIMENSION
%   - n before z
% =========================================================================

function h = SphHankelHLog(n, z, varargin)

    validateattributes(n, {'numeric'}, {'>=', 0});

    ip = inputParser;
%     ip.addParameter('z_large', 1e3);
    ip.parse(varargin{:});
    ip = ip.Results;

    N = max(abs(n));

    n_full = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    h = HankelHLog(n_full, z_row, 'nu0', .5) + 1/2 .* log(pi./2./z_row);

%     h(1,z_row==0) = log(1);
%     h(2:end, z_row == 0) = log(0);

    h = h(n+1,:);

    h = h(:, idx_z_row);
    h = reshape(h, size(n .* z));
end

