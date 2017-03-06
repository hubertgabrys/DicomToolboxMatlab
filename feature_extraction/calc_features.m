function output = calc_features( tps_data, verbose )
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
    struct_cube = load_cube(tps_data, strucname, 'dose' );
    struct_cube_msk = struct_cube>0;
    struct_indicator_msk = tps_data.structures.(strucname).indicator_mask;
    
    % dose-volume features
    dvh = calc_dvh(struct_cube);
    
    % subvolume features
    resolution = 2;
    subvol2 = calc_subvolumes(struct_cube, resolution);
    resolution = 3;
    subvol3 = calc_subvolumes(struct_cube, resolution);
    
    % 3D moments
    mom_def = [1 1 0; 1 0 1; 0 1 1; 2 0 0; 0 2 0; 0 0 2;...
        1 1 1; 2 1 0; 2 0 1; 1 2 0; 0 2 1; 0 1 2; 1 0 2;...
        3 0 0; 0 3 0; 0 0 3; 4 0 0; 0 4 0; 0 0 4; 3 1 0;...
        3 0 1; 1 3 0; 0 3 1; 1 0 3; 0 1 3; 2 2 2];
    moments = calc_moments(struct_cube, mom_def);
    
    % 3D gradients
    gradients = calc_gradients(dose_cube, xspac, yspac, zspac, struct_indicator_msk);
    
    % Shape features
    shape_features = calc_shape_features(struct_cube_msk, xspac, yspac, zspac);
    
    % Histogram features
    histogram_features = calc_hist_features(dose_cube, struct_indicator_msk);
    
    % merge the results
    feature_names = ['strucname'; fieldnames(histogram_features);...
        fieldnames(dvh); fieldnames(subvol2); fieldnames(subvol3);...
        fieldnames(gradients); fieldnames(moments);...
        fieldnames(shape_features)]';
    this_final_features = [strucname; struct2cell(histogram_features);...
        struct2cell(dvh); struct2cell(subvol2); struct2cell(subvol3);...
        struct2cell(gradients); struct2cell(moments);...
        struct2cell(shape_features)]';
 
    if ~exist('final_features', 'var')
        final_features = [feature_names; this_final_features];
    else
        final_features = [final_features; this_final_features];
    end
end
if verbose
	fprintf(repmat('\b',1,7)); % erase progress_tool output
end

%% output
output = final_features;

end


function progress_tool(currentIndex, totalNumberOfEvaluations)
if (currentIndex > 1 && nargin < 3)
  Length = numel(sprintf('%3.2f%%',(currentIndex-1)/totalNumberOfEvaluations*100));
  fprintf(repmat('\b',1,Length));
end
fprintf('%3.2f%%',currentIndex/totalNumberOfEvaluations*100);
end