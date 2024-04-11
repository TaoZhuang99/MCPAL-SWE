% =========================================================================
% INTRO
%   - Input are exponents, outputs are exponents
% =========================================================================
function res = LogAdd(a, b)
    max_exp = max(a,b);
    res = max_exp + log(exp(a-max_exp) + exp(b-max_exp));
end
