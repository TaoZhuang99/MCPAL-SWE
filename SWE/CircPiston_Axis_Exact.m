% ==========================================================================
% - The on-axis pressure and velocity radiated by a circular piston
% --------------------------------------------------------------------------
% INPUT
%   wavnum  --- wave number
%   radius  --- the radius of the piston
%   z       --- the z coordinate
% ==========================================================================
function [prs, vel_z] = CircPiston_Axis_Exact(k, a, z)
    validateattributes(k, {'numeric'}, {'scalar'});
    validateattributes(a, {'numeric'}, {'scalar'});
    validateattributes(z, {'numeric'}, {});

    ka = k * a;
    za = sqrt(1 + (z ./ a).^2);

    prs = -1i * 2 * 1.21 * 343 ...
        .* sin(ka / 2 .* (za - z ./ a)) ...
        .* exp(1i * ka / 2 .* (za + z ./ a));

    vel_z = exp(1i * k * z) ...
        - z ./ a ./ za .* exp(1i * ka .* za);
end

