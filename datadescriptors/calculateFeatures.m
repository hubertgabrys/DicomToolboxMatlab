function output = calculateFeatures( tps_data, verbose )
%calculateFeatures calls various functions to calculate dosimetric and ct
%descriptors of the rt structures.
%   tps_data - ct, dosimetric, and structure data from the tps
%   strucnames - names of rt structures

if nargin < 2
	verbose = 1;
end

dose_cube = tps_data.dose.cube;
xspac = tps_data.dose.xVec(2)-tps_data.dose.xVec(1);
yspac = tps_data.dose.yVec(2)-tps_data.dose.yVec(1);
zspac = tps_data.dose.zVec(2)-tps_data.dose.zVec(1);
strucnames = fieldnames(tps_data.structures);
for i=1:length(strucnames)
    strucname = strucnames{i};
	if verbose
		progress_tool(i, length(strucnames));
	end
    
    % load structure dosecube
    struct_cube = hg_loadcube(tps_data, strucname, 'dose' );
    struct_cube_msk = struct_cube>0;
    struct_indicator_msk = tps_data.structures.(strucname).indicator_mask;
    
    % dose-volume features
    dvh = hg_calcdvh(struct_cube);
    dvh = dvh.array;
    
    % subvolume features
    resolution = 2;
    subvol2 = hg_calcStructSubvolumes(struct_cube, resolution);
    resolution = 3;
    subvol3 = hg_calcStructSubvolumes(struct_cube, resolution);
    
    % 3D moments
    mom_def = [1 1 0; 1 0 1; 0 1 1; 2 0 0; 0 2 0; 0 0 2;...
        1 1 1; 2 1 0; 2 0 1; 1 2 0; 0 2 1; 0 1 2; 1 0 2;...
        3 0 0; 0 3 0; 0 0 3; 4 0 0; 0 4 0; 0 0 4; 3 1 0;...
        3 0 1; 1 3 0; 0 3 1; 1 0 3; 0 1 3; 2 2 2];
    moments = hg_calcdosemoments(struct_cube, mom_def);
    
    % 3D gradients
    gradients = hg_calcdosegradients(dose_cube, xspac, yspac, zspac, struct_indicator_msk);
    
    % Area
    struc_area = calcStrucArea(struct_cube_msk, xspac, yspac, zspac);
    
    % 3D Volume
    struc_vol = calcStrucVolume(struct_cube_msk, xspac, yspac, zspac);
    
    % Eccentricity
    struc_ecc = calcStrucEccentricity(struct_cube_msk, xspac, yspac, zspac);    
    
    % Compactness
    struc_comp = hg_calcStructCompactness(struct_cube_msk, xspac, yspac, zspac);    
    
    % Density
    struc_dens= hg_calcStructDensity(struct_cube_msk, xspac, yspac, zspac);      
    
    % Sphericity
    struc_spher = hg_calcStructSphericity(struct_cube_msk, xspac, yspac, zspac);
    
    % Isotropy indices
    %struc_isotropyIndices = hg_calcStructIsotropyInd(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % Aspect ratios
    %struc_aspectRatios = hg_calcStructAspRatios(struct_cube_mask, xspacing, yspacing, zspacing);
    
    % concatenate shape features
    variablenames = {'area', 'volume', 'eccentricity', 'compactness', 'density', 'sphericity'};
    shape_features = table(struc_area, struc_vol, struc_ecc, struc_comp, struc_dens, struc_spher, 'VariableNames', variablenames);
        
    % merge the results
    this_final_features = [dvh, subvol2, subvol3, moments, gradients, shape_features];
    if ~exist('final_features', 'var')
        final_features = this_final_features;
    else
        final_features = [final_features; this_final_features];
    end    
end
if verbose
	fprintf(repmat('\b',1,7)); % erase progress_tool output
end

%% output
strucnames = table(strucnames, 'VariableNames', {'structure'});
output = [strucnames, final_features];

end


function progress_tool(currentIndex, totalNumberOfEvaluations)
if (currentIndex > 1 && nargin < 3)
  Length = numel(sprintf('%3.2f%%',(currentIndex-1)/totalNumberOfEvaluations*100));
  fprintf(repmat('\b',1,Length));
end
fprintf('%3.2f%%',currentIndex/totalNumberOfEvaluations*100);
end