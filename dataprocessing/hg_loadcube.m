function [struct_cube, struct_x1gv, struct_x2gv, struct_x3gv] = hg_loadcube( tps_data, strucname, cube_type )


%% Parameters
crop = true;
crop_shift = 'zero';


%% Load the cube
cube = tps_data.(cube_type).cube;
indmsk = tps_data.structures.(strucname).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
cube(cube == 0 & indmsk == 1) = 0.00001;
if strcmp(cube_type,'dose')
    struct_cube = cube .* indmsk;
elseif strcmp(cube_type,'ct')
    struct_cube = cube .* indmsk;
end
x1gv = tps_data.(cube_type).xVec;
x2gv = tps_data.(cube_type).yVec;
x3gv = tps_data.(cube_type).zVec;

% %% Interpolate cube
% if interpolate
%     [struct_cube, struct_x1gv, struct_x2gv, struct_x3gv] = hg_interpcube(...
%         struct_cube, x1gv, x2gv, x3gv, interp_interval, interp_method);
%     disp('dosecube interpolated');
% end
% 
% %% Crop cube
% if crop
%     [struct_cube, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(...
%         struct_cube, struct_x1gv, struct_x2gv, struct_x3gv, crop_shift);
% end

%% Crop cube
if crop
    [struct_cube, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(...
        struct_cube, x1gv, x2gv, x3gv, crop_shift);
end

% %% Remove planes within the structure cube where strucutre contour is not defined
% for k=1:length(struct_x3gv)
%     if ~sum(sum(struct_cube(:,:,k)))
%         error('Remove planes within the structure dosecube where strucutre contour is not defined!');
%     end
% end
end