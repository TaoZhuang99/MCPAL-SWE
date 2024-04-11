% =========================================================================
% - Calculate j'(zj) * int_a^b h(x) x dx
% - Modified from SphBessel_jPrime_int_h_211228C.m
% -------------------------------------------------------------------------
% INPUT
% =========================================================================
function res = SphBessel_jPrime_int_h_220301E(max_order, zj, a, b, varargin)

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
    
    [j, j_exp] = SphBesselJ_211209B(max_order+1, zj);
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

    order = (0:max_order).';
    int = 0 * order .* zj .* a .* b .* zero;
    % recurrence relation to calculate the derivative of the spherical Hankel functions
    % for order 1 to max_order
    int(2:end,:,:,:,:,:,:) = 1./(2*order(2:end)+1) ...
        .* (order(2:end) .* j(1:end-2,:,:,:,:,:,:) .* h(2:end,:,:,:,:,:,:) ...
        .* 10.^(j_exp(1:end-2,:,:,:,:,:,:) + h_exp(2:end,:,:,:,:,:,:)) ...
        - (order(2:end)+1) .* j(3:end,:,:,:,:,:,:) .* h(2:end,:,:,:,:,:,:) ...
        .* 10.^(j_exp(3:end,:,:,:,:,:,:) + h_exp(2:end,:,:,:,:,:,:)));
    % for order 0
    int(1,:,:,:,:,:,:) = -j(2,:,:,:,:,:,:) .* h(1,:,:,:,:,:,:) ...
        .* 10.^(j_exp(2,:,:,:,:,:,:) + h_exp(1,:,:,:,:,:,:));
    res = sum(int .* zero .* weight .* phase, 7);

    % res_sum(IsInvalid(res_sum, 'is_mute', true)) = 0;
end
