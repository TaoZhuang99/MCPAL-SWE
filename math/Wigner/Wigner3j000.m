% ========================================================================
% 计算Wigner3j符号的特殊情况：(j1, j2, j3; 0, 0, 0)
% Calculte the Wigner 3j symbol at special case (j1, j2, j3; 0, 0, 0)
% ------------------------------------------------------------------------
% 输入 Input
%	j1, j2, j3	---	angular momenta
% ------------------------------------------------------------------------
% 输出 Output
%	wigner		--- the results
% ========================================================================

function wigner = Wigner3j000(j1, j2, j3)

	%% special case where wigner = 0
	
	% triangular inequality
	if ~((abs(j1-j2) <= j3) && (j3 <= (j1+j2)))
		wigner = 0;
		return;
	end

	% one of them is negative
	if (j1<0) || (j2<0) || (j3<0)
		wigner = 0;
		return;
	else % ensure all are non-negative
		j1IsHalfInteger = fix(2*j1)==2*j1;
		j2IsHalfInteger = fix(2*j2)==2*j2;
		j3IsHalfInteger = fix(2*j3)==2*j3;
		% one of them is not half-integer
		if ~j1IsHalfInteger || ~j2IsHalfInteger || ~j3IsHalfInteger
			wigner = 0;
			return; 
		else % ensure all are half-integer
			j1IsInteger = fix(j1) == j1;
			j2IsInteger = fix(j2) == j2;
			j3IsInteger = fix(j3) == j3;
			if ((j1IsInteger+j2IsInteger+j3IsInteger) == 0) || ((j1IsInteger+j2IsInteger+j3IsInteger) == 2)
				wigner = 0;
				return;
			end
		end
	end
	
	J = (j1+j2+j3)/2;
	% odd returns 0
	if fix(J)~=J
		wigner = 0;
		return;
	end
	
	wigner = (-1).^J .* exp(gammaln(J+1) - gammaln(J-j1+1) - gammaln(J-j2+1) - gammaln(J-j3+1) ...
		+0.5*(gammaln(2*J-2*j1+1) + gammaln(2*J-2*j2+1) + gammaln(2*J-2*j3+1) - ...
		gammaln(2*J+1+1)));
end
