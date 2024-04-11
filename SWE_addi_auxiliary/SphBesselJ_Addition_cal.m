% dim: q:1
function SBJ_A = SphBesselJ_Addition_cal(qMax, k, b)
%     q = (0:(nMax+nuMax)).';
    q = (0:qMax).';
    SBJ_A = SphBesselJ(q, k.*b.r);
end