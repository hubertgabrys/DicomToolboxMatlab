function eccentricity = calcStrucEccentricity(struct_cube_mask, xspacing, yspacing, zspacing)
%UNTITLED Summary of this function goes here
%   https://en.wikipedia.org/wiki/Image_moment#Examples_2

eigenvals = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing );

eccentricity = 1-sqrt(min(eigenvals)/max(eigenvals));
%eccentricity = sqrt(1-min(eigenvals)/max(eigenvals));

end

