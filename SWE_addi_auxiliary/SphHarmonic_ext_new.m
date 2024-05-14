% =========================================================================
% Calculate the spherical harmonics at l and m
% only for CircPal_SWE_Addition_new
% 
% -------------------------------------------------------------------------
% DIMENSION
%   - l = la: 5-D vec
%   - mu1 = mu1: 2-D vec
%   - mu2 = mu2: 4-D vec
%   - theta: scalar 
%   - phi: scalar
% =========================================================================
function Y = SphHarmonic_ext_new(la, mu1, mu2, theta, phi)
    
    Y = 0 * la .* mu1 .* mu2;
    
    for i = 1:size(mu1,2)
        for j = 1:size(mu2,4)
            m_temp = mu1(i)-mu2(j);
            for k = 1:size(la,5)
                if la(k) >= abs(m_temp)
                    leg_norm_buf = legendre(la(k), cos(theta), 'norm');
                    leg_norm = leg_norm_buf(abs(m_temp)+1);
                    Y(1, i, 1, j, k) = leg_norm * ...
                        (-1)^abs(m_temp) / sqrt(2*pi) * exp(1i * abs(m_temp) * phi);
                    if m_temp < 0
                        Y(1, i, 1, j, k) = conj(Y(1, i, 1, j, k)) * (-1)^m_temp;
                    end
                end
            end
        end
    end
end
