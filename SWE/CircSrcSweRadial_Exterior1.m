% =========================================================================
% INTRO
%   - Calculate the radial component in the exterior region for a circular
%       source
% -------------------------------------------------------------------------
% INPUT
%   - k, the wavenumber
%   - a, the radius of the radiator
%   - max_l, the maximum order for the spherical Bessel functions
% -------------------------------------------------------------------------
% DIMENSION
%   l -> integration
% =========================================================================
function R = CircSrcSweRadial_Exterior1(...
    k, a, max_l,  varargin)
    
    validateattributes(k, {'numeric'}, {'scalar'});
    validateattributes(a, {'numeric'}, {'scalar', '>=', 0});
    validateattributes(max_l, {'numeric'}, {'scalar', '>=', 0});

    ip = inputParser();
    ip.addParameter('gauss_num', 2e2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
    ip.parse(varargin{:});
    ip = ip.Results;

    % gauss
    [rs, weight] = GaussLegendreQuadParam(...
        ip.gauss_num, 0, a);
    % 1, gauss
    rs = permute(rs, [2,1]);
    weight = permute(weight, [2,1]);

    % l, gauss
    [j, j_exp] = SphBesselJ(2*max_l, k*rs);
    jj = j .* 10.^(j_exp);

    R = sum(jj(1:2:end,:) .* weight .* rs .* k^2, 2);
end
