function output = calc_moments(struct_dc, mom_def)
%
% the cube is in LPS coordinate system (Right->Left, Anterior->Posterior,
% Inferior->Superior)
% http://www.itk.org/Wiki/images/thumb/f/f8/ImageOrientationStandard.png/800px-ImageOrientationStandard.png
%
% mom_def = [0 0 0; eye(3); 1 1 0; 1 0 1; 0 1 1; 1 1 1; 2*eye(3); 3*eye(3)];
%
% Hubert Gabrys <hubert.gabrys@gmail.com>
% License: MIT
%

mom_val = size(1,length(mom_def)); % prealocation
iterator = 1;

%% Calculate moments
for k = 1:size(mom_def,1) % for every moment setup
    mom_val(iterator,k) = calc_mom3d(struct_dc, mom_def(k,1), mom_def(k,2), mom_def(k,3), 'scaleinv');
end

%% output
variablenames = strrep(num2cell(num2str(mom_def),2), ' ', '')';
variablenames = cellfun(@(v) ['m' v], variablenames, 'Uniform', 0);

for i=1:length(variablenames)
  output.(variablenames{i}) = mom_val(i);  
end

%disp('Moments calculated');
end


function m = calc_mom3d(V,p,q,r,inv)
% calc_mom1d calculates mathematical moments of a 3D volume
% V - volume
% p,g,r - moment numbers
% inv - invariance

switch inv
    case 'raw'
        % Define grid
        [X,Y,Z] = meshgrid(0:size(V,2)-1, 0:size(V,1)-1, 0:size(V,3)-1);
        X = X;
        Y = Y;
        Z = Z;
        % Calculate
        Vq = (X.^p) .* (Y.^q) .* (Z.^r) .* V;
        m = sum(Vq(:));
        
    case 'transinv'
        % Define grid
        [X,Y,Z] = meshgrid(0:size(V,2)-1, 0:size(V,1)-1, 0:size(V,3)-1);
        X = X;
        Y = Y;
        Z = Z;
        % Calculate mean values
        xbar2 = calc_mom3d(V,1,0,0,'raw') / calc_mom3d(V,0,0,0,'raw');
        ybar2 = calc_mom3d(V,0,1,0,'raw') / calc_mom3d(V,0,0,0,'raw');
        zbar2 = calc_mom3d(V,0,0,1,'raw') / calc_mom3d(V,0,0,0,'raw');
        % Calculate moments
        Vq = ((X-xbar2).^p) .* ((Y-ybar2).^q) .* ((Z-zbar2).^r) .* V;
        m = sum(Vq(:));
        
    case 'scaleinv'
        % Calculate normalization factor
        norm = (calc_mom3d(V,0,0,0,'transinv')^((p+q+r)/3+1));
        % Calculate moments
        m = calc_mom3d(V,p,q,r,'transinv')/norm;
end
end
