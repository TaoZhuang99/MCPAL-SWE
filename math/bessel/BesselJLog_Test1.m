N = 400;
z = -1e1-1i;
% z = 0;
n = (0:N).';
nu0 = 00;
tic
J = exp(BesselJLog(n, z, 'nu0', nu0));
toc
J_exact = (besselj(n+nu0, z));

err = J - J_exact;
[~, rel_err] = Error(J_exact, J);

figure
subplot(311)
plot(n, real(J_exact))
hold on
plot(n, real(J));
legend({"Exact", 'Calc'})
subplot(312)
plot(n, imag(J_exact))
hold on
plot(n, imag(J));

subplot(313)
plot(n, real(rel_err))
hold on
plot(n, imag(rel_err))
legend({'Real', 'Imag'})
title('Relative error')
