clear all

N = 10;
z = 2e1+1i*1;
% z = 0;

%% J
% n = (0:N).';
nu0 = 0;
tic
[J, J_prime] = BesselJLog_Rothwell(N, z, 'nu0', nu0, 'is_cal_derivative', true);
J = exp(J);
J = J(end);
% J = real(J) + wrapToPi(imag(J));
toc
J_exact = (besselj(N+nu0, z));

err = J - J_exact;
[~, rel_err] = Error(J_exact, J);

fprintf("J_exact = %g %+gi\n", real(J_exact), imag(J_exact))
fprintf("J = %g %+gi\n", real(J), imag(J))
fprintf("Error = %g %+gi\n", real(err), imag(err))
fprintf("Relative error = %g %+gi\n", real(rel_err), imag(rel_err))

%% J_prime
J_prime = exp(J_prime)