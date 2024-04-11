% dim: q
function SBJ_A = SphBesselH_Addition_cal(qMax, k, b)
    q = (0:qMax).';
    SBJ_A = SphHankelH(q, k.*b.r);
end