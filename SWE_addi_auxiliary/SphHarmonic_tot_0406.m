% =========================================================================
% Calculate the spherical harmonics at l, m, theta and phi
% 
% -------------------------------------------------------------------------
% DIMENSION
%   - l = la: 5-D vec
%   - mu1 = mu1: 2-D vec
%   - mu2 = mu2: 4-D vec
%   - theta: 2-D vec 
%   - phi: 3-D vec
% =========================================================================
function Y_tot = SphHarmonic_tot_0406(la, mu1, mu2, theta, phi)
    theta = vec2ndim(theta,1);
    Y_tot = 0 * la .* mu1 .* mu2 .* theta .* phi;
    legendre_list = zeros(max(la)+1, 1) .* vec2ndim(theta,2) .* phi;

    for i = 1:size(la,5)
        for j = 1:size(theta,1)
            legend_buff = legendre(la(i), cos(theta(j)), 'norm');
            legendre_list(1:length(legend_buff),i,j) = legend_buff;
        end
    end
    
    for i = 1:size(theta,1)
        for j = 1:size(phi,3)
            Y_tot(i,:,j,:,:) = SphHarmonic_ext_new_0406(la, mu1, mu2, legendre_list, i, phi(j));
        end
    end
end