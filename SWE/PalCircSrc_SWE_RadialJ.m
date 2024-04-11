% =========================================================================
% INTRO
% -------------------------------------------------------------------------
% INPUT
% DIMENSION
%   - 1: r 
%   - 2: 1 (holder for theta)
%   - 3: 1 (holder for phi)
%   - 4: la
%   - 5: l1
%   - 6: l2
%   - 7: rv
% =========================================================================
function R = PalCircSrc_SWE_RadialJ(...
    pal, la_max, l1_max, l2_max, r1, r2, r, varargin)

    validateattributes(r1, {'numeric'}, {'column'});
    validateattributes(r2, {'numeric'}, {'column'});
    validateattributes(r, {'numeric'}, {'column'});

    ip = inputParser;
    % number of points for the numerical integration
    ip.addParameter('int_num', 2e2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
    ip.addParameter('is_farfield', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    parse(ip, varargin{:});
    ip = ip.Results;

    ka = pal.audio.num;
    
    la = permute((0:la_max).', [4,2,3,1]);
    m1 = pal.src_low.prf.azimuth_order;
    m2 = pal.src_high.prf.azimuth_order;
    ma = m2 - m1;

    [rv, weight] = GaussLegendreQuadParam(ip.int_num, r1, r2, 'dim', 7);

    % dim: rv -> 1 -> 1 -> l1
    R1 = CircSrc_SWE_Radial(...
        pal.src_low, ...
        permute(rv, [7,2,3,4,5,6,1]), l1_max, ...
        'int_num', 5e2);
    % dim: 1 -> 1 -> 1 -> 1 -> l1 -> 1 -> rv
    R1 = permute(permute(R1, [7,2,3,4,5,6,1]), [1,2,3,5,4,6,7]);
    
    % dim: rv -> 1 -> 1 -> l2
    R2 = CircSrc_SWE_Radial(...
        pal.src_high, ...
        permute(rv, [7,2,3,4,5,6,1]), l2_max, ...
        'int_num', 5e2);
    % dim: 1 -> 1 -> 1 -> 1 -> -> 1 -> l2 -> rv
    R2 = permute(permute(R2, [7,2,3,4,5,6,1]), [1,2,3,6,5,4,7]);

    % dim: la -> 1 -> 1 -> 1 -> -> 1 -> rv
    j = SphBesselJLog(2*la(:)+abs(ma), ka .* rv);
    % dim: 1 -> 1 -> 1 -> la -> 1 -> 1 -> rv
    j = permute(j, [4,2,3,1,5,6,7]);
    if ip.is_farfield
        h = 1i*ka*r - log(1i.^(2*la+abs(ma)) .* ka .* r);
    else
        % dim: la -> r
        h = SphHankelHLog(2*la(:)+abs(ma), ka .* r.');
        h = permute(permute(h, [4,2,3,1]), [2,1,3,4]);
    end

    jh = exp(j + h);
    jh(isinf(jh)) = 0;
    R = sum(conj(R1) .* R2 .* jh .* ka^3 .* rv.^2 .* weight, 7);
end
