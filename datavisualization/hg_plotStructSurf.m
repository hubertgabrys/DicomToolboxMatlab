function hg_plotStructSurf( struct_cube_mask )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% create a bubble of zeros around the structure
newx = size(struct_cube_mask,1)+2;
newy = size(struct_cube_mask,2)+2;
newz = size(struct_cube_mask,3)+2;
newcube = zeros(newx, newy, newz);
newcube(2:newx-1, 2:newy-1, 2:newz-1) = struct_cube_mask;

% plot structure
isosurface(newcube,0)

end

