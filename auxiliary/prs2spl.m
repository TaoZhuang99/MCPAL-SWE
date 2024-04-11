% ==========================================================================
% INTRODUCTION
% 	Calculate sound pressure level (in dB) of given pressure signal 'prs'.
% --------------------------------------------------------------------------
% SYNTAX
%  spl_dB  = cal_spl(prs, ref)
%  spl_dB  = cal_spl(prs, ref, windowSize)
%  spl_dB  = cal_spl(prs, ref, windowSize, Fs)
% --------------------------------------------------------------------------
% DESCRIPTION 
% 	spl_dB  = cal_spl(prs, ref) returns sound pressure level in decibels
% 	referenced to reference pressure |ref| in pascals. This usage returns a
% 	scalar value of spl_dB for the entire p_Pa signal. 
% 
% spl_dB  = spl(p_Pa,ref,windowSize) returns a moving SPL calculation
% along the window size specified by windowSize, where the units of
% windowSize are number of time indicies. 
% 
% spl_dB  = spl(p_Pa,ref,windowSize,Fs) returns a moving SPL, where
% windowSize is not indices of time, but _units_of time equivalent to
% units of 1/Fs. 
% --------------------------------------------------------------------------
% INPUT 
%  p_Pa       =  vector of pressure signal in units of pascals. Can be other units
%               if you declare a reference pressure of matching units. 
%
%  ref        =  reference pressure in units matching p_Pa or simply 'air' or
%               'water' if p_Pa is in pascals. 
%			= default value: 20e-6;
%
% windowSize =  window size of moving spl calculation. If no windowSize is
%               declared, the spl of the entire input signal will be
%               returned as a scalar. If windowSize is declared, but Fs is
%               not declared, the units of windowSize are number of
%               elements of the input vector. If windowSize and Fs are
%               declared, the units of windowSize are time given by 1/Fs. 
% 
% Fs         =  (optional) sampling frequency.  Note! including Fs changes
%               how this function interprets the units of windowSize. 
% 
%
% OUTPUT: 
% SPL        =  sound pressure level in decibels. If windowSize is declared
%               SPL is a vector of the same length as p_Pa. If windowSize
%               is not declared, SPL is a scalar. 
%
% Note that this does account for frequency content.  A-weighted decibels
% (dBA) are frequency-dependent.  This function does not compute dBA. 
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Written by Chad A. Greene, with code from Jos van der Geest.
% Version 1 uploaded to FEX in 2012. Version 1 was absolutely lousy.
% Version 2 uploaded to FEX in 2014. The current version, Version 2, is medium-okay.
% Version 3 uploaded to FEX in May 2014, same usability, but now includes slidefun. 
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% EXAMPLES 
% * * * Example 1: * * *
% 
% load train % (let's assume y is has pascals as its units)
% spl(y,'air')
% ans = 
%        84.6
%    
% 
% * * * Example 2: Enter your own custom reference pressure: * * *
% 
% load train % (let's assume y is has pascals as its units)
% spl(y,20*10^-6)
% ans = 
%        84.6
%
% 
% * * * Example 3: A moving window of 501 elements and plot: * * *
% 
% load train
% SPL = spl(y,'air',501); % <-- Here's how to use the function. 
%  
% t = cumsum(ones(size(y))/Fs);
% figure
% subplot(2,1,1)
% plot(t,y)
% axis tight
% ylabel('pressure (Pa)')
% 
% subplot(2,1,2)
% plot(t,SPL)
% axis tight
% ylabel('spl (dB)')
% xlabel('time (s)')
% 
% 
% * * * Example 3: A 10 ms moving window and plot: * * *
%
% load train 
% SPL = spl(y,'air',0.010,Fs);
%  
% t = cumsum(ones(size(y))/Fs);
% figure
% subplot(2,1,1)
% plot(t,y)
% axis tight
% ylabel('pressure (Pa)')
% 
% subplot(2,1,2)
% plot(t,SPL)
% axis tight
% ylabel('spl (dB)')
% xlabel('time (s)')
%
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Note: Typically we only write decibels to integer values or one decimal
% place.  Anything on the hundredth-of-a-decibel level is probably just
% noise and can be ignored. 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

function spl = prs2spl(prs, varargin)

	p = inputParser;
	% 参考声压级
	addParameter(p, 'prs_ref', 20e-6);
	addParameter(p, 'prs_type', 'amplitude');
	parse(p, varargin{:});
	ip = p.Results;

	% 计算声压的均方根值
	switch ip.prs_type
		case 'amplitude'
			prs_rms = abs(prs)/sqrt(2);
		case 'rms'
			prs_rms = prs;
	end

	spl = 20*log10(prs_rms/ip.prs_ref);
end
