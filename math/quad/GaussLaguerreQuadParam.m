% =========================================================================
% INTRO
%   - Import the parameters (nodes and weights) for Gauss-Laguerre 
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
function [node, weight] = GaussLaguerreQuadParam(int_num, varargin)

    validateattributes(int_num, {'numeric'}, {'scalar', '>=', 2, '<=', 2e3});

    ip = inputParser();
    ip.addParameter('a', 0);
    ip.addParameter('b', 1);
    ip.parse(varargin{:});
    ip = ip.Results;

	fn_node = sprintf(...
        'GaussLaguerreQuad_zero_%s.txt', ...
		num2str(int_num));
	fn_weight = sprintf(...
        'GaussLaguerreQuad_weight_%s.txt',...
		num2str(int_num));
    node = importdata(fn_node);
	node = node(:)./ip.b + ip.a;
    weight = importdata(fn_weight);
	weight = weight(:) .* exp(-ip.a.*ip.b) ./ ip.b;
end
