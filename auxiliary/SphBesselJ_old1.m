% =========================================================================
% Calculate the spherical Bessel function of the first kind
% -------------------------------------------------------------------------
% OUTPUT
%   - j:        the base
%   - j_exp:    the exponent
% =========================================================================
function [j, j_exp] = SphBesselJ(max_order, arg, varargin)
	
    validateattributes(arg, {'numeric'}, {});
    validateattributes(max_order, {'numeric'}, {'scalar', '>=', 0});

    holder = (0:max_order).' .* arg;
    arg_row = arg(:).';
    [arg_row_unique, ~, ic] = unique(arg_row);

    start_order = min(ceil(max_order + max(abs(arg_row_unique)) + 5e1), 5e3);

    j = zeros(start_order + 1, length(arg_row_unique));
    j_exp = j;
    j(end, :) = 1e-300;
    j(end-1, :) = 1e-300;
    for i = fliplr(1:start_order-1)
        idx = (abs(log10(abs(j(i+2,:)))) > 50) & (j(i+2,:) ~= 0);
        if sum(idx) > 0
            expo = round(log10(abs(j(i+2,idx))));
            j_exp(1:i+2, idx) = j_exp(1:i+2, idx) + expo;
            j(i+1:i+2, idx) = j(i+1:i+2, idx) ./ 10.^expo;
        end
        j(i, :) = j(i+1, :) .* (2*i+1) ./ arg_row_unique - j(i+2,:);
    end
    j = j .* sinc(arg_row_unique / pi) ./ j(1,:);
    j_exp = j_exp - j_exp(1,:);

    % special values
    j(:, arg_row_unique == 0) = 0;
    j(1, arg_row_unique == 0) = 1;
    j_exp(:, arg_row_unique == 0) = 0;

    j = reshape(j(1:max_order+1, ic), size(holder));
    j_exp = reshape(j_exp(1:max_order+1, ic), size(holder));
end
