% Test 2D sound fields
clear all

prf = SrcProfile('name', 'uniform');
% prf = SrcProfile('name', 'quadratic', 'order', 1);
% prf = SrcProfile('name', 'focusing', 'F', 0.1);

% prf = SrcProfile('name', 'Zernike', 'degree', 0, 'azimuth_order', 0);

src = CircSrc('radius', .1, 'prf', prf, 'freq', 40e3);

fp = Point3D('r', logspace(-3, 1, 2e2).', ...
    'theta', linspace(0, pi/2, 1e2), ...
    'phi', permute([0; pi], [3, 2, 1]));
fp.Sph2Cart();

prs = CircSrc_SWE(src, fp);
spl = PrsToSpl(prs);

z = [flipud(fp.z.'); fp.z.'];
x = [flipud(fp.x(:,:,2).'); fp.x(:,:,1).'];
spl_show = [flipud(spl(:,:,2).'); spl(:,:,1).'];

%% 2D field
fig = Figure;
pcolor(z, x, spl_show)
fig.Init;
xlim([0,2])
ylim([-.7,.7])
% caxis([80,120])

%% Axial field
r_axis = fp.r;
spl_axis = spl(:,1,1);

fig_axis = Figure;
plot(r_axis, spl_axis)
fig_axis.hAxes.XScale = 'log';