%% Paraments setting
clear;

% fp.x = 0;
% fp.z = linspace(0, 2, 4e1).';

fp.x = 0;
fp.z = 0.1;

elem.num = 10;
elem.gap = 0.01;
elem.posi = ((1-elem.num):2:(elem.num-1))*(elem.gap/2);
elem.x_max = elem.posi(end);
elem.rad = 0.005;

corrOrder = 2; % correction order

audio_freq = 1e3;
ultra_freq = 40e3;

k_u = 2*pi*ultra_freq/343;
max_order = ceil(2*elem.rad*k_u); % max order in SWE

%% Single PAL setting

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', elem.rad, 'prf', prf);
pal = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);

%% Audio sound field by single PAL

tic;
prs_single_temp = 0*elem.posi.*fp.z;
for i = 1:elem.num
    for j = 1:length(fp.z)
    
        fp_single = Point3D('x', fp.x-elem.posi(i), 'y', 0, 'z', fp.z(j));
        fp_single.Cart2Sph();
    
        prs_single_temp(j,i) = PalCircSrc_SWE(pal, fp_single, 'la_max', max_order);
    end
end
prs_single = sum(prs_single_temp, 2);
toc;

%% Coupled audio sound of n-th correction

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', elem.rad, 'prf', prf);
pal1 = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);
pal2 = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);

prs_couple_temp = zeros(length(fp.z), corrOrder, elem.num);

for k = 1:corrOrder
    tic
    nuMax = 15; % nuMax in addition theorem
%     nuMax = 2*ceil(k_u*exp(1)*elem.gap*k/4); % nuMax in addition theorem

    b1 = Point3D('x',elem.gap*k/2,'y',0,'z',0);
    b1.Cart2Sph;
    b2 = Point3D('x',-elem.gap*k/2,'y',0,'z',0);
    b2.Cart2Sph;
    T1 = T_additionCoeff_ext(2*max_order, nuMax, pal1.ultra_high.num, b1, src.radius);
    T2 = T_additionCoeff_ext(2*max_order, nuMax, pal2.ultra_low.num, b2, src.radius);
    Gaunt_coeff = Gaunt_coeff_audio_new(nuMax);

    for i = 1:(elem.num-k)
        for j = 1:length(fp.z)
        
            fp_couple = Point3D('x', fp.x-(elem.posi(i)+elem.gap*k/2), 'y', 0, 'z', fp.z(j));
            fp_couple.Cart2Sph();
        
            prs_couple_temp(j, k, i) = CircPal_SWE_Addition_new_0328(pal1, pal2, fp_couple, nuMax, T1, T2, Gaunt_coeff, b1.r);
        end
    end
    toc
end
%%
prs_couple = sum(prs_couple_temp, 3);
prs_couple = prs_couple*2;

%% 

u02 = 0.1^2;

prs = zeros(length(fp.z), corrOrder+1);
prs(:, 1) = prs_single;
for k = 1:corrOrder
    prs(:, k+1) = prs(:,k) + prs_couple(:, k);
end

spl_couple = prs2spl(prs_couple*u02);
spl_tot = prs2spl(prs*u02);

prs_origin = prs;

%% Save data

% save('SWE_Addi\data\audioSoundAxialAddi_01.mat', 'fp', 'prs', 'prs_couple');

%% Figure

% u0 = 0.1;
% % load('SWE_Addi\data\audioSoundAxialAddi_01.mat');
% 
% spl_line = prs2spl(u0^2*prs(:,1));
% spl_addi = prs2spl(u0^2*prs(:,2));
% fp_show = fp.z;
% 
% % F_addi = griddedInterpolant(dataAddi.fp.theta, spl_addi, 'pchip');
% 
% % fp_inte = linspace(0, pi/2, 91);
% figure;
% plot(fp_show, spl_line);
% hold on
% plot(fp_show, spl_addi);
% 
% dataExac = load('SWE_Addi\data\Exact_couple_axial_10mm_prs.mat');
% spl_exac = prs2spl(u0^2*dataExac.prs);
% F_exac = griddedInterpolant(dataExac.z, spl_exac, 'pchip');
% 
% exac_show = F_exac(fp.z);
% 
% plot(fp.z, exac_show);
% hold off
