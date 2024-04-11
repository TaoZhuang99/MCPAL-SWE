function HD = HankelHPrime_Matlab(m, z)
    H1 = besselh(m, z);
    H2 = besselh(m+1, z);
    HD = m./z .* H1 - H2;
end
