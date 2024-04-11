clear all
f = 40e3;
k = 2*pi*f/343 + 1i*AbsorpAttenCoef(f)*10;
a = .2;
phi1 = 80/180*pi;
phi2 = 100/180*pi;
phi = linspace(phi1, phi2, 2e3).';

dir_uniform = LineSrcDirectivity(k, a, phi, 'profile', 'uniform');
dir_hanning = LineSrcDirectivity(k, a, phi, 'profile', 'hanning');
dir_hamming = LineSrcDirectivity(k, a, phi, 'profile', 'hamming');
dir_blackman = LineSrcDirectivity(k, a, phi, 'profile', 'blackman');
dir_triangular = LineSrcDirectivity(k, a, phi, 'profile', 'triangular');

figure;
plot(phi/pi*180, 20*log10(abs(dir_uniform)));
hold on
plot(phi/pi*180, 20*log10(abs(dir_hanning)));
plot(phi/pi*180, 20*log10(abs(dir_hamming)));
plot(phi/pi*180, 20*log10(abs(dir_blackman)));
plot(phi/pi*180, 20*log10(abs(dir_triangular)));
legend({'Uniform', 'Hanning', 'Hamming', 'Balckman', 'Triangular'});
