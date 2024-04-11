% =========================================================================
% INTRO
%   - Calculate the integral involved in the radial component
%   - int_r1^r2 jn(kr<) * hn(kr>) * R1 * R2 * ka^3 * rv^2 drv
%       - r< = min(r, rv)
%       - r> = max(r, rv)
% -------------------------------------------------------------------------
% INPUT
%   - sph: the kernel. spherical function type 'j' or 'h'
%       - 'j':  hn(kr) * int_r1^r2 u(rs) j_n(k rs) k drs
%       - 'h':  jn(kr) * int_r1^r2 u(rs) j_n(k rs) k drs
%   - r1: the lower limit of the integral
%   - r2: the upeer limit of the integral
%   - r: the argument of the function outside the integral
% -------------------------------------------------------------------------
% DIMENSION
%   - 1: r 
%   - 2: 1 (holder for theta)
%   - 3: 1 (holder for phi)
%   - 4: la
%   - 5: l1
%   - 6: l2
%   - 7: rv
% =========================================================================
function R = PalCircSrc_SWE_Int(pal, la, l1_max, l2_max, r1, r2, r, sph, varargin)

%     validateattributes(r1, {'numeric'}, {'column'});
%     validateattributes(r2, {'numeric'}, {'column'});
%     validateattributes(r, {'numeric'}, {'column'});
    validatestring(sph, {'j', 'h'});

    ip = inputParser;
    ip.addParameter('int_method', 'direct', @(x)any(validatestring(x, {'direct', 'steepest_descent'})));
    % number of points for the numerical integration
    ip.addParameter('int_num', 3e2, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 2}));
    ip.addParameter('is_farfield', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    % is_log = true: return the logarithm of the result
    ip.addParameter('is_log', false);
    parse(ip, varargin{:});
    ip = ip.Results;

%     ka = pal.audio.num;
    
    switch ip.int_method
        case 'direct'
            R = GaussLegendreQuad(@(rv) ...
                Integrand(pal, sph, rv, r, la, l1_max, l2_max), ...
                r1, r2, 'int_num', ip.int_num, 'is_log', true, 'dim', 7);
        case 'steepest_descent'
            R = GaussLegendreQuad(@(rv) ...
                Integrand(pal, sph, r1+1i*rv, r, la, l1_max, l2_max), ...
                0, inf, 'int_num', ip.int_num, 'is_log', true, 'dim', 7);
        otherwise
            error("Wrong integration methods!");
    end
    if ~ip.is_log
        R = exp(R);
    end

    % dim: la -> 1 -> 1 -> 1 -> -> 1 -> rv
    % j = SphBesselJLog(2*la(:)+abs(ma), ka .* rv);
    % dim: 1 -> 1 -> 1 -> la -> 1 -> 1 -> rv
    % j = permute(j, [4,2,3,1,5,6,7]);
    % if ip.is_farfield
        % h = 1i*ka*r - log(1i.^(2*la+abs(ma)) .* ka .* r);
    % else
        % % dim: la -> r
        % h = SphHankelHLog(2*la(:)+abs(ma), ka .* r.');
        % h = permute(permute(h, [4,2,3,1]), [2,1,3,4]);
    % end

    % jh = exp(j + h);
    % jh(isinf(jh)) = 0;
    % R = sum(conj(R1) .* R2 .* jh .* ka^3 .* rv.^2 .* weight, 7);
end

function int = Integrand(pal, sph, rv, r, la, l1_max, l2_max)
    m1 = pal.src_low.prf.azimuth_order;
    m2 = pal.src_high.prf.azimuth_order;
    ma = m2 - m1;


%     tt = tic;
    int_num = 5e2;
    % dim: r .* rv -> 1 -> 1 -> l1
    R1 = CircSrc_SWE_Radial(...
        pal.src_low, rv(:), l1_max, ...
        'int_num', int_num);
    % dim: r -> rv -> l1
    R1 = reshape(R1, [size(permute(rv, [1,7,3,4,5,6,2])), l1_max+1]);
    % dim: r -> 1 -> 1 -> 1 -> l1 -> 1 -> rv
    R1 = permute(permute(R1, [1,7,3,4,5,6,2]), [1,2,5,4,3,6,7]);
%     tt = toc(tt);
%     fprintf("Elapsed time for calculating R1: %gs.\n", tt);

%     tt = tic;
    % dim: r .* rv -> 1 -> 1 -> l2
    R2 = CircSrc_SWE_Radial(...
        pal.src_high, rv(:), l2_max, ...
        'int_num', int_num);
    % dim: r -> rv -> l2
    R2 = reshape(R2, [size(permute(rv, [1,7,3,4,5,6,2])), l2_max+1]);
    % dim: r -> 1 -> 1 -> 1 -> -> 1 -> l2 -> rv
    R2 = permute(permute(R2, [1,7,3,4,5,6,2]), [1,2,6,4,5,3,7]);
%     tt = toc(tt);
%     fprintf("Elapsed time for calculating R2: %gs.\n", tt);

    %% the integrand
    int = log(conj(R1)) + log(R2) + 3*log(pal.audio.num) + 2*log(rv);
    switch sph
        case 'j'
            rj = rv;
            rh = r;
        case 'h'
            rj = r;
            rh = rv;
        otherwise
            error('Wrong spherical functions!')
    end
    int = int ...
        + permute(SphBesselJ(2*la+abs(ma), ...
        pal.audio.num*permute(rj, [6,2,3,4,5,1,7]), ...
        'is_log', true) ...
        + SphHankelH(2*la+abs(ma), ...
        pal.audio.num*permute(rh, [6,2,3,4,5,1,7]), ...
        'is_log', true), ...
        [6,2,3,4,5,1,7]);
end
