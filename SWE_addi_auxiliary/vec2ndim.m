function res = vec2ndim(v,dim)
if dim == 1
    res = reshape(v,length(v),1);
else
    res = reshape(v,[ones(1,dim-1),length(v)]);
end
end
