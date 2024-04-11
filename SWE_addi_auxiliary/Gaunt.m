% ===============================================================================
% INTRO
%   -Gaunt coefficient
% ===============================================================================
function G = Gaunt(n,m,nu,mu,q)

%     validateattributes(n, {'numeric'}, {'scalar'});
%     validateattributes(m, {'numeric'}, {'scalar'});
%     validateattributes(nu, {'numeric'}, {'scalar'});
%     validateattributes(mu, {'numeric'}, {'scalar'});
%     validateattributes(q, {'numeric'}, {'scalar'});

    S = sqrt((2*n+1)*(2*nu+1)*(2*q+1)./(4*pi));
    w000 = Wigner3j000(n, nu, q);
    if w000 == 0
        G = 0;
    else
	    G = (-1)^(m + mu)*S*w000*...
		    Wigner3j(n, nu, q, m, mu, -m-mu);
    end
end
