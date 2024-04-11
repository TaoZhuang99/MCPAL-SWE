m = 10+.5;
arg = logspace(0, 8, 1e3).' * (1+0.001*1i);

% J0 = log(besselj(m, arg));
J0 = log(besselj(m, arg, 1)) + abs(imag(arg));
J = BesselJ_Asym(m, arg, 'approx_order', 1e3, 'is_log', true);

[~, rel_err] = Error(J0, J, 'input_is_log', true);

figure;
subplot(211)
plot(log10(real(arg)), real(J0))
hold on
plot(log10(real(arg)), real(J), '--')
subplot(212)
semilogy(log10(real(arg)), (abs(real(rel_err))))

figure;
subplot(211)
plot(log10(real(arg)), imag(J0))
hold on
semilogx(log10(real(arg)), imag(J), '--')
subplot(212)
semilogy(log10(real(arg)), (abs(imag(rel_err))))

