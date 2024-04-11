classdef LineSrcArrayProfile < handle
    properties
        xc % centroid of the array elements
        a % half-width of the array elements
        profile % the profile at each array element
    end

    properties (Dependent)
        elem_num % total number of array elements
    end

    methods
        function obj = LineSrcArrayProfile(varargin)
            ip = inputParser();
            ip.addParameter('xc', nan);
            ip.addParameter('a', nan);
            ip.addParameter('profile', []);
            ip.parse(varargin{:});
            ip = ip.Results;

            obj.xc = ip.xc + 0*ip.a;
            obj.a = ip.a + 0*ip.xc;
            obj.profile = ip.profile;
        end

        function CreateProfile(obj, wav, type)
            obj.profile.name = type.name;
            switch type.name
                case 'uniform'
                    obj.profile.value = 1 + 0*obj.xc;
                case 'steerable'
                    obj.profile.value = exp(1i*wav.num*obj.xc.*cos(type.steer_angle));
                otherwise
                    error('Wrong profile type!')
            end
        end

        function elem_num = get.elem_num(obj)
            elem_num = numel(obj.xc + obj.a);
            if sum(isnan(obj.xc + obj.a), 'all') > 0
                elem_num = 0;
            end
        end
    end
end