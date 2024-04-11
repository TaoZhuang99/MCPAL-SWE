% dim: same as n
% run SBJ_A = SphBesselJ_Addition_cal(2*ip.max_order, nuMax, real(src.wav.num), b.r);
% run G_A = Gaunt_Addition_cal(nMax, nuMax);
% before this function
function S = hatS_additionCoeff(n, m, nu, mu, addCoeff)
	S = 0 * n;
    for i = 1:length(n)
        ni = n(i);
        for qi = abs(ni-nu):2:(ni+nu)
            if (qi >= abs(mu-m))
                SH_A_qi_mu = ((sign(mu))^mu)*conj(addCoeff.SphHar(qi+1, abs(mu-m)+1));
                S(i) = S(i) + 1i^qi*(-1)^m*addCoeff.SphBesJ(qi+1)*...
                    SH_A_qi_mu*...
                    addCoeff.Gaunt(ni/2+1, nu+1, abs(mu)+1, qi+1);
            end
        end
    end
    S = 4*pi*1i.^(nu-n).*S;
%     S(:,:,:,i) = S(:,:,:,i) + 1i^qi*(-1)^m*SBJ_A(qi+1)*...
%     conj(SphHarmonic(qi, mu-m, b.theta, b.phi))*...
%     Gaunt(ni, m, nu, -mu, qi);
end
