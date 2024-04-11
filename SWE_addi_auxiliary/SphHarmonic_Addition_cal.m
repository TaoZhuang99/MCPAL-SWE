% dim: q->mu
function SH_A = SphHarmonic_Addition_cal(nuMax, qMax, b)
    SH_A = zeros(qMax, nuMax);
%     for q = 0:(nMax+nuMax)
    for q = 0:qMax
        for mu = 0:nuMax
            if q >= abs(mu)
                SH_A(q+1,mu+1) = SphHarmonic(q, mu, b.theta, b.phi);
            end
        end
    end
end
