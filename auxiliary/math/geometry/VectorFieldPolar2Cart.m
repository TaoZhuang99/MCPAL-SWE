% ========================================================================
% - Convert the vector field components under the polar coordinates
%   into those under the Cartesian coordinates
% --------------------------------------------------------------------------
% INPUT
%   - v_rho, v_phi: the components
%   - phi: the angles
% OUTPUT
%   - v_x, v_y: the vector field under Cartesian coordinates
% ========================================================================
function [v_x, v_y] = VectorFieldPolar2Cart(...
        v_rho, v_phi, phi)
    IsCompatibleSize(v_rho, v_phi, phi);

    v_x = v_rho .* cos(phi) - v_phi .* sin(phi);
    v_y = v_rho .* sin(phi) + v_phi .* cos(phi);
end
