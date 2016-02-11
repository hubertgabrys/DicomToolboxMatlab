function [ Vi, x1gvi, x2gvi, x3gvi ] = hg_interpcube( V, x1gv, x2gv, x3gv, ...
    interp_interval, interp_method)

[X1,X2,X3] = ndgrid(x1gv, x2gv, x3gv);
x1gvi = x1gv(1):interp_interval:x1gv(end);
x2gvi = x2gv(1):interp_interval:x2gv(end);
x3gvi = x3gv(1):interp_interval:x3gv(end);
[X1i,X2i,X3i] = ndgrid(x1gvi, x2gvi, x3gvi);
Vi = interpn(X1,X2,X3,V,X1i,X2i,X3i,interp_method);

end