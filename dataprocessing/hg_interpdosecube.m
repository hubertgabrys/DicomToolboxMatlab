function [ Vq, xq, yq, zq ] = hg_interpdosecube( V, x, y, z, interval, type)

[X,Y,Z] = meshgrid(x, y, z);
xq = x(1):interval:x(end);
yq = y(1):interval:y(end);
zq = z(1):interval:z(end);
[Xq,Yq,Zq] = meshgrid(xq, yq, zq);
Vq = interp3(X,Y,Z, V, Xq,Yq,Zq, type);

end