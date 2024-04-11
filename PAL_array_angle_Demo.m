%% Paraments setting
clear;

fp.theta = linspace(-pi/2,pi/2,51).';
fp.r = 1;

elem.num = 2;
elem.gap = 0.01;
elem.posi = ((1-elem.num):2:(elem.num-1))*(elem.gap/2);
elem.x_max = elem.posi(end);
elem.rad = 0.005;

corrOrder = 1; % correction order

audio_freq = 1e3;
ultra_freq = 40e3;
f_1 = ultra_freq + audio_freq/2;
f_2 = ultra_freq - audio_freq/2;

k_u = 2*pi*ultra_freq/343;
k_1 = 2*pi*f_1/343;
k_2 = 2*pi*f_2/343;
max_order = ceil(2*elem.rad*k_u); % max order in SWE

u0 = 0.1;

%% Single PAL setting

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', elem.rad, 'prf', prf);
pal = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);

%% Audio sound field by single PAL

tic;
prs_single_temp = 0*elem.posi.*fp.theta;
for i = 1:elem.num
    for j = 1:length(fp.theta)

        fp_single = Point3D('x', fp.r*sin(fp.theta(j))-elem.posi(i), 'y', 0, 'z', fp.r*cos(fp.theta(j)));
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

prs_couple_temp = zeros(length(fp.theta), corrOrder, elem.num);

for k = 1:corrOrder
    tic
%     nuMax = 2*ceil(k_u*exp(1)*elem.gap*k/4); % nuMax in addition theorem
    nuMax = 12; % nuMax in addition theorem

    b1 = Point3D('x',elem.gap*k/2,'y',0,'z',0);
    b1.Cart2Sph;
    b2 = Point3D('x',-elem.gap*k/2,'y',0,'z',0);
    b2.Cart2Sph;
    T1 = T_additionCoeff_ext(2*max_order, nuMax, pal1.ultra_high.num, b1, src.radius);
    T2 = T_additionCoeff_ext(2*max_order, nuMax, pal2.ultra_low.num, b2, src.radius);
    Gaunt_coeff = Gaunt_coeff_audio_new(nuMax);

    for i = 1:(elem.num-k)
        for j = 1:length(fp.theta)
        
            fp_couple = Point3D('x', fp.r*sin(fp.theta(j))-(elem.posi(i)+elem.gap*k/2), 'y', 0, 'z', fp.r*cos(fp.theta(j)));
            fp_couple.Cart2Sph();
        
            prs_couple_temp(j, k, i) = CircPal_SWE_Addition_new(pal1, pal2, fp_couple, nuMax, T1, T2, Gaunt_coeff, b1.r);
        end
    end
    toc
end
%%
prs_couple = sum(prs_couple_temp, 3);

%% 

prs_couple = prs_couple*2;

prs = zeros(length(fp.theta), corrOrder+1);
prs(:, 1) = prs_single;
for k = 1:corrOrder
    prs(:, k+1) = prs(:,k) + prs_couple(:, k);
end

spl_couple = prs2spl(prs_couple);
spl_tot = prs2spl(prs);

%% figure

% spl_tot = prs2spl(prs);

% x = fp.theta/pi*180;
% y = [spl_tot(:,1), spl_tot(:,3)];
% word.leg = ["Uncoupled audio sound"; "2nd order correction"];
% % word.leg = ["Without coupled audio sound"; "1st order correction"; "2nd order correction"; "3rd order correction"];
% 
% word.titl = "";
% word.x_label = "Theta (degree)";
% word.y_label = "SPL (dB)";
% mark.num = 10;
% mark.step = 0.5;
% % myMultiPlot(x,y,word,"line",mark)
% myMultiPlot(x,y,word,"line",mark,'start',1);

%%
% save('PAL_array_pic\data\audioSoundAngularAddi_1.mat', 'fp', 'prs', 'prs_couple');

%%
u0 = 0.1;
dataAddi = load('PAL_array_pic\data\audioSoundAngularAddi_1.mat');

spl_line = prs2spl(u0^2*dataAddi.prs(:,1));
spl_addi = prs2spl(u0^2*dataAddi.prs(:,2));
F_addi = griddedInterpolant(dataAddi.fp.theta, spl_addi, 'pchip');

fp_inte = linspace(-pi/2, pi/2, 91);
figure;
plot(dataAddi.fp.theta/pi*180, spl_line);
hold on
plot(fp_inte/pi*180, F_addi(fp_inte));

dataExac = load('Exact_couple_angle_01_prs2.mat');
spl_exac = prs2spl(u0^2*dataExac.prs);
F_exac = griddedInterpolant(dataExac.theta, spl_exac, 'pchip');

plot(fp_inte/pi*180, F_exac(fp_inte));
hold off

%%

% spl_ext = prs2spl(prs);
% x = fp.theta/pi*180;
% y = [spl_ext.',spl_tot];
% word.leg = ["Without coupled audio sound"; "1st order correction"; "2nd order correction"; "3rd order correction"];
% word.titl = "";
% word.x_label = "Theta (degree)";
% word.y_label = "SPL (dB)";
% mark.num = 10;
% mark.step = 0.5;
% myMultiPlot(x,y,word,"line",mark)

%%

% x = fp.theta/pi*180;
% y = spl_couple;
% word.leg = ["1st order coupled audio SPL"; "2nd order coupled audio SPL"; "3rd order coupled audio SPL"];
% word.titl = "";
% word.x_label = "Theta (degree)";
% word.y_label = "SPL (dB)";
% mark.num = 10;
% mark.step = 0.5;
% myMultiPlot(x,y,word,"line",mark)
