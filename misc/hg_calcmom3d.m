function m = hg_calcmom3d(V,p,q,r,inv, varargin)
% hg_calcmom1d calculates mathematical moments of a 3D volume
% V - volume
% p,g,r - moment numbers
% inv - invariance
%
% Hubert Gabrys <hubert.gabrys@gmail.com>, 2015-2016
% This file is licensed under GPLv2
%

if length(varargin) == 3
    xspac = varargin{1};
    yspac = varargin{2};
    zspac = varargin{3};
else
    xspac = 1;
    yspac = 1;
    zspac = 1;
end

switch inv
    case 'raw'
        % Define grid
        [X,Y,Z] = meshgrid(0:size(V,2)-1, 0:size(V,1)-1, 0:size(V,3)-1);
        X = X * xspac;
        Y = Y * yspac;
        Z = Z * zspac;
        % Calculate
        Vq = (X.^p) .* (Y.^q) .* (Z.^r) .* V;
        m = sum(Vq(:));
        
    case 'transinv'
        % Define grid
        [X,Y,Z] = meshgrid(0:size(V,2)-1, 0:size(V,1)-1, 0:size(V,3)-1);
        X = X * xspac;
        Y = Y * yspac;
        Z = Z * zspac;
        % Calculate mean values
        xbar2 = hg_calcmom3d(V,1,0,0,'raw',xspac,yspac,zspac) / hg_calcmom3d(V,0,0,0,'raw',xspac,yspac,zspac);
        ybar2 = hg_calcmom3d(V,0,1,0,'raw',xspac,yspac,zspac) / hg_calcmom3d(V,0,0,0,'raw',xspac,yspac,zspac);
        zbar2 = hg_calcmom3d(V,0,0,1,'raw',xspac,yspac,zspac) / hg_calcmom3d(V,0,0,0,'raw',xspac,yspac,zspac);
        % Calculate moments
        Vq = ((X-xbar2).^p) .* ((Y-ybar2).^q) .* ((Z-zbar2).^r) .* V;
        m = sum(Vq(:));
        
    case 'scaleinv'
        % Calculate normalization factor
        norm = (hg_calcmom3d(V,0,0,0,'transinv',xspac,yspac,zspac)^((p+q+r)/3+1));
        % Calculate moments
        m = hg_calcmom3d(V,p,q,r,'transinv',xspac,yspac,zspac)/norm;
end
end