% =========================================================================
% INTRO
%   - The velocity profile for a line source in a 2D radiation problem
% INPUT
%   - a: half-width of the source
%   - k: wavenumber
%   - x: coordinates
%   - prf: profile
% =========================================================================
function u = LineSrcProfile(a, k, x, prf, varargin)

%     ip = inputParser();
%     ip.addParameter('steer_angle', nan);
%     ip.parse(varargin{:});
%     ip = ip.Results;
    
    k = real(k);
    switch prf.name
        case 'uniform'
            u = 1;
        case 'steerable'
            u = exp(1i*k*x.*cos(prf.phi));
        case 'cosine'
            u = (cos(pi*x/2./a)).^prf.order;
        case 'hanning'
            u = (cos(pi*x/2./a)).^2;
        case 'hamming'
            u = (0.54 + 0.46 .* cos(pi*x./a));
        case 'blackman'
            u = 0.42 + 0.5 .* cos(pi.*x./a) + 0.08 .* cos(2*pi*x./a);
        case 'triangular'
            u = 1 - abs(x) ./ a;
        otherwise
            error('Wrong profile!')
    end
end
