function m = hg_calcmom1d(V,n,inv)
% hg_calcmom1d calculates mathematical moments of a 1D volume
% V - volume
% n - moment numbers
% inv - invariance
%
% h.gabrys@dkfz.de, 2014

if size(V,1) == 1
    V = V';
end

switch inv
    case 'raw'
        % Define grid
        X1 = meshgrid(0:length(V)-1);
        % Calculate
        Vq = (X1.^n(1)).*V;
        m = sum(Vq(:));
        
    case 'trans'
        % Define grid
        X1 = meshgrid(0:length(V)-1);
        % Calculate mean values
        x1bar2 = hg_calcmom1d(V,1,'raw')/hg_calcmom1d(V,0,'raw');
        % Calculate moments
        Vq = ((X1-x1bar2).^n(1)).*V;
        m = sum(Vq(:));
        
    case 'scale'
        % Calculate normalization factor
        norm = (hg_calcmom1d(V,0,'trans')^(n+1));
        % Calculate moments
        m = hg_calcmom1d(V,n,'trans')/norm;
end