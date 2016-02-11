function density = hg_calcStructDensity( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[~,covmat] = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing );
volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing);

density = nthroot(volume,3)/(covmat(1,1)+covmat(2,2)+covmat(3,3));
end

