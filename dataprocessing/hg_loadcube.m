function [struct_cube, struct_xgv, struct_ygv, struct_zgv] = hg_loadcube( tps_data, strucname, cube_type )


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
xgv = tps_data.(cube_type).xVec;
ygv = tps_data.(cube_type).yVec;
zgv = tps_data.(cube_type).zVec;

% %% Interpolate cube
% if interpolate
%     [struct_cube, struct_xgv, struct_ygv, struct_zgv] = hg_interpcube(...
%         struct_cube, xgv, ygv, zgv, interp_interval, interp_method);
%     disp('dosecube interpolated');
% end
% 
% %% Crop cube
% if crop
%     [struct_cube, struct_xgv, struct_ygv, struct_zgv] = hg_cropcube(...
%         struct_cube, struct_xgv, struct_ygv, struct_zgv, crop_shift);
% end

%% Crop cube
if crop
    [struct_cube, struct_xgv, struct_ygv, struct_zgv] = hg_cropcube(...
        struct_cube, xgv, ygv, zgv, crop_shift);
end

% %% Remove planes within the structure cube where strucutre contour is not defined
% for k=1:length(struct_zgv)
%     if ~sum(sum(struct_cube(:,:,k)))
%         error('Remove planes within the structure dosecube where strucutre contour is not defined!');
%     end
% end
end