clear all

N = 0;
z = 2e1+1i*0;
% z = 0;

% n = (0:N).';
tic
H= exp(SphHankelHLog(N, z));
H = H(end);
% J = real(J) + wrapToPi(imag(J));
toc


fprintf("H = %g %+gi\n", real(H), imag(H))