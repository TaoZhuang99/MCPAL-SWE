% =========================================================================
% INTRO
%   - Calculate the third exteior radial component used in the SWE method 
%   - SWE: spherical wave expansion
% -------------------------------------------------------------------------
% INPUT
%   - ka, the wavenumber for audio sound
%   - k1, k2, the wavenumber for ultrasound
%   - a, the radius of the radiator
%   - r, the radial coordinate
%   - max_l, maximum order for SWE
% DIMENSION
%   - r -> 1 -> 1 -> l1 -> l2 -> l3 -> integration
% =========================================================================
function radial3 = PalCircSrcSweRadial3Exterior(...
    ka, k1, k2, ...
    a, r, ...
    max_l, varargin)

    validateattributes(ka, {'numeric'}, {'scalar'});
    validateattributes(k1, {'numeric'}, {'scalar'});
    validateattributes(k2, {'numeric'}, {'scalar'});
    validateattributes(a, {'numeric'}, {'scalar', '>', 0});
    validateattributes(r, {'numeric'}, {'>=', a, 'column'});
    validateattributes(max_l, {'numeric'}, {'scalar', '>=', 0});

	ip = inputParser;
	ip.addParameter('eqn', 'Westervelt', @(x)any(validatestring(x, {'Westervelt', 'WesterveltCorrection', 'Kuznetsov'})));
	ip.addParameter('method', 'complex', @(x)any(validatestring(x, {'complex', 'gauss'})));
	ip.addParameter('gauss_num', 200, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
	ip.parse(varargin{:});
	ip = ip.Results;
    
    l = (0:max_l).';
    l1 = permute(l, [4,2,3,1]);
    l2 = permute(l, [5,2,3,4,1]);
    l3 = permute(l, [6,2,3,4,5,1]);
    
    % l3, r
    [j_l3_kar, j_exp_l3_kar] = SphBesselJ(2*max_l, ...
        ka*permute(r, [2,1]));
	% 1, r, 1, 1, 1, l3
    j_l3_kar = permute(j_l3_kar(1:2:end, :), [6,2,3,4,5,1]);
    j_exp_l3_kar = permute(j_exp_l3_kar(1:2:end, :), [6,2,3,4,5,1]);
    % r, 1, 1, 1, 1, l3
    j_l3_kar = permute(j_l3_kar, [2,1,3,4,5,6]);
    j_exp_l3_kar = permute(j_exp_l3_kar, [2,1,3,4,5,6]);
    
    % l1, 1
    J_l1_0_k1a = CircSrcSweRadial_Exterior1(...
        k1, a, max_l, ...
        'gauss_num', 2e2);
    % 1, 1, 1, l1
    J_l1_0_k1a = permute(J_l1_0_k1a, [4,2,3,1]);
    % l2, 1
    J_l2_0_k2a = CircSrcSweRadial_Exterior1(...
        k2, a, max_l, ...
        'gauss_num', 2e2);
    % 1, 1, 1, 1, l2
    J_l2_0_k2a = permute(J_l2_0_k2a, [5,2,3,4,1]);
    
    % gauss, 1 
	[zero, weight] = GaussLegendreQuadParam(...
        ip.gauss_num, -1, 1);
    % 1, 1, 1, 1, 1, 1, gauss
	zero = permute(zero, [7,2,3,4,5,6,1]);
	weight = permute(weight, [7,2,3,4,5,6,1]);

	switch ip.method
		case 'complex'
			k_ave = 1/3 * abs(k1+conj(k2)+ka);
			k1 = k1/k_ave;
			k2 = k2/k_ave;
			ka = ka/k_ave;
            % r, 1, 1, 1, 1, 1, gauss
            rv = r*k_ave + 1i* tan(pi/4*(zero+1));
        case 'gauss'
            % r, 1, 1, 1, 1, 1, gauss
            rv = r + tan(pi/4*(zero+1));
    end
	exp_all = exp(1i*(k1-conj(k2)+ka) .* rv);

	switch ip.method
		case 'complex'
			C = ka^3 .* rv.^2 * 1i .* exp_all ...
				.* (sec(pi/4*(zero+1))).^2 * pi/4;
		case 'gauss'
			C = ka^3 * rv.^2 .* exp_all ...
				.* (sec(pi/4*(zero+1))).^2 * pi/4 ;
    end

    % l1, r, 1, 1, 1, 1, gauss
	hhat_l1_k1rv = SphHankel1Scaled(2*l1(:), k1*permute(rv,[2,1,3,4,5,6,7]));
    % 1, r, 1, l1, 1, 1, gauss
    hhat_l1_k1rv = permute(hhat_l1_k1rv, [4,2,3,1,5,6,7]);
    % r, 1, 1, l1, 1, 1, gauss
    hhat_l1_k1rv = permute(hhat_l1_k1rv, [2,1,3,4,5,6,7]);
    
    % l2, r, 1, 1, 1, 1, gauss
	hhat_l2_k2rv = SphHankel1Scaled(2*l2(:), k2*permute(conj(rv),[2,1,3,4,5,6,7]));
    % 1, r, 1, 1, l2, 1, gauss
    hhat_l2_k2rv = permute(hhat_l2_k2rv, [5,2,3,4,1,6,7]);
    % r, 1, 1, 1, l2, 1, gauss
    hhat_l2_k2rv = permute(hhat_l2_k2rv, [2,1,3,4,5,6,7]);
    
    % l3, r, 1, 1, 1, 1, gauss
	hhat_l3_krv = SphHankel1Scaled(2*l3(:), ka*permute(rv,[2,1,3,4,5,6,7]));
    % 1, r, 1, 1, 1, l3, gauss
    hhat_l3_krv = permute(hhat_l3_krv, [6,2,3,4,5,1,7]);
    % r, 1, 1, 1, 1, l3, gauss
    hhat_l3_krv = permute(hhat_l3_krv, [2,1,3,4,5,6,7]);
    
	radial3 = sum(C .* weight .* J_l1_0_k1a .* conj(J_l2_0_k2a) ...
        .* hhat_l3_krv .* j_l3_kar .* 10.^j_exp_l3_kar ...
        .* hhat_l1_k1rv .* conj(hhat_l2_k2rv), 7);
end
