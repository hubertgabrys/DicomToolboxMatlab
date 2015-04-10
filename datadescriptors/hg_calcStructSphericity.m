function sphericity = hg_calcStructSphericity( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

area = calcStrucArea(struct_cube_mask, xspacing, yspacing, zspacing);
volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing);

sphericity = nthroot(6*pi*volume^2,3)/area;
end

