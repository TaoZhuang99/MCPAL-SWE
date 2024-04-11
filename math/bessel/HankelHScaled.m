function H = HankelHScaled(n, z, varargin)

    ip = inputParser;
    ip.addParameter('is_log', false);
    ip.addParameter('kind', 1, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=', 1, '<=', 2}));
    ip.parse(varargin{:});
    ip = ip.Results;

    H = HankelHLog(n, z, 'kind', ip.kind) + (-1).^ip.kind * 1i .* z;
    if ~ip.is_log
        H = exp(H);
    end

end
