% =========================================================================
% INTRO
%   - Calculate the error and relative error of the input values
% INPUT
%   - x0: exact value
%   - x: esitmation
% =========================================================================
function [err, rel_err] = Error(x0, x, varargin)
    ip = inputParser();
    % true: input argument are logarithmic values
    ip.addParameter('input_is_log', false);
%     ip.addParameter('input_is_log', false);
    ip.parse(varargin{:});
    ip = ip.Results;

    if ip.input_is_log
        x = exp(x);
        x0 = exp(x0);
    end
    err = x - x0;
    rel_err = real(err)./real(x0) + 1i*imag(err)./imag(x0);
    rel_err(err == 0) = min(abs((rel_err(:))));
end
