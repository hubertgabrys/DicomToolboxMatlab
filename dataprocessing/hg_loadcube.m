function output = hg_loadcube( tps_data, strucname, cube_type, interpolate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Parameters
crop = true;
crop_shift = 'zero';
interp_method = 'nearest';
interp_interval = 2.5;


%% Load the cube
cube = tps_data.(cube_type).cube;
indmsk = tps_data.structures.(strucname).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
cube(cube == 0 & indmsk == 1) = 0.00001;
if strcmp(cube_type,'dose')
    struct_cube = cube .* indmsk;
elseif strcmp(cube_type,'ct')
    struct_cube = cube .* uint16(indmsk);
end
x1gv = tps_data.(cube_type).xVec;
x2gv = tps_data.(cube_type).yVec;
x3gv = tps_data.(cube_type).zVec;

%% Crop cube
if crop
    [struct_cube, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(...
        struct_cube, x1gv, x2gv, x3gv, crop_shift);
end

%% Interpolate cube
if interpolate
    struct_cube = hg_interpcube(struct_cube, struct_x1gv, struct_x2gv, struct_x3gv, interp_interval, interp_method);
    %disp('dosecube interpolated');
end

%% Remove planes within the structure cube where strucutre contour is not defined
for k=1:length(struct_x3gv)
    if ~sum(sum(struct_cube(:,:,k)))
        error('Remove planes within the structure dosecube where strucutre contour is not defined!');
    end
end

%% OUTPUT
output = struct_cube;
end