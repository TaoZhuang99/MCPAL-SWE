% close all
clear all

prf = SrcProfile('name', 'uniform');
% prf = SrcProfile('name', 'quadratic', 'order', 1);
src = CircSrc('radius', .1, 'prf', prf);
pal = PalSrc('audio_freq', 1e3, 'ultra_freq', 40e3, 'src', src);

fp = Point3D('r', linspace(0, 3.3, 5e1).', ...
    'theta', linspace(0, pi/2, 1e2), ...
    'phi', permute([0; pi], [3, 2, 1]));
fp.Sph2Cart();

tic
sph = 'j';
R = PalCircSrc_SWE_Int(pal, la, l1_max, l2_max, r1, r2, r, sph);
toc

ang = [-flip(fp.theta), fp.theta];
prs_show = [flip(prs(1,:,2)), prs(1,:,1)];
dir_exact = PrsToSpl(prs_show);
dir_exact = dir_exact - max(dir_exact);

%% obtained by convolution model
dir_conv_direct = PalPlanarSrc_Conv(pal, fp, 'type', 'direct');
dir_conv_direct = [flip(dir_conv_direct(1,:,2)), dir_conv_direct(1,:,1)];

dir_conv_improved = PalPlanarSrc_Conv(pal, fp, 'type', 'improved');
dir_conv_improved = [flip(dir_conv_improved(1,:,2)), dir_conv_improved(1,:,1)];

dir_Westervelt = PalPlanarSrc_Conv(pal, fp, 'type', 'Westervelt');
dir_Westervelt = [flip(dir_Westervelt(1,:,2)), dir_Westervelt(1,:,1)];


fig = Figure;
hold on
plot(ang/pi*180, dir_exact);
plot(ang/pi*180, dir_conv_direct, '-.')
plot(ang/pi*180, dir_conv_improved, '--')
% plot(ang/pi*180, dir_Westervelt, ':')
fig.Init;
legend({'Exact', 'Direct', 'Improved', 'Westervelt'})
fn = sprintf('PalCircSrc_SWE_TestDir_220825A_%dkHz_%dHz_%dcm_', ...
    pal.ultra.freq/1e3, pal.audio.freq, pal.src_ultra.radius*1e2);
title(sprintf('f = %d Hz, a = %d cm', pal.audio.freq, pal.src_ultra.radius*1e2))
save(['SWE/data/', fn, '.mat']);
% fig.ExportTikz('filename', ['SWE/fig/', fn, '.tex']);

fig_diff = Figure;
hold on
plot(ang/pi*180, abs(dir_exact - dir_conv_direct), '-.')
plot(ang/pi*180, abs(dir_exact - dir_conv_improved), '--')
% plot(ang/pi*180, abs(dir_exact - dir_Westervelt), ':')
fig_diff.Init;
legend({'Direct', 'Improved', 'Westervelt'})
title(sprintf('f = %d Hz, a = %d cm', pal.audio.freq, pal.src_ultra.radius*1e2))
