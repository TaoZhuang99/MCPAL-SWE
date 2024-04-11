% =========================================================================
% INTRO
%   - Calculate the radial component for a baffled circular source using
%       the spherical wave expansion method
% -------------------------------------------------------------------------
% INPUT
%   - M: maximum order
%   - k: wavenumber
%   - a: half-width (radius)
%   - rho: the polar coordinates
% -------------------------------------------------------------------------
% OUTPUT
%   - R: the radial component 
%   - R_prime: the derivative of the radial component
% -------------------------------------------------------------------------
% DIMENSION
%   - 1: r
%   - 2: 1 (holder for theta)
%   - 3: 1 (holder for phi)
%   - 4: order l
%   - 5: integration
% =========================================================================
function [R, R_prime] = CircSrc_SWE_Radial(src, r, max_order, varargin)

    ip = inputParser;
    ip.addParameter('int_num', 2e2);
    % ip.addParameter('profile', 'uniform', @(x)any(validatestring(x, {'uniform', 'steerable'})));
    % ip.addParameter('focus_dist', 0.2);
    % ip.addParameter('steer_angle', [pi/4;pi/2]);
    % ip.addParameter('is_farfield', 0);
    % ip.addParameter('is_discrete', 0);
    % ip.addParameter('discrete_size', 0.01);
    % ip.addParameter('is_effective', 0);
    % ip.addParameter('effective_size', 0.01);
    ip.addParameter('is_cal_prime', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    % ip.addParameter('array', []);
    % normalization 
    parse(ip, varargin{:});
    ip = ip.Results;

    a = src.radius;

    ell = permute((0:max_order).', [4, 2, 3, 1]);

    % origin points
    idx_origin = r == 0;
    r_origin = r(idx_origin);
    % interior points
    idx_int = (r > 0) & (r < a);
    r_int = r(idx_int);
    % exterior points
    idx_ext = r >= a;
    r_ext = r(idx_ext);   

    % store radial component
    R = 0 * r .* ell;

    %% process origin points
    if ~isempty(r_origin)
        % dim: l => r_origin
        int = CircSrc_SWE_Int(src, 2*ell(:)+abs(src.prf.azimuth_order), 'h', 0, a, r_origin.');
        R(idx_origin, 1, 1, :) = permute(permute(int, [4, 2, 3, 1]), [2, 1, 3, 4]);
    end

    %% process interior points
    if ~isempty(r_int)
        % dim: m => rho_origin
        int = CircSrc_SWE_Int(src, 2*ell(:)+abs(src.prf.azimuth_order), 'j', 0, r_int.', r_int.') ...
            + CircSrc_SWE_Int(src, 2*ell(:)+abs(src.prf.azimuth_order), 'h', r_int.', a, r_int.');
        R(idx_int, 1, 1, :) = permute(permute(int, [4, 2, 3, 1]), [2, 1, 3, 4]);
    end

    %% process exterior points
    if ~isempty(r_ext)
        % dim: m => r_origin
        int = CircSrc_SWE_Int(src, 2*ell(:)+abs(src.prf.azimuth_order), 'j', 0, a, r_ext.');
        R(idx_ext, 1, 1, :) = permute(permute(int, [4, 2, 3, 1]), [2, 1, 3, 4]);
    end

    R_prime = nan;
end
