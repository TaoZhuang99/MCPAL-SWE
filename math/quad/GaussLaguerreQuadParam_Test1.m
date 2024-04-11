
int_num = (2:100).';
int = int_num*0;

for i = 1:length(int_num)
    [node, weight] = GaussLaguerreQuadParam(int_num(i));
%     int(i) = sum(node.^4 .* weight);
    int(i) = sum((1+node).^100 .* weight);
end

figure
plot(int_num, int)
