m = 10;
arg = logspace(0, 4, 1e3).' * (1+0.001*1i);

kind = 2;
H0 = log(besselh(m, kind, arg, 1)) + (-1).^(kind+1).*1i*arg;
% H0 = besselh(m, kind, arg);
tic
H = HankelH_Asym(m, arg, 'approx_order', 1e4, ...
    'kind', kind, 'is_log', true, 'tol', 1e-15);
toc

[err,rel_err] = Error(H0, H, 'input_is_log', true);

figure;
subplot(211)
semilogx(real(arg), real(H0))
hold on
semilogx(real(arg), real(H), '--')
subplot(212)
loglog(real(arg), abs(real(rel_err)))

if imag(arg(1))~=0
    figure;
    subplot(211)
    semilogx(real(arg), imag(H0))
    hold on
    semilogx(real(arg), imag(H), '--')
    subplot(212)
    loglog(real(arg), abs(imag(rel_err)))
end
