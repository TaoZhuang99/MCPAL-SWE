classdef Point3D < Point2D
    properties 
        z
        r  % the radius to the orgin
        theta % zenithal angle
    end

    methods
        function obj = Point3D(varargin)
            ip = inputParser();
            ip.addParameter('x', []);
            ip.addParameter('y', []);
            ip.addParameter('z', []);
            ip.addParameter('rho', []);
            ip.addParameter('phi', []);
            ip.addParameter('r', []);
            ip.addParameter('theta', []);
            ip.addParameter('type', []);
            ip.parse(varargin{:});
            ip = ip.Results;

            obj = obj@Point2D('x', ip.x, 'y', ip.y, 'rho', ip.rho, 'phi', ip.phi, 'type', ip.type);

            obj.z = ip.z;
            obj.r = ip.r;
            obj.theta = ip.theta;

            if ~isempty(ip.type)
                switch ip.type 
                    case 'origin'
                        obj.z = 0;
                        obj.r = 0;
                        obj.theta = 0;
                end
            end
        end

        function Cart2Sph(obj)
            obj.r = sqrt(obj.x.^2 + obj.y.^2 + obj.z.^2);
            obj.theta = acos(obj.z ./ obj.r);
            obj.phi = atan2(obj.y, obj.x);
        end

        function Sph2Cart(obj)
            obj.x = obj.r .* sin(obj.theta) .* cos(obj.phi);
            obj.y = obj.r .* sin(obj.theta) .* sin(obj.phi);
            obj.z = obj.r .* cos(obj.theta);
        end

        function Cart2Cyl(obj)
            obj.rho = sqrt(obj.x.^2 + obj.y.^2);
            obj.phi = atan2(obj.y, obj.x);
        end
        
        function Cyl2Cart(obj)
            obj.x = obj.rho .* cos(obj.phi);
            obj.y = obj.rho .* sin(obj.phi);
        end
        
        function Print(obj)
            fprintf('x = %g, y = %g, z = %g\n', ...
                obj.x, obj.y, obj.z);
        end
        
        function Translate(obj, vec)
            obj.x = obj.x + vec.x;
            obj.y = obj.y + vec.y;
            obj.z = obj.z + vec.z;
        end
        
        % R: rotation matrix
        function Rotate(obj, R)
            x_new = obj.x * R(1,1) + obj.y * R(1,2) + obj.z * R(1,3);
            y_new = obj.x * R(2,1) + obj.y * R(2,2) + obj.z * R(2,3);
            z_new = obj.x * R(3,1) + obj.y * R(3,2) + obj.z * R(3,3);
            obj.x = x_new;
            obj.y = y_new;
            obj.z = z_new;
        end

        function dist = Distance(obj, p)
            dist = sqrt((obj.x - p.x).^2 + (obj.y - p.y).^2 + (obj.z - p.z).^2);
        end
    end
end

