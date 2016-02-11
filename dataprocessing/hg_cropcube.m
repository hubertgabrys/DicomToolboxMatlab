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