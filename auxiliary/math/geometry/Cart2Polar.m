function [rho, phi] = Cart2Polar(x, y)
    rho = sqrt(x.^2 + y.^2);
    phi = atan2(y, x);
end
