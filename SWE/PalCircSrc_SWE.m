% =========================================================================
% INTRO
%   - Calculate the radiation from a circular PAL with the Zernike mode
%   - Method: spherical wave expansion (SWE) 
%   - Modified based on PAL_SWE_220201A.m
% -------------------------------------------------------------------------
% INPUT
%   - k, the wavenumber for audio sound
%   - k1, k2, the wavenumber for ultrasound
%   - a, the radius of the radiator
%   - r, the radial coordinate
%   - theta, the zenithal coordinate
%   - phi, the azimuthal coordinate
%   - n1, m1, Zernike mode for ultrasound 1
%   - n2, m2, Zernike mode for ultrasound 2
%   - max_l, maximum order for SWE
% -------------------------------------------------------------------------
% DIMENSION
%   - 1: fp.r 
%   - 2: fp.theta
%   - 3: fp.phi
%   - 4: la
% =========================================================================
function prs = PalCircSrc_SWE(pal, fp, varargin)

    validateattributes(fp.r, {'numeric'}, {'column'});
    validateattributes(fp.theta, {'numeric'}, {'row', '>=', 0, '<=', pi});
    validateattributes(fp.phi, {'numeric'}, {'size', [1, 1, nan]});

	ip = inputParser;
    % the governing equation to be used 
	ip.addParameter('eqn', 'Westervelt', @(x)any(validatestring(x, {'Westervelt', 'WesterveltCorrection', 'Kuznetsov'})));
    % Calculate the sound pressure using the inward extrapolated farfield pressure
	ip.addParameter('is_farfield', false, @(x)validateattributes(x, {'logical'}, {'scalar'}));
    ip.addParameter('la_max', ceil(real(pal.audio.num)*pal.src_ultra.radius*30));
    ip.addParameter('l1_max', ceil(real(pal.ultra_low.num)*pal.src_ultra.radius*1.2));
    ip.addParameter('l2_max', ceil(real(pal.ultra_high.num)*pal.src_ultra.radius*1.2));
    % mute the displayed info
    ip.addParameter('is_mute', true, @(x)validateattributes(x, {'logical'}, {'scalar'}));
	parse(ip, varargin{:});
	ip = ip.Results;

    time0 = tic;
    if ~ip.is_mute
        fprintf("====================Running PalCircSrc_SWE.m====================\n");
        fprintf("Ultrasound frequencies: %d Hz and %d Hz\n", pal.ultra_low.freq, pal.ultra_high.freq);
        fprintf("Audio frequency: %d Hz\n", pal.audio.freq);
    end

    % spherical modes
	la = permute((0:ip.la_max).', [4,2,3,1]);

    % azimuthal order for the audio sound
    ma = pal.src_high.prf.azimuth_order - pal.src_low.prf.azimuth_order;

    % dim: la -> 1 -> theta -> phi
    Ya = SphHarmonic(2*la(:) + abs(ma), ma, ...
        permute(fp.theta, [1,3,2]), ...
        permute(fp.phi, [1,2,4,3]));
    % dim: 1 -> theta -> phi -> la
    Ya = permute(permute(permute(Ya, [1,3,2,4]), [1,2,4,3]), [4,2,3,1]);

    R = PalCircSrc_SWE_Radial(pal, fp.r, ...
        ip.la_max, ip.l1_max, ip.l2_max, ...
        'is_farfield', ip.is_farfield);

    prs = 16 * pi^2 * 1.2 * 1.21 / 1i .* sum(R .* Ya, 4);

    time0 = toc(time0);
    if ~ip.is_mute
        fprintf("Elapsed time is %gs.\n", time0);
        fprintf("====================Finished PalCircSrc_SWE.m====================\n");
    end
end
