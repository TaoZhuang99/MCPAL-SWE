classdef SoundWave < handle
	properties
		freq
        note 
		absorp_coef
		num
        sound_speed = 343;
	end

	properties (Dependent)
		angfreq
        len
	end

	methods 
		function obj = SoundWave(varargin)
            ip = inputParser();
            ip.addParameter('freq', []);
            ip.addParameter('absorp_coef', 0);
            ip.addParameter('compute_absorp', true);
            ip.parse(varargin{:});
            ip = ip.Results;

            obj.freq = ip.freq;
            obj.absorp_coef = ip.absorp_coef;
            if ip.compute_absorp
                obj.ComputeAbsorpCoef();
            end
            obj.ComputeNum();
		end

		function angfreq = get.angfreq(obj)
			angfreq = 2*pi*obj.freq;
		end

		function ComputeNum(obj)
			obj.num = obj.angfreq / obj.sound_speed + 1i * obj.absorp_coef;
        end
        
		function len = get.len(obj)
			len = obj.sound_speed./obj.freq;
        end

        function ComputeAbsorpCoef(obj, varargin)
            obj.absorp_coef = AbsorpAttenCoef(obj.freq, varargin{:});
            obj.ComputeNum();
		end 

	end
		
end
