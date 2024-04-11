% =========================================================================
% INTRO
%   - The Log of Bessel function of first kind using the Rothwell's method
% INPUT
%   - N: maximum order
% =========================================================================

function [J, J_prime] = BesselJLog_Rothwell(N, z, varargin)

    ip = inputParser();
    ip.addParameter('nu0', 0, @(x)validateattributes(x, {'numeric'}, ...
        {'scalar', '>=', 0, '<', 1}));
    ip.addParameter('is_cal_derivative', false, ...
        @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

    n = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    J = 0 * n .* z_row;
    R = 0 * n .* z_row;

    R(end, :) = ContFracLentz(@(m, z_row) RatioA(m, z_row), ...
        @(m, z_row) RatioB(m, z_row, N, ip.nu0), z_row,...
        'itr_max', max(10,ceil(max(abs(z_row)*2))));

    for nn = N:-1:1
        R(nn, :) = 2 * (nn + ip.nu0 - 1) ./ z_row - 1./R(nn+1, :);
    end

    J(1, :) = log(besselj(ip.nu0, z_row, 1)) + imag(z_row);
    for nn = 1:N
        J(nn+1,:) = J(nn,:) - log(R(nn+1,:));
    end
    
    J_prime = [];
    if ip.is_cal_derivative
        J_prime = J + log(R - (n+ip.nu0) ./ z_row);
    end

    if ip.nu0 == 0
        J(1,z_row==0) = log(1);
        J(2:end,z_row==0) = log(0);
        J_prime(:, z_row==0) = log(0);
        J_prime(2, z_row==0) = log(1/2);
    end

    J = J(:, idx_z_row);
    J = reshape(J, size(n .* z_row0));
    if ip.is_cal_derivative
        J_prime = J_prime(:, idx_z_row);
        J_prime = reshape(J, size(n .* z_row0));
    end
end


function res = RatioA(m, z)
    res = 1;
end

function res = RatioB(m, z, N, nu0)
    res = 2 * (-1).^(m+2) .* (N + m + nu0) ./ z;
end
