%==========================================================================
% Calculate the spherical harmonics
%==========================================================================

%% parameters
l = 1;
m = (-l:l);
theta = pi/3;
phi = pi/4;

%% main procedure
sph_harmonics =  SphHarmonic(l, m, theta, phi)
