% =========================================================================
% INTRO
%   - Calculate the continued fraction using the Lentz's algorithm
% =========================================================================
function f = ContFracLentz(a, b, x, varargin)
    ip = inputParser();
    ip.addParameter('tol', 1e-12);
    ip.addParameter('tiny', 1e-30);
    ip.addParameter('itr_max', 1e3);
    ip.parse(varargin{:});
    ip = ip.Results;

    ip.tiny = ip.tiny .* ip.tol;

    f = b(0, x);
    f(f==0) = ip.tiny;
    C = f;
    D = 0;
    for itr = 1:ip.itr_max
        a_now = a(itr, x);
        b_now = b(itr, x);
        D = b_now + a_now.*D;
        D(D == 0) = ip.tiny;
        D = 1./D;
        C = b_now + a_now./ C;
        delta = C .* D;
        f = f .* delta;
        tol_now = max(abs(delta(:) - 1));
        if tol_now < ip.tol 
            return
        end
        if isnan(tol_now)
            return
        end
    end
    warning(['Failed to achieve the precision %g with %d iterations.\n',...
        'Instead, the precision is %g.'], ...
        ip.tol, ip.itr_max, max(abs(delta(:) - 1)));
end
