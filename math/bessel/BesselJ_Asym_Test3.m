clear all
m = (-1e2:1e2).';
arg = logspace(1, 8, 1e3) * (1+0.001*1i);

J0 = 0 * m .* arg;
tic
for i = 1:length(m)
    J0(i,:) = log(besselj(m(i), arg, 1)) + abs(imag(arg));
end
toc

% J0 = besselh(m, kind, arg);
tic
J = BesselJ_Asym(m, arg, 'approx_order', 1e5, ...
    'is_log', true, 'tol', 1e-15);
toc

[~, rel_err] = Error(J0, J, 'input_is_log', true);

fig = Figure;
pcolor(log10(abs(real(arg))), m, log10(abs(real(rel_err))));
fig.Init;

fig = Figure;
pcolor(log10(abs(real(arg))), m, log10(abs(imag(rel_err))));
fig.Init;
