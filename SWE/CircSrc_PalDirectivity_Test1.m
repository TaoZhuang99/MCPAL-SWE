clear all

src.shape = 'circle';
src.radius = 0.1;

src.prf.name = 'quadratic';
src.prf.order = 0;

% src.prf.name = 'steerable';
% src.prf.theta = 0/180*pi;
% src.prf.phi = pi;

pal = PalSrc('audio_freq', 4e3, 'ultra_freq', 40e3, 'src', src);

fp = Point3D('theta', linspace(0, pi/2).', ...
    'phi', [0,pi]);

dir = PalPlanarSrc_Conv(pal, fp, 'type', 'improved', 'is_norm', true);
% dir = 20*log10(abs(dir));
% dir = dir - max(dir(:));

theta_full = [-flip(fp.theta); fp.theta];
dir_full = [flip(dir(:,2)); dir(:,1)];

fig = Figure;
plot(theta_full/pi*180, dir_full);
% ylim([-90,0])
