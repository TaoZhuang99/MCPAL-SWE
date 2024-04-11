x = linspace(0,10).';
f = Tan_ContFrac(x);
f0 = tan(x);

figure;
subplot(211)
plot(x, f0)
hold on
plot(x, f)

subplot(212)
rel_err = abs((f0 - f)./f0);
plot(x, rel_err)
