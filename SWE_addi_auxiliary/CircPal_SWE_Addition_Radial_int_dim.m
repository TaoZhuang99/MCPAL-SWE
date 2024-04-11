% dim: 
% res: nu1->mu1->nu2->mu2->la
% la: 1->mu1->1->mu2->la
% nu1: 1 vec
% nu2: 3 vec
% r: scalar

function res = CircPal_SWE_Addition_Radial_int_dim(pal_radius, br, la, wn, r, nu1, nu2)
    
    ka = wn.ka; k1 = wn.k1; k2 = wn.k2; ku = wn.ku;

	half_lam = 2*pi/real(ku)/2;
	rvMax = 10;

    res.int = 0*nu1.*nu2.*la;
    res.mid = 0*nu1.*nu2.*la;
    res.ext = 0*nu1.*nu2.*la;

    % integral range
    range.int1 = 1e-6;
    range.ext1 = br+pal_radius; range.ext2 = rvMax;
    
    if r < br-pal_radius
        range.mid1 = r; range.mid2 = br-pal_radius;
        range.int2 = r;
        if range.mid1 == 0
            range.mid1 = 1e-3;
        end
    else 
        range.int2 = br-pal_radius;
        range.mid1 = 0; range.mid2 = 0;
    end
    intRang = range.int2 - range.int1;
    midRang = range.mid2 - range.mid1;
    extRang = range.ext2 - range.ext1;

	[A_int, rv_int] = coffe_Gauss_Legendre(range.int1, range.int2, ceil(1.1*intRang/half_lam), 'dim', 6);
	[A_mid, rv_mid] = coffe_Gauss_Legendre(range.mid1, range.mid2, ceil(1.1*midRang/half_lam), 'dim', 6);
	[A_ext, rv_ext] = coffe_Gauss_Legendre(range.ext1, range.ext2, ceil(1.1*extRang/half_lam), 'dim', 6);

    % func dim: r->nu1->nu2->la->rv
	func_int = SphBesselJ(la, ka*rv_int) .* SphHankelH(la, ka*r) .* ...
		SphBesselJ(nu1, k1*rv_int) .* conj(SphBesselJ(nu2, k2*rv_int)) .* ...
		ka^3 .* rv_int.^2;
	res.int = sum(0*A_int .* func_int, 6);

	func_mid = SphBesselJ(la, ka*r) .* SphHankelH(la, ka*rv_mid) .* ...
		SphBesselJ(nu1, k1*rv_mid) .* conj(SphBesselJ(nu2, k2*rv_mid)) .* ...
		ka^3 .* rv_mid.^2;
	res.mid = sum(A_mid .* func_mid, 6);

	func_ext = SphBesselJ(la, ka*r) .* SphHankelH(la, ka*rv_ext) .* ...
		SphHankelH(nu1, k1*rv_ext) .* conj(SphHankelH(nu2, k2*rv_ext)) .* ...
		ka^3 .* rv_ext.^2;
	res.ext = sum(A_ext .* func_ext, 6);

end