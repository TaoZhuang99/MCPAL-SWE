N = 100;
z = 1e2+1i;
% z = 0;
n = (-N:N).';

tic
H = exp(HankelHLog(n, z));
toc
H_exact = (besselh(n, z));

err = H - H_exact;
rel_err = abs(real(err) ./ real(H_exact)) ...
    + 1i * abs(imag(err) ./ imag(H_exact));

figure
subplot(311)
plot(n, real(H_exact))
hold on
plot(n, real(H));
legend({"Exact", 'Calc'})
subplot(312)
plot(n, imag(H_exact))
hold on
plot(n, imag(H));

subplot(313)
plot(n, real(rel_err))
hold on
plot(n, imag(rel_err))
legend({'Real', 'Imag'})
title('Relative error')
