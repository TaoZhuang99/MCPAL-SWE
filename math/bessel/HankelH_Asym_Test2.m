m = (-1e2:1e2).';
arg = logspace(-3, 8, 1e3) * (1+0.001*1i);

kind = 2;
H0 = 0 * m .* arg;
tic
for i = 1:length(m)
    H0(i,:) = log(besselh(m(i), kind, arg, 1)) + (-1).^(kind+1).*1i*arg;
end
toc

% H0 = besselh(m, kind, arg);
tic
H = HankelH_Asym(m, arg, 'approx_order', 1e3, ...
    'kind', kind, 'is_log', true, 'tol', 1e-15);
toc

[~, rel_err] = Error(H0, H, 'input_is_log', true);

fig = Figure;
pcolor(log10(abs(real(arg))), m, log10(abs(real(rel_err))));
fig.Init;