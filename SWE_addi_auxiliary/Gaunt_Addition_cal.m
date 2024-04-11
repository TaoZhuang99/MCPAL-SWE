% dim: n->nu->mu->q
function G_A = Gaunt_Addition_cal(nMax, nuMax, qMax)
    n = 0:2:nMax;
    nu = 0:nuMax;
    q = 0:qMax;
    G_A = zeros(length(n),length(nu),length(nu),qMax+1);
    for i = 1:length(n)
        ni = n(i);
        for j = 1:length(nu)
            nuj = nu(j);
            mu = 0:nuj;
            for k = 1:length(mu)
                muk = mu(k);
%                 q = abs(ni-nuj):2:(ni+nuj);
                for l = 1:length(q)
                    ql = q(l);
                    if ql>=abs(muk)
                        G_A(i,j,k,ql+1) = Gaunt(ni, 0, nuj, muk, ql);
                    end
                end
            end
        end
    end
end