% ==========================================================================
% INTRO
%   - Calculate the Zernike radial polynomial at degree n and order m
%       using the Chong's recursive method
%   - See C.-W. Chong, P. Raveendran, and R. Mukundan, ``A comparative 
%       analysis of algorithms for fast computation of Zernike moments,'' 
%       Pattern Recognition 36(3), 731–742 (2003).
% --------------------------------------------------------------------------
% DIMENSION
%   - rho
% --------------------------------------------------------------------------
function R = ZernikeRadial(n, m, rho)

    validateattributes(n, {'numeric'}, {'scalar', '>=', 0});
    validateattributes(m, {'numeric'}, {'scalar'});
    validateattributes(rho, {'numeric'}, {'>=', 0, '<=', 1});

    m = abs(m);

    if (mod(n-m, 2) ~= 0 || m > n || m < -n)
        R = 0 * rho;
        return 
    end

    % R_n^n
    R = rho.^n;
    if (n == m)
        return
    end
    
    % R_{n-2}^{n-2}
    R0 = rho.^(n-2);
    % R_n^{n-2}
    R1 = n .* R - (n-1) .* R0;

    if (n - m == 2)
        R = R1;
        return
    end

    for mm = n:-2:m+4
        A3 = -4 * (mm-2) * (mm-3) / (n+mm-2) / (n-mm+4);
        A2 = A3 * (n+mm)*(n-mm+2)/4/(mm-1) + (mm-2);
        A1 = mm*(mm-1)/2 - mm*A2 + A3*(n+mm+2)*(n-mm)/8;
        % R: R_n^(m-4)
        R = A1 .* R + (A2 + A3./rho.^2) .* R1; 
        if (mm == m+4)
            if (m == 0)
                R(rho==0) = real((-1).^(n/2));
            else 
                R(rho==0) =0;
            end
            return
        end
        [R, R1] = deal(R1, R);
    end
    
    % buf = (-1).^(n_list/2) + 0 * rho;
    % R(:, :, rho == 0) = 0;
    % R(:, 1, rho == 0) = real(buf(:, 1, rho == 0));
%     R = real(R);
end
