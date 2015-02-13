function m = hg_calcmom3d(V,p,q,r,inv)
% hg_calcmom1d calculates mathematical moments of a 3D volume
% V - volume
% p,g,r - moment numbers
% inv - invariance
%
% h.gabrys@dkfz.de, 2014

switch inv
    case 'raw'
        % Define grid
        [X1,X2,X3] = ndgrid(0:size(V,1)-1, 0:size(V,2)-1, 0:size(V,3)-1);
        % Calculate
        Vq = (X1.^p).*(X2.^q).*(X3.^r).*V;
        m = sum(Vq(:));
        
    case 'trans'
        % Define grid
        [X1,X2,X3] = ndgrid(0:size(V,1)-1, 0:size(V,2)-1, 0:size(V,3)-1);
        % Calculate mean values
        x1bar2 = hg_calcmom3d(V,1,0,0,'raw')/hg_calcmom3d(V,0,0,0,'raw');
        x2bar2 = hg_calcmom3d(V,0,1,0,'raw')/hg_calcmom3d(V,0,0,0,'raw');
        x3bar2 = hg_calcmom3d(V,0,0,1,'raw')/hg_calcmom3d(V,0,0,0,'raw');
        % Calculate moments
        Vq = ((X1-x1bar2).^p).*((X2-x2bar2).^q).*((X3-x3bar2).^r).*V;
        m = sum(Vq(:));
        
    case 'scale'
        % Calculate normalization factor
        norm = (hg_calcmom3d(V,0,0,0,'trans')^((p+q+r)/3+1));
        % Calculate moments
        m = hg_calcmom3d(V,p,q,r,'trans')/norm;
end