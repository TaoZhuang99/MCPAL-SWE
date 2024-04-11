% =========================================================================
% - h'(zh) * int_a^b j(x) x dx
% - Modified from SphBessel_hPrime_int_j_211228B.m
% ------------------------------------------------------------------------- 
% INPUT
%   - max_order
%   - zh, a, and b support the compatible array size
% =========================================================================
function res = SphBessel_hPrime_int_j_220301D(max_order, zh, a, b, varargin)

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

    [h, h_exp] = SphHankel1_211209A(max_order+1, zh);
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

    order = (0:max_order).';
    int = 0 * order .* zh .* a .* b .* zero;
    % recurrence relation to calculate the derivative of the spherical Hankel functions
    % for order 1 to max_order
    int(2:end,:,:,:,:,:,:) = 1./(2*order(2:end)+1) ...
        .* (order(2:end) .* h(1:end-2,:,:,:,:,:,:) .* j(2:end,:,:,:,:,:,:) ...
        .* 10.^(h_exp(1:end-2,:,:,:,:,:,:) + j_exp(2:end,:,:,:,:,:,:)) ...
        - (order(2:end)+1) .* h(3:end,:,:,:,:,:,:) .* j(2:end,:,:,:,:,:,:) ...
        .* 10.^(h_exp(3:end,:,:,:,:,:,:) + j_exp(2:end,:,:,:,:,:,:)));
    % for order 0
    int(1,:,:,:,:,:,:) = -h(2,:,:,:,:,:,:) .* j(1,:,:,:,:,:,:) ...
        .* 10.^(h_exp(2,:,:,:,:,:,:) + j_exp(1,:,:,:,:,:,:));
    res = sum(int .* zero .* weight .* phase, 7);
end
