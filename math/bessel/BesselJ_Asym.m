% =========================================================================
% INTRODUCTION
%   - Calculate the Bessel function using the asymptotic expansions at 
%       large arguments
% =========================================================================
function J = BesselJ_Asym(m, arg, varargin)
% 
    ip = inputParser;
    ip.addParameter('approx_order', 2);
    ip.addParameter('tol', 1e-15);
    ip.addParameter('is_log', false);
    ip.parse(varargin{:})
    ip = ip.Results;

    m_dim = ndims(m);
    arg_dim = ndims(arg);
    if (m_dim > arg_dim)
        error("Dimension of the arguments must be larger than orders!")
    end

    m_col = m(:);
    arg_row = arg(:).';

    omega = arg_row - m_col*pi./2 - pi/4;

    % the index of arguments which needs to process
    idx_arg = true(size(arg_row));

    a_2k = log(1);
    a_2k1 = log((4*m_col.^2-1^2)./8);
%     J = log(exp(log(cos(omega)) + a_2k) - exp(log(sin(omega)) + a_2k1 - log(arg_row)));
    omega_max1 = max(real(1i*omega), [], 1);
    omega_max2 = max(real(-1i*omega), [], 1);
    omega_max = max(omega_max1, omega_max2);
    J = omega_max + log(exp(a_2k + log(exp(1i*omega-omega_max) + exp(-1i*omega-omega_max)))/2 ...
        - exp(a_2k1 + log(exp(1i*omega-omega_max) - exp(-1i*omega-omega_max)) - log(arg_row))/2/1i);

    for k =  1:ip.approx_order
        a_2k = a_2k + log((4*m_col.^2 - (4*k-3)^2) .* (4*m_col.^2 - (4*k-1).^2) ...
            ./ (128 * k * (2*k-1)));
        a_2k1 = a_2k1 + log((4*m_col.^2 - (4*k-1)^2) .* (4*m_col.^2 - (4*k+1)^2) ...
            ./ (128 * k * (2*k+1)));
%         J_delta = (-1).^k .* (cos(omega) .* a_2k ./ arg.^(2*k) ...
%             - sin(omega) .* a_2k1 ./ arg.^(2*k+1));
        J_delta = k .* log(-1) + log(exp(log(cos(omega(:,idx_arg))) + a_2k ...
            - 2*k.*log(arg_row(idx_arg))) ...
            - exp(log(sin(omega(:,idx_arg))) + a_2k1 ...
            - (2*k+1) .*log(arg_row(idx_arg))));
        tol_now = exp(J_delta - J(:,idx_arg));
        idx_arg = max(abs(tol_now),[],1) > ip.tol;
        if sum(idx_arg(:)) == 0
            break
        end
        J(:,idx_arg) = J(:,idx_arg) + log(tol_now(:,idx_arg) + 1);
    end
    if ip.is_log
        J = J + 1/2.*log(2/pi./arg_row);
    else
        J = exp(J) .* sqrt(2/pi./arg_row);
    end
    J = reshape(J, size(m .* arg));
end
