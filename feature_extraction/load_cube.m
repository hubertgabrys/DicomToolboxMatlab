function [struct_cube, struct_xgv, struct_ygv, struct_zgv] = load_cube( tps_data, strucname, cube_type )


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
    struct_cube = cube .* double(indmsk);
elseif strcmp(cube_type,'ct')
    struct_cube = cube .* double(indmsk);
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

function [V, x1gv, x2gv, x3gv] = hg_cropcube(V, x1gv, x2gv, x3gv, shift)
%
% hg_cropcube crops the volume by cutting out zero-valued voxels
% surrounging a non-zero valued voxels.
% if shift == 'zero' then x1gv, x2gv and x3gv will be shifted in a way that
% they start at zero go in positive direction.
%
%% Crop cube
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

if strcmp(shift, 'zero')
    %% Transform grid vectors so they origin at 0
    x1gv = abs(x1gv-x1gv(1));
    x2gv = abs(x2gv-x2gv(1));
    x3gv = abs(x3gv-x3gv(1));
end
end

function [ Vi, xgvi, ygvi, zgvi ] = hg_interpcube( V, xgv, ygv, zgv, ...
    interp_interval, interp_method)

[X,Y,Z] = meshgrid(xgv, ygv, zgv);
xgvi = xgv(1):interp_interval:xgv(end);
ygvi = ygv(1):interp_interval:ygv(end);
zgvi = zgv(1):interp_interval:zgv(end);
[Xi,Yi,Zi] = meshgrid(xgvi, ygvi, zgvi);
Vi = interp3(X,Y,Z,V,Xi,Yi,Zi,interp_method);
end

function shell = volume2shell( V )
%hg_volume2shell transforms volume to surface by subtracting eroded volume
%from the original volume.
%   V is binary 3-dimensional structure.

V_eroded = convn(logical(V),ones(3,3,3)/9,'same')>=3;
shell = V - V_eroded;
end