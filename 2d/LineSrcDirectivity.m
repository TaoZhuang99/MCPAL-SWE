% =========================================================================
% INTRO
%   - Calculate the directivity of a line source in a 2D problem
% -------------------------------------------------------------------------
% INPUT
%   - k: the wavenumber
%   - a: the half-width of the line source
%   - phi: the angle
% =========================================================================
function dir = LineSrcDirectivity(k, a, phi, varargin)

    validateattributes(k, {'numeric'}, {});
    validateattributes(a, {'numeric'}, {'>=', 0});

    ip = inputParser();
    ip.addParameter('profile', 'uniform');
    % ip.addParameter('profile', 'uniform', @(x)any(validatestring(x, {'uniform', 'steerable'})));
    ip.addParameter('steer_angle', nan);
    ip.parse(varargin{:});
    ip = ip.Results;

    k = real(k);
    kx = k .* cos(phi);
    switch ip.profile
        case 'uniform'
            dir = sinc(kx .* a / pi);
        case 'steerable'
            dir = sinc(k.*a.*(cos(phi) - cos(ip.steer_angle)) / pi);
        case 'cosine'
            dir = 4*a/pi .* cos(kx .* a) ./ (1 - (2*kx.*a/pi).^2);
        case 'hanning'
            dir = sinc(kx.*a/pi) ./ (1-(kx.*a/pi).^2);
        case 'hamming'
            dir = sinc(kx.*a/pi) .* (1.08 - 0.16*(kx.*a/pi).^2) ./ (1-(kx.*a/pi).^2) / 1.08;
        case 'blackman'
            dir = sinc(kx.*a/pi) .* (0.84 + (kx.*a/pi).^2 ./ (1 - (kx.*a/pi).^2) - .16.*(kx.*a/2/pi).^2 ./ (1 - (kx.*a/2/pi).^2)) / 0.84;
        case 'triangular'
            dir = (sinc(kx.*a/2/pi)).^2;
        otherwise
            error('Wrong profile!');
    end

end
