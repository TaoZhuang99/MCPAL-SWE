clear all
c0 = 343;
fu = 64.5e3;
fa = 1e3;
f1 = fu + fa/2;
f2 = fu - fa/2;
% humidity = 60;
% temperature = 25;
ka = 2*pi*fa/c0 + 1i*6.9e-4;
k1 = 2*pi*f1/c0 + 1i*.3;
k2 = 2*pi*f2/c0 + 1i*.29;

a = 0.1;
r = a;

max_l = 0;

gauss_num = (2:100).';

radial3 = gauss_num  * 0;
for i = 1:length(gauss_num)
    fprintf("Processing %d of %d...\n", i, length(gauss_num));
    tic
    radial3(i) = PalCircSrcSweRadial3Exterior(...
        ka, k1, k2, ...
        a, r, max_l, ...
        'gauss_num', gauss_num(i),...
        'method', 'complex');
    toc
end

figure;
plot(gauss_num, real(radial3));
hold on
plot(gauss_num, imag(radial3))
