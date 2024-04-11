
freq = linspace(0e3, 100e3, 2e2).';

humidity = (0:20:100);

absorp = 0 * freq .* humidity;
for i = 1:length(humidity)
    absorp(:,i) = AbsorpAttenCoef(freq, 'temperature', 20, 'humidity', humidity(i));
end


figure;
plot(freq/1e3, absorp)