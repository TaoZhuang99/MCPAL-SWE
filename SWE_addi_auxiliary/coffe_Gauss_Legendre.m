% Dim: x:1

function [A, x] = coffe_Gauss_Legendre(a,b,N,varargin)

    ip = inputParser;
    ip.addParameter('dim', 1, @(x)validateattributes(x, {'numeric'}, {'scalar'}));
    ip.parse(varargin{:});
    ip = ip.Results;

if a >= b 
    A = [];
    x = [];
else
    M = 3;
    L = linspace(a,b,N+1);
    x = zeros(M*N, 1);
    A = zeros(M*N, 1);

    Ak = [
        0.5555555555555556;
        0.8888888888888889;
        0.5555555555555556;];
    xk = [
        -0.7745966692414834;
        0;
        0.7745966692414834;];

    ai = (L(2)-L(1))/2;
    for i = 1:N
        ui = (L(i)+L(i+1))/2;
        xk_i = ai.*xk + ui;
        x(M*(i-1)+1:M*i) = xk_i;
        A(M*(i-1)+1:M*i) = Ak;
    end

    A = (b-a)/2*A./N;
end

A = vec2ndim(A, ip.dim);
x = vec2ndim(x, ip.dim);

%% Demo
% f = @(t) sin(t)+1;
% % f = @(t) t;
% res = sum(A.*f(x));
% disp(res);

end