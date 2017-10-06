function output = calc_features( tps_data, organ, verbose)
%calculateFeatures calls various functions to calculate dosimetric and ct
%descriptors of the rt structures.
%   tps_data - ct, dosimetric, and structure data from the tps
%   organ - 'all': calculate features for all structures, 'parotids':
%   calcualte features just for parotid glands
%   strucnames - names of rt structures

if nargin < 2
	verbose = 1;
    organ = 'all';
end

if nargin < 3
	verbose = 1;
end

% dose_cube = tps_data.dose.cube;
xspac = tps_data.dose.xVec(2)-tps_data.dose.xVec(1);
yspac = tps_data.dose.yVec(2)-tps_data.dose.yVec(1);
zspac = tps_data.dose.zVec(2)-tps_data.dose.zVec(1);
strucnames = fieldnames(tps_data.structures);

if strcmp(organ, 'parotids')
    [parotidL_name, parotidR_name] = findLRparotids(strucnames);
    strucnames = {parotidL_name, parotidR_name}';
end

for i=1:length(strucnames)
    strucname = strucnames{i};
    if verbose
        progress_tool(i, length(strucnames));
    end
    
    % load structure dosecube
    dose_cube = tps_data.dose.cube;
    struct_cube = crop_cube(tps_data, strucname, 'dose' );
    struct_cube_msk = struct_cube>0;
    struct_indicator_msk = tps_data.structures.(strucname).indicator_mask;
    
    if strcmp(organ, 'parotids')
        parotidL_cube = crop_cube(tps_data, parotidL_name, 'dose' );
        parotidR_cube = crop_cube(tps_data, parotidR_name, 'dose' );
        if mean(parotidR_cube(parotidR_cube>0)) > mean(parotidL_cube(parotidL_cube>0))
            % flip cube if ipsigland on the right
            struct_cube = flip(struct_cube, 2);
            struct_cube_msk = flip(struct_cube_msk, 2);
            struct_indicator_msk = flip(struct_indicator_msk, 2);
            dose_cube = flip(dose_cube, 2);
        end
    end
    
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

function [struct_cube, struct_xgv, struct_ygv, struct_zgv] = crop_cube( tps_data, strucname, cube_type )
% crop_cube crops the volume by cutting out zero-valued voxels
% surrounging a non-zero valued voxels.
% if shift == 'zero' then x1gv, x2gv and x3gv will be shifted in a way that
% they start at zero go in positive direction.
%

%% Load the cube
cube = tps_data.(cube_type).cube;
indmsk = tps_data.structures.(strucname).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
cube(cube == 0 & indmsk == 1) = 0.00001;
if strcmp(cube_type,'dose')
    struct_cube = cube .* double(indmsk);
elseif strcmp(cube_type,'ct')
    struct_cube = cube .* double(indmsk);
end
xgv = tps_data.(cube_type).xVec;
ygv = tps_data.(cube_type).yVec;
zgv = tps_data.(cube_type).zVec;

%% Crop cube
V = struct_cube;
x1gv = xgv;
x2gv = ygv;
x3gv = zgv;

if any(isnan(V(:)))
    error('NaN values within the cube!');
end
x1gv_min = 0;
x1gv_max = 0;
x2gv_min = 0;
x2gv_max = 0;
x3gv_min = 0;
x3gv_max = 0;
for i=1:length(x1gv)
    if sum(sum(V(i,:,:))) > 0
        if x1gv_min==0
            x1gv_min = i;
        end
        if i>x1gv_max
            x1gv_max = i;
        end
    end
end
for i=1:length(x2gv)
    if sum(sum(V(:,i,:))) > 0
        if x2gv_min==0
            x2gv_min = i;
        end
        if i>x2gv_max
            x2gv_max = i;
        end
    end
end
for i=1:length(x3gv)
    if sum(sum(V(:,:,i))) > 0
        if x3gv_min==0
            x3gv_min = i;
        end
        if i>x3gv_max
            x3gv_max = i;
        end
    end
end
V = V(x1gv_min:x1gv_max, x2gv_min:x2gv_max, x3gv_min:x3gv_max);

%% Crop grid vectors
x1gv = x1gv(x1gv_min:x1gv_max);
x2gv = x2gv(x2gv_min:x2gv_max);
x3gv = x3gv(x3gv_min:x3gv_max);

%% Transform grid vectors so they origin at 0
x1gv = abs(x1gv-x1gv(1));
x2gv = abs(x2gv-x2gv(1));
x3gv = abs(x3gv-x3gv(1));

%% prepare output
struct_cube = V;
struct_xgv = x1gv;
struct_ygv = x2gv;
struct_zgv = x3gv;
end

function progress_tool(currentIndex, totalNumberOfEvaluations)
if (currentIndex > 1 && nargin < 3)
  Length = numel(sprintf('%3.2f%%',(currentIndex-1)/totalNumberOfEvaluations*100));
  fprintf(repmat('\b',1,Length));
end
fprintf('%3.2f%%',currentIndex/totalNumberOfEvaluations*100);
end