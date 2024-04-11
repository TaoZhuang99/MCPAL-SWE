% =========================================================================
% INTRO
%   - Import the parameters (nodes and weights) for Gauss-Legendre 
%       Quadrature
% -------------------------------------------------------------------------
% INPUT
%   - int_num: the number of points for the integration
%   - a, b: the lower and upper limit 
%   Dimension:  gauss => a .* b
% -------------------------------------------------------------------------
% Output
%	node, weight	--- node and weights
% =========================================================================
function [node, weight] = GaussLegendreQuadParam(int_num, a, b, varargin)

    validateattributes(int_num, {'numeric'}, {'scalar', '>=', 2, '<=', 2e3});

    ip = inputParser;
    ip.addParameter('dim', 1, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 1}));
    ip.parse(varargin{:});
    ip = ip.Results;

	fn_node = sprintf(...
        'GaussLegendreQuadrature_zero_%s.txt', ...
		num2str(int_num));
	fn_weight = sprintf(...
        'GaussLegendreQuadrature_weight_%s.txt',...
		num2str(int_num));
    node = importdata(fn_node);
	node = node(:);
    weight = importdata(fn_weight);
	weight = weight(:);
    d = [ones(1, ip.dim-1), int_num];
    if ip.dim>1
        node = reshape(node, d);
        weight = reshape(weight, d);
    end
    if isinf(b)
        % When the upper limit is inifnite
        % Using a trigometric transformation
        weight = weight .* pi/4 .* (sec(pi/4*(node + 1))).^2;
        node = tan(pi/4 * (node + 1)) + a;
    else
        weight = weight .* (b - a)/2;
        node = ((b - a) .* node + (b + a))/2;
    end
end
