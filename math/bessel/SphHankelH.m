% =========================================================================
% INTRO
%   - spherical Hankel function of first kind
% INPUT
%   - n: order
% DIMENSION
%   - n before z
% =========================================================================

function h = SphHankelH(n, z, varargin)

    validateattributes(n, {'numeric'}, {'>=', 0});

    CheckDim('preceeding', n, z);

    ip = inputParser;
%     ip.addParameter('z_large', 1e3);
    ip.addParameter('is_log', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    % 1 and 2
    ip.addParameter('kind', 1, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    h = SphHankelHLog(n, z);
    if ~ip.is_log
        h = exp(h);
    end
end

