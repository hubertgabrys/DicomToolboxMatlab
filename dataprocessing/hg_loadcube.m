function output = hg_loadcube( tps_data, strucname, type )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Parameters
crop = true;
crop_shift = 'zero';
interpolate = false;
interp_method = 'nearest';
interp_interval = 2.5;


%% Load the cube
cube = tps_data.(type).cube;
indmsk = tps_data.structures.(strucname).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
cube(cube == 0 & indmsk == 1) = 0.00001;
if strcmp(type,'dose')
    struct_cube = cube .* indmsk;
elseif strcmp(type,'ct')
    struct_cube = cube .* uint16(indmsk);
end
x1gv = tps_data.(type).xVec;
x2gv = tps_data.(type).yVec;
x3gv = tps_data.(type).zVec;

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

%% OUTPUT
output = struct_cube;
end