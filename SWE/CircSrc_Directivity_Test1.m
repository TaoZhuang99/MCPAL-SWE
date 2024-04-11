clear all

radius = 0.1;

prf.name = 'quadratic';
prf.order = 0;

% prf.name = 'steerable';
% prf.theta = 5/180*pi;
% prf.phi = 0;

src = CircSrc('freq', 40e3, 'radius', radius, 'prf', prf);

theta = linspace(0, pi/2, 5e2).';
phi = [0,pi];

dir = src.CalDirectivity(theta, phi);
dir = 20*log10(abs(dir));
dir = dir - max(dir(:));

theta_full = [-flip(theta); theta];
dir_full = [flip(dir(:,2)); dir(:,1)];

fig = Figure;
plot(theta_full/pi*180, dir_full);
% ylim([-90,0])
fig.Print('2d')
