clear all

N = 10;
z = 2e1+1i*0;
% z = 0;

% n = (0:N).';
nu0 = 0.5;
tic
H = exp(HankelHLog_Rothwell(N, z, 'nu0', nu0));
H = H(end);
% J = real(J) + wrapToPi(imag(J));
toc
H_exact = (besselh(N+nu0, z));

err = H - H_exact;
[~, rel_err] = Error(H_exact, H);

fprintf("J_exact = %g %+gi\n", real(H_exact), imag(H_exact))
fprintf("J = %g %+gi\n", real(H), imag(H))
fprintf("Error = %g %+gi\n", real(err), imag(err))
fprintf("Relative error = %g %+gi\n", real(rel_err), imag(rel_err))