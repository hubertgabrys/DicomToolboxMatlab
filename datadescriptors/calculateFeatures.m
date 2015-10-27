function output = calculateFeatures( tps_data )
%calculateFeatures calls various functions to calculate dosimetric and ct
%descriptors of the structures.
%   tps_data - ct, dosimetric, and structure data from treatment planning system
%   strucnames - names of structures


strucnames = fieldnames(tps_data.structures);

fprintf('Calculating features...\n');
for i=1:length(strucnames)
    strucname = strucnames{i};
    disp(strucname);    
    %% DOSIMETRIC
    struct_cube = hg_loadcube(tps_data, strucname, 'dose' );
    % this part requires revision. it will be better to have separate
    % functions for different dosimetric descripotors. The functions will
    % get binary 3-dimensional structures as input eg:
    % dvh = hg_calcdvh(struct_cube);
    % min = hg_calc???(struct_cube, 'min');
    % mean = hg_calc???(struct_cube, 'mean');
    % max = hg_calc???(struct_cube, 'max');
    % moments = hg_calcmoments(struct_cube, mom_def);
    
    % dose-volume
    dvh = hg_calcdvh(struct_cube);
    dvh = dvh.array;
    
    % spatial moments
    %struct_cube = hg_loadcube(tps_data, strucname, 'dose', true );
    %mom_def = [0 0 0; eye(3); 1 1 0; 1 0 1; 0 1 1; 1 1 1; 2*eye(3); 3*eye(3)];
    mom_def = npermutek(0:4,3);
    moments = hg_calcdosemoments(struct_cube, mom_def);
    
    % merge results
    if exist('dosimetric_features', 'var')
        dosimetric_features = [dosimetric_features; [dvh, moments]];
    else
        dosimetric_features = [dvh, moments];
    end
    
    %struct_cube = hg_loadcube(tps_data, strucname, 'ct', false );
    struct_cube_mask = struct_cube>0;
    xspacing = tps_data.dose.xVec(2)-tps_data.dose.xVec(1);
    yspacing = tps_data.dose.yVec(2)-tps_data.dose.yVec(1);
    zspacing = tps_data.dose.zVec(1)-tps_data.dose.zVec(2);
%     xspacing = 1;
%     yspacing = 1;
%     zspacing = 1;
    
    % Area
    struc_area = calcStrucArea(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % Volume 3D
    struc_volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % Eccentricity
    struc_eccentricity = calcStrucEccentricity(struct_cube_mask, xspacing, yspacing, zspacing);    
    
    % Compactness
    struc_compactness = hg_calcStructCompactness(struct_cube_mask, xspacing, yspacing, zspacing);    
    
    % Density
    struc_density = hg_calcStructDensity(struct_cube_mask, xspacing, yspacing, zspacing);    
    
    % Roundness
    
    
    % Sphericity
    struc_sphericity = hg_calcStructSphericity(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % Isotropy indices
    %struc_isotropyIndices = hg_calcStructIsotropyInd(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % Aspect ratios
    %struc_aspectRatios = hg_calcStructAspRatios(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % merge results
    variablenames = {'area', 'volume', 'eccentricity', 'compactness', 'density', 'sphericity'};
    if exist('shape_features', 'var')
        shape_features = [shape_features; table(struc_area, struc_volume, struc_eccentricity, struc_compactness, ...
            struc_density, struc_sphericity, 'VariableNames', variablenames)];
    else
        shape_features = table(struc_area, struc_volume, struc_eccentricity, struc_compactness,...
            struc_density, struc_sphericity, 'VariableNames', variablenames);
    end
    
    
    %fprintf('Features for %s calculated.\n', strucname);
end
fprintf('Features for all structures calculated!\n\n');

%% output
strucnames = table(strucnames, 'VariableNames', {'structure'});
output = [strucnames, dosimetric_features, shape_features];

end