% =========================================================================
% Calculate the spherical harmonics at l and m
% -------------------------------------------------------------------------
% DIMENSION
%   - 1: l
%   - 2: m
%   - 3: theta
%   - 4: phi
% =========================================================================
function Y = SphHarmonic(l, m, theta, phi)

    validateattributes(l, {'numeric'}, {'size', [nan, 1]});
    validateattributes(m, {'numeric'}, {'size', [1, nan]});
    validateattributes(theta, {'numeric'}, {'size', [1, 1, nan]});
    validateattributes(phi, {'numeric'}, {'size', [1, 1, 1, nan]});
    
    [l_unique, ~, idx] = unique(l);
    leg_norm = 0 * l_unique .* m .* theta .* phi;
    for i = 1:length(l_unique)
        % dim: m -> theta  
        %   ==> 1 -> m -> theta
        leg_norm_buf = permute(permute(...
            legendre(l_unique(i), cos(theta(:)), 'norm'),...
            [1, 3, 2]), [2, 1, 3]);
        leg_norm(i, :, :, :) = leg_norm_buf(:, abs(m)+1, :) + phi*0;
    end
    leg_norm = leg_norm(idx, :, :, :);
    Y = leg_norm .* (-1).^abs(m) / sqrt(2*pi) .* exp(1i * abs(m) .* phi);
    if ~isempty(m(m < 0))
        Y(:, m<0, :, :) = conj(Y(:, m<0, :, :)) .* (-1).^m(m<0);
    end 
end
