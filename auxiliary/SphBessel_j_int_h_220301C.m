% =========================================================================
% - Calculate j(zj) * int_a^b h(x) x dx
% - Modified from SphBessel_j_int_h_211226H.m
% -------------------------------------------------------------------------
% INPUT
%   - zj, a, and b support the compatible array size
% =========================================================================
function res = SphBessel_j_int_h_220301C(max_order, zj, a, b, varargin)

    validateattributes(max_order, {'numeric'}, {'scalar', '>=', 0});
    validateattributes(a, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});
    validateattributes(b, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});
    validateattributes(zj, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});
    IsCompatibleSize(zj, a, b);

    ip = inputParser();
    ip.addParameter('gauss_num', 2e2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
    ip.addParameter('is_focus', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
	ip.addParameter('focal_len', nan, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    if ip.is_focus
        validateattributes(ip.focal_len, {'numeric'}, {'scalar'});
    end
    
    [j, j_exp] = SphBesselJ_211209B(max_order, zj);
    [zero, weight] = GaussLegendreQuadParam_211129C(...
        ip.gauss_num, ...
        'lower_limit', a, ...
        'upper_limit', b);
    zero = permute(zero, [7,2,3,4,5,6,1]);
    weight = permute(weight, [7,2,3,4,5,6,1]);
    [h, h_exp] = SphHankel1_211209A(max_order, zero);

    phase = 1;
    if ip.is_focus
        phase = exp(-1i .* sqrt(real(zero).^2 + real(ip.focal_len).^2));
    end

    res_sum = j .* h .* weight .* 10.^(j_exp + h_exp) .* zero .* phase;
    res_sum(IsInvalid(res_sum, 'is_mute', true)) = 0;
    res = sum(res_sum, 7);
end
