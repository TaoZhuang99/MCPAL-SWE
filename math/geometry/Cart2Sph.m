% =========================================================================
% INTRO
%   - Transform Cartesian coordinates to spherical coordiantes
% =========================================================================
function [r, theta, phi] = Cart2Sph(x, y, z)
    r = sqrt(x.^2 + y.^2 + z.^2);
    theta = acos(z ./ r);
    phi = atan2(y, x);
    theta(isnan(theta)) = 0;
    phi(isnan(phi)) = 0;
end
