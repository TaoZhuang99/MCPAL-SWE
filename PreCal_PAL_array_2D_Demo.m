%% parameters setting
clear

delta_x1 = 0.01; % 1-st correction

b11 = Point3D('x', delta_x1/2,'y',0,'z',0);
b11.Cart2Sph;
b21 = Point3D('x', -delta_x1/2,'y',0,'z',0);
b21.Cart2Sph;

delta_x2= 0.02; % 2-nd correction

b12 = Point3D('x', delta_x2/2,'y',0,'z',0);
b12.Cart2Sph;
b22 = Point3D('x', -delta_x2/2,'y',0,'z',0);
b22.Cart2Sph;

fa = 500; % audio sound frequency
fu = 40e3; % ultrasound frequency
element_radius = 3.15e-3; % radius of the element
u0 = 0.1; % surface vibration velocity
nuMax = 20; % max order of the summation

%% 2D field point setting

fp = Point3D('r', 0.1, ...
    'theta', pi/4, ...
    'phi', 0);

% fp = Point3D('r', linspace(0, 2.5, 200).', ...
%     'theta', linspace(0, 3*pi/4, 150), ...
%     'phi', vec2ndim([0 pi], 3));
% fp.Sph2Cart();

% fp = Point3D('r', 0, ...
%     'theta', 0, ...
%     'phi', 0);
% fp.Sph2Cart();

% fp = Point3D('r', 1, ...
%     'theta', linspace(0, pi/2, 30), ...
%     'phi', vec2ndim([0 pi], 3));
% fp.Sph2Cart();

%%

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', element_radius, 'prf', prf);
pal1 = PalSrc('audio_freq', fa, 'ultra_freq', fu, 'src', src);
pal2 = PalSrc('audio_freq', fa, 'ultra_freq', fu, 'src', src);

max_order = ceil(2*src.radius*real(pal1.ultra.num));

sum_coef.nu1 = vec2ndim(0:nuMax,1);
sum_coef.mu1 = vec2ndim(-nuMax:nuMax,2);
sum_coef.nu2 = vec2ndim(0:nuMax,3);
sum_coef.mu2 = vec2ndim(-nuMax:nuMax,4);

sum_coef.la = vec2ndim(0:(4*nuMax+1), 5);

%% T coefficients calculation

T11 = T_additionCoeff_ext(2*max_order, nuMax, pal1.ultra_high.num, b11, src.radius);
T21 = T_additionCoeff_ext(2*max_order, nuMax, pal2.ultra_low.num, b21, src.radius);

T12 = T_additionCoeff_ext(2*max_order, nuMax, pal1.ultra_high.num, b12, src.radius);
T22 = T_additionCoeff_ext(2*max_order, nuMax, pal2.ultra_low.num, b22, src.radius);

Gaunt_coeff = Gaunt_coeff_audio_new(nuMax);

%% Individual audio sound by the conventional SWE
prs = (u0^2)*PalCircSrc_SWE(pal1, fp, 'la_max', 25);
spl = PrsToSpl(prs);

%% Coupled audio sound by the additional SWE
% Y_tot dim: theta -> mu1 -> phi -> mu2 -> la

Y_tot = SphHarmonic_tot_0406(sum_coef.la, sum_coef.mu1, sum_coef.mu2, fp.theta, fp.phi);
prs_Addition1 = (u0^2)*CircPal_SWE_Addition_new_0406(pal1, pal2, fp, Y_tot, sum_coef, T11, T21, Gaunt_coeff, b11.r);
prs_Addition2 = (u0^2)*CircPal_SWE_Addition_new_0406(pal1, pal2, fp, Y_tot, sum_coef, T12, T22, Gaunt_coeff, b12.r);

% Y_tot dim: 1 -> mu1 -> 1 -> mu2 -> la -> theta -> phi

% Y_tot = permute(SphHarmonic_tot_0406(sum_coef.la, sum_coef.mu1, sum_coef.mu2, fp.theta, fp.phi), [6 2 7 4 5 1 3]);
% prs_Addition1 = (u0^2)*CircPal_SWE_Addition_new_0410(pal1, pal2, fp, Y_tot, sum_coef, T11, T21, Gaunt_coeff, b11.r);
% prs_Addition2 = (u0^2)*CircPal_SWE_Addition_new_0410(pal1, pal2, fp, Y_tot, sum_coef, T12, T22, Gaunt_coeff, b12.r);

%% save the individual audio sound and coupled audio sound of two elements

% save("data\CoupledAudioSound_2PAL_500Hz.mat", "prs_Addition1", "prs_Addition2", "prs", "fp");
