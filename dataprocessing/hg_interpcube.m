function [ Vi, xgvi, ygvi, zgvi ] = hg_interpcube( V, xgv, ygv, zgv, ...
    interp_interval, interp_method)

[X,Y,Z] = meshgrid(xgv, ygv, zgv);
xgvi = xgv(1):interp_interval:xgv(end);
ygvi = ygv(1):interp_interval:ygv(end);
zgvi = zgv(1):interp_interval:zgv(end);
[Xi,Yi,Zi] = meshgrid(xgvi, ygvi, zgvi);
Vi = interp3(X,Y,Z,V,Xi,Yi,Zi,interp_method);
end