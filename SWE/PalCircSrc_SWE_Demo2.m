% close all
clear

prf = SrcProfile('name', 'uniform');
% prf = SrcProfile('name', 'quadratic', 'order', 1);
src = CircSrc('radius', .005, 'prf', prf);

audio_freq = 1e3;

pal = PalSrc('audio_freq', audio_freq, 'ultra_freq', 40e3, 'src', src);

fp = Point3D('r', linspace(0, 3.4, 5e1).', ...
    'theta', linspace(0, pi/2, 6e1), ...
    'phi', permute([0; pi], [3, 2, 1]));
% fp = Point3D('r', 0, ...
%     'theta', 0, ...
%     'phi', 0);
fp.Sph2Cart();
 
prs = PalCircSrc_SWE(pal, fp, 'la_max', 40);

% prs_low = CircPiston_Direct_Tao(pal.ultra_low.num, 0.1, ...
%     fp.x, fp.y, fp.z,'profile_type','uniform');
% prs_high = CircPiston_Direct_Tao(pal.ultra_high.num, 0.1, ...
%     fp.x, fp.y, fp.z,'profile_type','uniform');
% 
% lag = 1.21/2 .* (vel_high.x .* conj(vel_low.x) ...
%     + vel_high.z .* conj(vel_low.z)) ...
% 	- (pal.ultra_low.freq / pal.ultra_high.freq ...
%     + pal.ultra_high.freq / pal.ultra_low.freq - 1) ...
%     ./(2*1.21*343^2) .* (prs_high .* conj(prs_low));

%%
% prs_ref = prs - lag;
% save("Tao\steerable focal PAL\Focal_effect_RefPrs.mat", "prs_ref","audio_freq");

spl = PrsToSpl(prs);

fp_z_show = [flipud(fp.z(2:end,:)); fp.z];
fp_x_show = [flipud(fp.x(2:end,:,2)); fp.x(:,:,1)];
spl_show = [flipud(spl(2:end,:,2)); spl(:,:,1)];

%% 2D field
fig = Figure;
% pcolor(fp.z(:,:,1), fp.x(:,:,1), spl(:,:,1));
pcolor(fp_z_show, fp_x_show, spl_show);
fig.Init;
ylim([-1.5,1.5]);
xlim([0,3])

%% Axial field
fig_axis = Figure;
plot(fp.r, spl(:,1,1));
xlabel('z (m)')
ylabel('SPL (dB)')