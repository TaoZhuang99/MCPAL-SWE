N = 10;
z = logspace(-3, 6, 2e2) + 1i*1;
% z = li;
n = (-10:10).';
nu0 = 0;
kind = 2;

H = exp(HankelHLog(n, z, 'nu0', nu0, 'kind', kind));
H = H(end, :);
H_exact = (besselh(N+nu0, kind, z));

% err = H - H_exact;
% rel_err = abs(real(err) ./ real(H_exact)) ...
%     + 1i * (abs(wrapToPi(imag(err)) ./ imag(H_exact)));
[err, rel_err] = Error(H_exact, H, 'input_is_log', false);

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
max(abs(rel_err(:)))