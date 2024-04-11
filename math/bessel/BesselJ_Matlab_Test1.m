n = repmat([1:10],1,1e3).';
z = [2,3,2];
tic
J = BesselJ_Matlab(n, z);
toc
