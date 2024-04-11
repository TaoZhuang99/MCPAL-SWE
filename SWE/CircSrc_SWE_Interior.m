% =========================================================================
% - Calculate the sound radiation from a circular piston using the 
%	spherical wave expansion (SWE) method
% - The field point is located in the interior region
% - Dimension: theta => r => order 
% - Modified from CircPiston_SWE_Interior_211226D.m
% -------------------------------------------------------------------------
% INPUT
% - k       the wavenumber
% - a       the radius of the piston
% - r       the radius of the field points
% - theta   the zenith angle of the field point
% =========================================================================
function [prs, vel_r, vel_theta, prs_n, vel_r_n, vel_theta_n] = ...
    CircSrc_SWE_Interior(...
    k, ...
    a, ...
    r, ...
    theta, ...
    varargin)

    validateattributes(k, {'numeric'}, {'scalar'});
    validateattributes(a, {'numeric'}, {'scalar'});
    validateattributes(r, {'numeric'}, {'row', '<=', a, '>=', 0});
    validateattributes(theta, {'numeric'}, {'column', '>=', 0, '<=', pi});
    IsCompatibleSize(r, theta);

	ip = inputParser;
	% Maximum truncated terms of the spherical harmonics
	ip.addParameter('max_order', round(real(k) * a)*2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 0}));
    ip.addParameter('is_cal_velocity', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.addParameter('is_focus', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.addParameter('focal_len', nan, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
	ip.parse(varargin{:});
	ip = ip.Results;
    
    n = permute((0:ip.max_order).', [3,2,1]);

    C_n = (-1).^n.* (4*n+1) / sqrt(pi) ...
        .* exp(gammaln(n+1/2)-gammaln(n+1));

    leg_2n = permute(...
    LegendrePolynomial_211130B(...
        2 * max(n), ...
        cos(permute(theta, [3,2,1]))), ...
        [3,2,1]);
    leg_2n = leg_2n(:, :, 1:2:end);
    % R_2n = IntType2_jh_211129O(...
        % 2 * n, ...
        % k * r, ...
        % 0, ...
        % k * r) ...
        % + IntType1_jh_211129N(...
        % 2 * n, ...
        % k * r, ...
        % k * r, ...
        % k * a);
    % jh = SphBessel_h_int_j_211226G(...
    jh = SphBessel_h_int_j_220301B(...
        2 * ip.max_order, ...
        k * r, ...
        0, ...
        k * r, ...
        'is_focus', ip.is_focus, ...
        'focal_len', k * ip.focal_len);
    jh(:,r == 0,:) = 0;
    % hj = SphBessel_j_int_h_211226H(...
    hj = SphBessel_j_int_h_220301C(...
        2 * ip.max_order, ...
        k * r, ...
        k * r , ...
        k * a, ...
        'is_focus', ip.is_focus, ...
        'focal_len', k * ip.focal_len);
    R_2n = permute(jh(1:2:end, :, :) + hj(1:2:end, :, :), [3,2,1]);

    prs_n = 1.21 * 343 * C_n.*R_2n.*leg_2n;

    % average of the tail to improve the precision
    trail_start = floor(ip.max_order*0.8);
    trail_len = ip.max_order - trail_start + 1;
    weight = permute([ones(trail_start+1,1); (trail_len-1:-1:1).'/trail_len], [3,2,1]);

    prs = sum(prs_n .* weight, 3);

    vel_r_n = [];
    vel_theta_n = [];
	vel_r = [];
    vel_theta = [];
	if ~ip.is_cal_velocity
		return
    end
    
    leg_d_2n = permute(...
        LegendrePolynomialD(2*max(n), ...
        cos(permute(theta,[3,2,1]))), [3,2,1]) ...
        .* (-sin(theta));
    leg_d_2n= leg_d_2n(:,:,1:2:end);

    % R_d_2n = permute(...
        % cal_hDJ_norm(n(:)*2, ...
        % k*permute(r,[3,2,1]), ...
        % 0, ...
        % k*permute(r,[3,2,1])) ...
        % + ...
        % cal_jDH_norm(n(:)*2, ...
        % k*permute(r,[3,2,1]), ...
        % k*permute(r,[3,2,1]), ...
        % k*a), [3,2,1]);
    % jh = SphBessel_hPrime_int_j_211228B(...
    jh = SphBessel_hPrime_int_j_220301D(...
        2 * ip.max_order, ...
        k * r, ...
        0, ...
        k * r, ...
        'is_focus', ip.is_focus, ...
        'focal_len', k * ip.focal_len);
    jh(:, r == 0, :) = 0;
    % hj = SphBessel_jPrime_int_h_211228C(...
    hj = SphBessel_jPrime_int_h_220301E(...
        2 * ip.max_order, ...
        k * r, ...
        k * r , ...
        k * a, ...
        'is_focus', ip.is_focus, ...
        'focal_len', k * ip.focal_len);
    R_d_2n = permute(jh(1:2:end, :, :) + hj(1:2:end, :, :), [3,2,1]);

    vel_r_n = 1/1i .* C_n.* R_d_2n.* leg_2n;
    vel_theta_n = 1/1i .* C_n .* R_2n .* leg_d_2n ./ (k.*r);

    vel_r = sum(vel_r_n .* weight, 3);
    vel_theta = sum(vel_theta_n .* weight, 3);
    vel_theta(r==0) = 0;
end