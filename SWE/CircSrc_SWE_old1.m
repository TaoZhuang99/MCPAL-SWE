% =========================================================================
% - Calculate the sound radiation from a circular piston using the 
%	spherical wave expansion (SWE) method
% - Modified based on CircSrc_SWE_220303A.m
% -------------------------------------------------------------------------
% INPUT
%   - src: source info
%   - fp: field points
% DIMENSION
%   - 1: fp.r
%   - 2: fp.theta
%   - 3: fp.phi
%   - 4: order
% =========================================================================
function prs = CircSrc_SWE(src, fp, varargin)

    validateattributes(fp.r, {'numeric'}, {'column', '>=', 0});
    validateattributes(fp.theta, {'numeric'}, {'row', '>=', 0, '<=', pi});
    validateattributes(fp.phi, {'numeric'}, {'size', [1, 1, nan]});

    k = src.wav.num;
    a = src.radius;

	ip = inputParser;
	% Maximum truncated terms of the spherical harmonics
	ip.addParameter('max_order', round(real(k) * a)*2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 0}));
    % ip.addParameter('is_cal_velocity', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
	ip.parse(varargin{:});
	ip = ip.Results;

%     prs = 0 * fp.r .* fp.theta .* fp.phi;
    vel = VectorField();
    l = permute((0:ip.max_order).', [4, 2, 3, 1]);
    if isfield(src.prf, 'azimuth_order')
        m = src.prf.azimuth_order;
    else
        m = 0;
    end

    R = CircSrc_SWE_Radial(ip.max_order, src, fp.r);
    % dim: l -> 1 -> fp.theta -> fp.phi
    Y = SphHarmonic(2*l(:)+abs(m), m, ...
        permute(fp.theta, [1, 3, 2]), permute(fp.phi, [1, 2, 4, 3])) ...
        .* SphHarmonic(2*l(:)+abs(m), m, pi/2, 0);
    Y = permute(permute(permute(Y, [4, 2, 3, 1]), [1, 3, 2, 4]), [3, 2, 1, 4]);

    prs = 4*pi*sum(R .* Y, 4);

    % lag = 1.21 / 2 * (abs(vel_r).^2 + abs(vel_theta).^2) - abs(prs).^2 / (2*1.21*343^2);
end
