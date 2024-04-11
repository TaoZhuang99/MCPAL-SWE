% =========================================================================
% INTRO
%   - Calculate tangent function using the continued fraction method
% =========================================================================

function f = Tan_ContFrac(x)
    f = ContFracLentz(@(n,x) a(n,x), @(n,x) b(n,x), x);
end

function res = a(n, x)
    if n == 1
        res = x;
    else 
        res = -x.^2;
    end
end

function res = b(n, x)
    if n == 0
        res = 0;
    else
        res = 2*n-1;
    end
end
