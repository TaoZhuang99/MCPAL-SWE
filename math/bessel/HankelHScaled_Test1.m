N = 10;
z = logspace(-3, 1, 2e2) + 1i*1;
% z = li;
n = N;

H = HankelHScaled(n, z, 'is_log', true);
H = H(end, :);
H_exact = log(besselh(n, 1, z, 1));

err = H - H_exact;
rel_err = abs(real(err) ./ real(H_exact)) ...
    + 1i * (abs(wrapToPi(imag(err)) ./ imag(H_exact)));

figure
subplot(311)
plot(real(z), real(H_exact))
hold on
plot(real(z), real(H));
legend({"Exact", 'Calc'})
subplot(312)
plot(real(z), imag(H_exact))
hold on
plot(real(z), wrapToPi(imag(H)));

subplot(313)
plot(real(z), real(rel_err))
hold on
plot(real(z), imag(rel_err))
legend({'Real', 'Imag'})
title('Relative error')
