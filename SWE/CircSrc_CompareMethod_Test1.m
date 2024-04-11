% compare the ultrasound field obtained using different methods
clear all

c0 = 343;
a = 0.005;
f = 40e3;
k = 2*pi*f/c0 + 1i*AbsorpAttenCoef(f);

r = logspace(-3, 1, 2e2);
theta = 70/180*pi;
z = r .* cos(theta);
x = r .* sin(theta);
y = 0;

prs_swe = CircSrcSweExterior(k, a, r, theta, 'max_order', 4);
spl_swe = PrsToSpl(prs_swe);

prs_gbe = CircSrc_GBE(k, a, x, z) * 343*1.21;
spl_gbe =  prs2spl(prs_gbe);

prs_direct = CircPiston_Direct(k, a, x, y, z, 'gauss_num', 100) * 343*1.21;
spl_direct = PrsToSpl(prs_direct);

fig = Figure;
plot(r, spl_direct)
hold on
plot(r, spl_swe, '-.')
plot(r, spl_gbe, '--')
ylim([90,150])