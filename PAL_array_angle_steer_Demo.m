%% Paraments setting
clear;

fp.theta = pi/2*linspace(-1,1,51).';
fp.r = 1;
steer_angle = 20*pi/180;

elem.num = 10;
elem.gap = 0.01;
elem.posi = ((1-elem.num):2:(elem.num-1))*(elem.gap/2);
elem.x_max = elem.posi(end);
elem.rad = 0.005;

corrOrder = 3; % correction order

audio_freq = 500;
ultra_freq = 40e3;
f_1 = ultra_freq + audio_freq/2;
f_2 = ultra_freq - audio_freq/2;

k_u = 2*pi*ultra_freq/343;
k_1 = 2*pi*f_1/343;
k_2 = 2*pi*f_2/343;
max_order = ceil(2*elem.rad*k_u); % max order in SWE

%% Single PAL setting

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', elem.rad, 'prf', prf);
pal = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);

%% Audio sound field by single PAL

tic;
prs_single_temp = 0*elem.posi.*fp.theta;
steer_coeff1 = exp(1i*k_1*sin(steer_angle)*elem.posi);
steer_coeff2 = exp(-1i*k_2*sin(steer_angle)*elem.posi);
for i = 1:elem.num
    for j = 1:length(fp.theta)

        fp_single = Point3D('x', fp.r*sin(fp.theta(j))-elem.posi(i), 'y', 0, 'z', fp.r*cos(fp.theta(j)));
        fp_single.Cart2Sph();
    
        prs_single_temp(j,i) = PalCircSrc_SWE(pal, fp_single, 'la_max', max_order);
    end
end
prs_single = sum(steer_coeff1.*steer_coeff2.*prs_single_temp, 2);
toc;

%% Coupled audio sound of n-th correction

prf = SrcProfile('name', 'uniform');
src = CircSrc('radius', elem.rad, 'prf', prf);
pal1 = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);
pal2 = PalSrc('audio_freq', audio_freq, 'ultra_freq', ultra_freq, 'src', src);

prs_couple_temp = zeros(length(fp.theta), corrOrder, elem.num);

for k = 1:corrOrder
    tic
%     nuMax = ceil(k_u*exp(1)*elem.gap*k/4); % nuMax in addition theorem
    nuMax = 20;

    b1 = Point3D('x',elem.gap*k/2,'y',0,'z',0);
    b1.Cart2Sph;
    b2 = Point3D('x',-elem.gap*k/2,'y',0,'z',0);
    b2.Cart2Sph;
    T1 = T_additionCoeff_ext(2*max_order, nuMax, real(pal1.ultra_high.num), b1, src.radius);
    T2 = T_additionCoeff_ext(2*max_order, nuMax, real(pal2.ultra_low.num), b2, src.radius);
    Gaunt_coeff = Gaunt_coeff_audio_new(nuMax);

    for i = 1:(elem.num-k)
        sc11 = steer_coeff1(i);
        sc22 = steer_coeff2(i+k);
        sc12 = steer_coeff2(i);
        sc21 = steer_coeff1(i+k);
        for j = 1:length(fp.theta)
        
            fp_couple = Point3D('x', fp.r*sin(fp.theta(j))-(elem.posi(i)+elem.gap*k/2), 'y', 0, 'z', fp.r*cos(fp.theta(j)));
            fp_couple.Cart2Sph();
        
            prs_couple_temp(j, k, i) = (sc11*sc22 + sc12*sc21) *... 
                CircPal_SWE_Addition_new(pal1, pal2, fp_couple, nuMax, T1, T2, Gaunt_coeff, b1.r);
        end
    end
    toc
end
prs_couple = sum(prs_couple_temp, 3);

%% 

prs = zeros(length(fp.theta), corrOrder+1);
prs(:, 1) = prs_single;
for k = 1:corrOrder
    prs(:, k+1) = prs(:,k) + prs_couple(:, k);
end

spl_couple = prs2spl(prs_couple);
spl = prs2spl(prs);

%% figure
spl = prs2spl(prs);
x = fp.theta/pi*180;
y = spl(:,1:3)-40;
y = [y(:,1), y(:,3)];
word.leg = ["Uncoupled audio sound"; "2nd order correction"];
word.titl = "";
word.x_label = "Theta (degree)";
word.y_label = "SPL (dB)";
mark.num = 10;
mark.step = 0.5;
myMultiPlot(x,y,word,"line",mark)

axis([-90 90 -2 18]);

%%

x = fp.theta/pi*180;
y = spl_couple;
word.leg = ["1st order coupled audio SPL"; "2nd order coupled audio SPL"; "3rd order coupled audio SPL"];
word.titl = "";
word.x_label = "Theta (degree)";
word.y_label = "SPL (dB)";
mark.num = 10;
mark.step = 0.5;
myMultiPlot(x,y,word,"line",mark)
