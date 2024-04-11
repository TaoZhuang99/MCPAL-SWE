% dim: n -> 4
% run SBJ_A = SphBesselJ_Addition_cal(2*ip.max_order, nuMax, real(src.wav.num), b.r);
% run G_A = Gaunt_Addition_cal(nMax, nuMax);
% before this function
function T = T_additionCoeff_ext(lMax, nuMax, k, b, a)
% dim: nu->mu->l2
    l2 = permute((0:2:lMax), [1,3,2]);
    nu = (0:nuMax).';
    mu = (-nuMax:nuMax);

    qMax = nuMax+lMax*2;
    
    Coeff.Gaunt = Gaunt_Addition_cal(2*lMax, nuMax, qMax);
    Coeff.SphHar = SphHarmonic_Addition_cal(nuMax, qMax, b);
    Coeff.SphBesJ = SphBesselJ_Addition_cal(qMax, k, b);
    Coeff.SphBesH = SphBesselH_Addition_cal(qMax, k, b);
    Coeff.qMax = qMax;

    Coeff.SphHar0 = SphHarmonic(permute(l2, [3,2,1]), 0, pi/2, 0);
    Coeff.SphHar0 = permute(Coeff.SphHar0, [3,2,1]);

    [A, ksi] = coffe_Gauss_Legendre(0, k*a, 100);
    ksi = permute(ksi, [4,2,3,1]);
    A = permute(A, [4,2,3,1]);
    int_func = A.*SphBesselJ(l2, ksi).*ksi;
    Coeff.Int = sum(int_func, 4);

    S_ext = 0 * nu .* mu .* l2;
    S_int = 0 * nu .* mu .* l2;
    for j = 1:length(nu)
        nuj = nu(j);
        for km = 1:length(mu)
            muk = mu(km);
            S_ext(j, km, :) = hatS_additionCoeff(l2, 0, nuj, muk, Coeff);
            S_int(j, km, :) = S_additionCoeff(l2, 0, nuj, muk, Coeff);
        end
    end

    T.ext = Coeff.SphHar0.*S_ext.*Coeff.Int;
    T.int = Coeff.SphHar0.*S_int.*Coeff.Int;
    T.ext = sum(T.ext, 3);
    T.int = sum(T.int, 3);
end