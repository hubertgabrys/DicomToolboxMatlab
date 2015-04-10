function compactness = hg_calcStructCompactness( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

eigvals = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing );
volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing);

compactness = 6*prod(eigvals)/volume;
end