% Test the axial field

% close all
clear all

prf = SrcProfile('name', 'uniform');
% prf = SrcProfile('name', 'quadratic', 'order', 1);
src = CircSrc('radius', .1, 'prf', prf);
pal = PalSrc('audio_freq', 1e3, 'ultra_freq', 40e3, 'src', src);

fp = Point3D('r', linspace(0, 0.3, 4e1).', ...
    'theta', 0, ...
    'phi', 0);
fp.Sph2Cart();


prs = PalCircSrc_SWE(pal, fp, 'la_max', 30);
spl = PrsToSpl(prs);

%% Axial field
fig_axis = Figure;
plot(fp.r, spl);
xlabel('r (m)')
ylabel('SPL (dB)')