% Test 2D sound fields

clear all
% prf.name = 'uniform';

prf = SrcProfile('name', 'quadratic', 'order', 0);
src_low = CircSrc('radius', .1, 'prf', prf, 'freq', 40e3);
src_high = CircSrc('radius', .1, 'prf', prf, 'freq', 41e3);

% fp = Point3D('r', logspace(-3, 1, 2e2).', ...
%     'theta', linspace(0, pi/2, 1e2), ...
%     'phi', permute([0; pi], [3, 2, 1]));
fp = Point3D('r', linspace(0, 2.4, 1e3).', ...
    'theta', linspace(0, pi/2, 5e2), ...
    'phi', permute([0; pi], [3, 2, 1]));
fp.Sph2Cart();

prs_low = CircSrc_SWE(src_low, fp, 'max_order', 100);
spl_low = PrsToSpl(prs_low);
prs_high = CircSrc_SWE(src_high, fp, 'max_order', 100);
spl_high = PrsToSpl(prs_high);

q = prs_high .* conj(prs_low);
q_lvl = PrsToSpl(q);

z = [flipud(fp.z.'); fp.z.'];
x = [flipud(fp.x(:,:,2).'); fp.x(:,:,1).'];
q_show = [flipud(q(:,:,2).'); q(:,:,1).'];
q_lvl_show = [flipud(q_lvl(:,:,2).'); q_lvl(:,:,1).'];

%% 2D field
fig = Figure;
% pcolor(z, x, q_lvl_show)
pcolor(z, x, wrapToPi(angle(q_show)))
fig.Init;
xlim([0,2])
ylim([-.7,.7])
% caxis([80,120])

%% Axial field
r_axis = fp.r;
spl_axis = q_lvl(:,1,1);

fig_axis = Figure;
plot(r_axis, spl_axis)
fig_axis.hAxes.XScale = 'log';