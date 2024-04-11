% Calculate the spherical Hankel functions divided by 
%   exp(1i*z)

function h = SphHankel1Scaled(n, z, varargin)

	p = inputParser;
	addParameter(p, 'kind', 1);
	parse(p, varargin{:});
	ip = p.Results;

	% Dimension order: n -> z
	n_dim1 = n(:);
	z_dim2 = z(:).';

	N = max(n_dim1);

	h = zeros(N+1, length(z_dim2));

	% initial values
	switch ip.kind
		case 1
			h(1,:) = 1./(1i*z_dim2);
			h(2,:) = (1-1i*z_dim2) ./(1i*z_dim2.^2);
		case 2
			h(1,:) = 1./(-1i*z_dim2);
			h(2,:) = (1+1i*z_dim2) ./ (-1i*z_dim2.^2);
	end
	for nn = 1:N-1
		h(nn+1+1,:) = (2*nn+1)./z_dim2 .*h(nn+1,:) - ...
			h(nn-1+1,:);
	end
	h = h(n+1,:);
	h = reshape(h, size(0*n.*z));
end
