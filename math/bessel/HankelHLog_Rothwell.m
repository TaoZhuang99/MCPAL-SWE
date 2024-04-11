% =========================================================================
% INTRO
%   - The Log of Hankel function of first kind using the Rothwell's method
% INPUT
%   - N: maximum order
% =========================================================================

function [H, J] = HankelHLog_Rothwell(N, z, varargin)

    ip = inputParser;
    ip.addParameter('kind', 1, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 1, '<=', 2}));
    ip.addParameter('nu0', 0, @(x)validateattributes(x, {'numeric'}, ...
        {'scalar', '>=', 0, '<', 1}));
    ip.parse(varargin{:})
    ip = ip.Results;

    n = (0:N).';
    z_row0 = z(:).';
    [z_row, ~, idx_z_row] = unique(z_row0);

    J = 0 * n .* z_row;
    H = 0 * n .* z_row;
    R = 0 * n .* z_row;

    R(end, :) = ContFracLentz(@(m, z_row) RatioA(m, z_row), ...
        @(m, z_row) RatioB(m, z_row, N, ip.nu0), z_row,...
        'itr_max', max(10,ceil(max(abs(z_row)*3))));

    for nn = N:-1:1
        R(nn, :) = 2 * (nn + ip.nu0 - 1) ./ z_row - 1./R(nn+1, :);
    end

    J(1, :) = log(besselj(ip.nu0, z_row, 1)) + abs(imag(z_row));
    for nn = 1:N
        J(nn+1,:) = J(nn,:) - log(R(nn+1,:));
    end

    H(1,:) = log(besselh(ip.nu0, ip.kind, z_row, 1)) + (-1).^(ip.kind+1) .*1i.*z_row;
    % H(1,:) = log(besselh(ip.nu0, 1, z_row, 1)) + 1i.*z_row;
    for nn = 1:N
        RH = 1./R(nn+1,:) +(-1)^ip.kind *2*1i./(pi .* z_row) .* exp(-J(nn,:) - H(nn,:));
        H(nn+1,:) = H(nn,:) + log(RH);
    end
    
    J(1,z_row==0) = log(1);
    J(2:end,z_row==0) = log(0);

    J = J(:, idx_z_row);
    H = H(:, idx_z_row);
    J = reshape(J, size(n .* z_row0));
    H = reshape(H, size(n .* z_row0));
end

function res = RatioA(m, z)
    res = 1;
end

function res = RatioB(m, z, N, nu0)
    res = 2 * (-1).^m .* (N + m + nu0) ./ z;
end
