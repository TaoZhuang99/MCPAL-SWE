classdef CircSrc < handle
    properties
        radius  % radius of the circular source
        prf     % the profile at each array element
        wav     % the wave info
        pos     % position of the source
        dir     % direction of the source
        
        z0      % critical distance of the circular source // tao
        u0      % velocity u0 // tao
    end

    properties (Dependent)
        elem_num % total number of array elements
    end

    properties (Constant)
        shape = 'circle';
    end

    methods
        function obj = CircSrc(varargin)
            ip = inputParser();
            ip.addParameter('wav', []);
            ip.addParameter('freq', []);
            ip.addParameter('radius', []);
            ip.addParameter('u0', 0.1);
            ip.addParameter('prf', []);
            ip.parse(varargin{:});
            ip = ip.Results;

            obj.radius = ip.radius;
            obj.u0 = ip.u0;
            if ~isempty(ip.freq)
                obj.wav = SoundWave('freq', ip.freq);
            else
                obj.wav = ip.wav;
            end
            obj.prf = ip.prf;
            
            obj.z0 = (ip.radius)^2*ip.freq/343; % critical distance of the circular source // tao
        end

        function u = CalProfile(obj, rs)
            switch obj.prf.name
                case 'uniform' 
                    u = 1;
                case 'quadratic'
                    u = (obj.prf.order + 1) .* (1 - (rs/obj.radius).^2).^obj.prf.order;
                case 'Zernike'
                    u = ZernikeRadial(obj.prf.degree, obj.prf.azimuth_order, rs/obj.radius);
                case 'focusing'
                    u = exp( - 1i * obj.wav.num * sqrt(rs.^2 + obj.prf.F^2)); % on-axis focal distance. // tao
                otherwise
                    error('Wrong profile type!')
            end
        end

        function dir = CalDirectivity(obj, theta, phi)
            theta = theta + 0*phi;
            phi = phi + 0*theta;
            switch obj.prf.name
                case 'uniform'
                    dir = Jinc(real(obj.wav.num)*obj.radius.*sin(theta));
                case 'steerable'
                    dir = Jinc(real(obj.wav.num) * obj.radius ...
                        .* sqrt((cos(obj.prf.phi) .* sin(obj.prf.theta) ...
                        - cos(phi) .* sin(theta)).^2 ...
                        + (sin(obj.prf.phi) .* sin(obj.prf.theta) ...
                        - sin(phi) .* sin(theta)).^2));
                case 'quadratic'
                    dir = exp((obj.prf.order + 1) .* log(2) ...
                        + gammaln(obj.prf.order+2) ...
                        - (obj.prf.order+1) .* log(obj.wav.num.*obj.radius.*sin(theta)) ...
                        + BesselJLog(obj.prf.order+1, obj.wav.num .* obj.radius.*sin(theta)));
                    dir(theta==0) = 1;
                otherwise
                    error('Wrong profile type!')
            end
        end

    end
end
