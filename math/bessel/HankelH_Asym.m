% =========================================================================
% INTRODUCTION
%   - Calculate the Hankel function using the asymptotic expansions at 
%       large arguments
% =========================================================================
function H = HankelH_Asym(m, arg, varargin)
% 
    ip = inputParser;
    ip.addParameter('approx_order', 2);
    ip.addParameter('tol', 1e-15);
    % true: the result is the logarithmic of H
    ip.addParameter('is_log', false);
    ip.addParameter('kind', 1, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 1, '<=', 2}));
    ip.parse(varargin{:})
    ip = ip.Results;

    m_dim = ndims(m);
    arg_dim = ndims(arg);
    if (m_dim > arg_dim)
        error("Dimension of the arguments must be larger than orders!")
    end

    m_col = m(:);
    arg_row = arg(:).';

    % use log to avoid overflow/underflow
    
    omega = (-1).^(ip.kind+1) .* (arg_row - m*pi./2 - pi/4);
    % the index of arguments which needs to process
    idx_arg = true(size(arg_row));

    %% itr == 0
    H = log(1) + 0*arg_row .* m_col;
    a_log = log(1);
    
    %% itr = 1, 2, ....
    for k =  1:ip.approx_order
        a_log = a_log + log((4.*m_col.^2 - (2*k-1).^2) ./ (8.*k));
        H_delta_log = a_log - k.*log((-1).^ip.kind .* 1i.*arg_row(idx_arg));
        tol_now = exp(H_delta_log - H(:,idx_arg));
        idx_arg = max(abs(tol_now),[],1) > ip.tol;
        if sum(idx_arg(:)) == 0
            break
        end
        H(:,idx_arg) = H(:,idx_arg) + log(tol_now(:,idx_arg) + 1);
    end
    if ip.is_log
        H = H + 1i*omega + 1/2.*log(2/pi./arg_row);
    else
        H = exp(H) .* sqrt(2/pi./arg_row) .* exp(1i*omega);
    end
    H = reshape(H, size(m .* arg));
end
