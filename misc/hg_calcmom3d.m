function m = hg_calcmom3d(V,p,q,r,inv, varargin)
% hg_calcmom1d calculates mathematical moments of a 3D volume
% V - volume
% p,g,r - moment numbers
% inv - invariance
%
% Hubert Gabrys <hubert.gabrys@gmail.com>, 2015-2016
% This file is licensed under GPLv2
%

if length(varargin)==3
    x1spac = varargin{1};
    x2spac = varargin{2};
    x3spac = varargin{3};
else
    x1spac = 1;
    x2spac = 1;
    x3spac = 1;
end

switch inv
    case 'raw'
        % Define grid
        [X1,X2,X3] = ndgrid(0:size(V,1)-1, 0:size(V,2)-1, 0:size(V,3)-1);
        X1 = X1*x1spac;
        X2 = X2*x2spac;
        X3 = X3*x3spac;
        % Calculate
        Vq = (X1.^p).*(X2.^q).*(X3.^r).*V;
        m = sum(Vq(:));
        
    case 'transinv'
        % Define grid
        [X1,X2,X3] = ndgrid(0:size(V,1)-1, 0:size(V,2)-1, 0:size(V,3)-1);
        X1 = X1*x1spac;
        X2 = X2*x2spac;
        X3 = X3*x3spac;
        % Calculate mean values
        x1bar2 = hg_calcmom3d(V,1,0,0,'raw',x1spac, x2spac, x3spac)/hg_calcmom3d(V,0,0,0,'raw',x1spac, x2spac, x3spac);
        x2bar2 = hg_calcmom3d(V,0,1,0,'raw',x1spac, x2spac, x3spac)/hg_calcmom3d(V,0,0,0,'raw',x1spac, x2spac, x3spac);
        x3bar2 = hg_calcmom3d(V,0,0,1,'raw',x1spac, x2spac, x3spac)/hg_calcmom3d(V,0,0,0,'raw',x1spac, x2spac, x3spac);
        % Calculate moments
        Vq = ((X1-x1bar2).^p).*((X2-x2bar2).^q).*((X3-x3bar2).^r).*V;
        m = sum(Vq(:));
        
    case 'scaleinv'
        % Calculate normalization factor
        norm = (hg_calcmom3d(V,0,0,0,'transinv',x1spac, x2spac, x3spac)^((p+q+r)/3+1));
        % Calculate moments
        m = hg_calcmom3d(V,p,q,r,'transinv',x1spac, x2spac, x3spac)/norm;
end
end