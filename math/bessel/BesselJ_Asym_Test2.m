m = 10;
arg = 1e2;

J0 = log(besselj(m, arg))
J = BesselJ_Asym(m, arg, 'approx_order', 50, ...
    'is_log', true, 'tol', 1e-16)
