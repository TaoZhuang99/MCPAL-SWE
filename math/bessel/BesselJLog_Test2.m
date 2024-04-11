clear all
N = 1e1;
z = logspace(-1, 9, 2e2) + 1i*1;
% z = li;
nu0 = 0.5;

J = exp(BesselJLog(N, z, 'nu0', nu0));
% J = exp(BesselJLog_Rothwell(N, z, 'nu0', nu0));
% J = J(end, :);
J_exact = (besselj(N+nu0, z));

[err, rel_err] = Error(J_exact, J);

figure
subplot(311)
plot(real(z), real(J_exact))
hold on
plot(real(z), real(J));
legend({"Exact", 'Calc'})
subplot(312)
plot(real(z), imag(J_exact))
hold on
plot(real(z), imag(J));

subplot(313)
plot(real(z), real(rel_err))
hold on
plot(real(z), imag(rel_err))
legend({'Real', 'Imag'})
title('Relative error')
