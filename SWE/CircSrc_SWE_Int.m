% =========================================================================
% INTRO
%   - Calculate the integral involved in the radial component
%   - int_r1^r2 u(rs) * jn(k r<) * hn(k r>) * k * rs drs
%       - r< = min(r, rs)
%       - r> = max(r, rs)
% -------------------------------------------------------------------------
% INPUT
%   - n: order
%   - sph: the kernel. spherical function type 'j' or 'h'
%       - 'j':  hn(kr) * int_r1^r2 u(rs) j_n(k rs) k drs
%       - 'h':  jn(kr) * int_r1^r2 u(rs) j_n(k rs) k drs
%   - r1: the lower limit of the integral
%   - r2: the upeer limit of the integral
%   - r: the argument of the function outside the integral
% -------------------------------------------------------------------------
% DIMENSION
%   - 1: n (order)
%   - 2 ~ N: r1 .* r2 .* r
% =========================================================================
function int = CircSrc_SWE_Int(src, n, sph, r1, r2, r, varargin)

    validateattributes(n, {'numeric'}, {'column'});
    validatestring(sph, {'j', 'h'});
    validateattributes(r1, {'numeric'}, {'size', [1, nan, nan, nan, nan]});
    validateattributes(r2, {'numeric'}, {'size', [1, nan, nan, nan, nan]});
    validateattributes(r, {'numeric'}, {'size', [1, nan, nan, nan, nan]});
    
    ip = inputParser;
    ip.addParameter('int_num', []);
    ip.addParameter('is_log', false);
    % normalization 
    parse(ip, varargin{:});
    ip = ip.Results;

    k = src.wav.num;
    a = src.radius;

    % to ensure the convergence at 40 kHz
    if isempty(ip.int_num)
        if a < 0.2
            ip.int_num = 1e2;
        elseif a < 0.3
            ip.int_num = 1.5e2;
        else
            ip.int_num = 2e2;
        end
    end

    [n_unique, ~, idx] = unique(n);

    int = GaussLegendreQuad(@(rs) ...
        Integrand(src, n_unique, sph, rs, r), ...
        r1, r2, 'int_num', ip.int_num, 'is_log', true, 'dim', 10);
    int = int(idx, :, :, :, :, :, :);
    if ~ip.is_log
        int = exp(int);
    end
end

function int = Integrand(src, n, sph, rs, r)
    u = src.CalProfile(rs);
    switch sph
        case 'j'
            int = log(u) + 2*log(src.wav.num) + log(rs) ...
                + SphBesselJLog(n, src.wav.num*rs) ...
                + SphHankelHLog(n, src.wav.num*r);
        case 'h'
            int = log(u) + 2*log(src.wav.num) + log(rs) ...
                + SphBesselJLog(n, src.wav.num*r) ...
                + SphHankelHLog(n, src.wav.num*rs);
        otherwise
            error('Wrong spherical functions!')
    end
end
