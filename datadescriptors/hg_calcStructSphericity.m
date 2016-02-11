function sphericity = hg_calcStructSphericity( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED7 Summary of this function goes here
%   https://en.wikipedia.org/wiki/Sphericity

area = calcStrucArea(struct_cube_mask, xspacing, yspacing, zspacing);
volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing);

sphericity = pi^(1/3)*(6*volume)^(2/3)/area;
end

