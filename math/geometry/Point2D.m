classdef Point2D < handle
    properties
        x
        y
        rho
        phi
    end

    methods
        function obj = Point2D(varargin)
            ip = inputParser();
            ip.addParameter('x', []);
            ip.addParameter('y', []);
            ip.addParameter('rho', []);
            ip.addParameter('phi', []);
            ip.addParameter('type', []);
            ip.parse(varargin{:});
            ip = ip.Results;
            
            obj.x = ip.x;
            obj.y = ip.y;
            obj.rho = ip.rho;
            obj.phi = ip.phi;

            if ~isempty(ip.type)
                switch ip.type 
                    case 'origin'
                        obj.x = 0;
                        obj.y = 0;
                        obj.rho = 0;
                        obj.phi = 0;
                end
            end
        end

        function Cart2Polar(obj)
            obj.rho = sqrt(obj.x.^2 + obj.y.^2);
            obj.phi = atan2(obj.y, obj.x);
        end

        function Polar2Cart(obj)
            obj.x = obj.rho .* cos(obj.phi);
            obj.y = obj.rho .* sin(obj.phi);
        end

        function Normalize(obj)
            rho = obj.x.^2 + obj.y.^2;
            obj.x = obj.x ./ rho;
            obj.y = obj.y ./ rho;
        end

        function res = Translate(obj, dir)
            validateattributes(dir, {'Point2D'}, {});

            res = Point2D();
            res.x = obj.x + dir.x;
            res.y = obj.y + dir.y;
        end

        function res = Rotate(obj, angle)
            validateattributes(angle, {'numeric'}, {});

            res = Point2D();
            res.x = obj.x .* cos(angle) - obj.y .* sin(angle);
            res.y = obj.x .* sin(angle) + obj.y .* cos(angle);
        end
    end
end
