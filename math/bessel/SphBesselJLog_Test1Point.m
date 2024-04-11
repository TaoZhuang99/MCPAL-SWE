clear all

N = 300;
z = 2e1+1i*1;
% z = 0;

% n = (0:N).';
tic
J = exp(SphBesselJLog(N, z));
J = J(end);
% J = real(J) + wrapToPi(imag(J));
toc


fprintf("J = %g %+gi\n", real(J), imag(J))