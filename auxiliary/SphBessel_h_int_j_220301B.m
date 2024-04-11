% =========================================================================
% - h(zh) * int_a^b j(x) x dx
% - Modified from SphBessel_h_int_j_211226G.m
% -------------------------------------------------------------------------
% INPUT
%   - max_order 
%   - zh, a, and b support the compatible array size
% =========================================================================
function res = SphBessel_h_int_j_220301B(max_order, zh, a, b, varargin)
    
    validateattributes(max_order, {'numeric'}, {'scalar', '>=', 0});
    validateattributes(a, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});
    validateattributes(b, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});
    validateattributes(zh, {'numeric'}, {'size', [1, nan, nan, nan, nan, nan, 1]});

    IsCompatibleSize(zh, a, b);

    ip = inputParser();
    ip.addParameter('gauss_num', 2e2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
    ip.addParameter('is_focus', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
	ip.addParameter('focal_len', nan, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    if ip.is_focus
        validateattributes(ip.focal_len, {'numeric'}, {'scalar'});
    end
    
    [h, h_exp] = SphHankel1_211209A(max_order, zh);
    [zero, weight] = GaussLegendreQuadParam_211129C(...
        ip.gauss_num, ...
        'lower_limit', a, ...
        'upper_limit', b);
    zero = permute(zero, [7,2,3,4,5,6,1]);
    weight = permute(weight, [7,2,3,4,5,6,1]);
    [j, j_exp] = SphBesselJ_211209B(max_order, zero);

    phase = 1;
    if ip.is_focus
        phase = exp(-1i .* sqrt(real(zero).^2 + real(ip.focal_len).^2));
    end

    res = sum(j .* h .* weight .* 10.^(j_exp + h_exp) .* zero .* phase, 7);
end
