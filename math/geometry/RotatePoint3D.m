% =========================================================================
% INTRO
%   - Rotate a 3D point
% -------------------------------------------------------------------------
% INPUT
%   - x0, y0, z0: the Cartesian coordinates of the point
%   - axis: the rotation axis
%   - theta: the rotation angle
% =========================================================================
function [x, y, z] = RotatePoint3D(x0, y0, z0, axis, theta)
    switch axis
        case 'x'
            x = x0;
            y = y0 .* cos(theta) - z0 .* sin(theta);
            z = y0 .* sin(theta) + z0 .* cos(theta);
        case 'y' 
            x = x0 .* cos(theta) + z0 .* sin(theta);
            y = y0;
            z = -x0 .* sin(theta) + z0 .* cos(theta);
        case 'z'
            x = x0 .* cos(theta) - y0 .* sin(theta);
            y = x0 .* sin(theta) + y0 .* cos(theta);
            z = z0;
        otherwise
            error('Wrong axis!')
    end
end
