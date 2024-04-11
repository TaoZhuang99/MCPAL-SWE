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

function j = SphBesselJ(n, z, varargin)

    validateattributes(n, {'numeric'}, {'>=', 0});

    CheckDim('preceeding', n, z);

    ip = inputParser;
%     ip.addParameter('z_large', 1e3);
    ip.addParameter('is_log', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    j = SphBesselJLog(n, z);
    if ~ip.is_log
        j = exp(j);
    end
end

