function volume = calcStrucVolume(struct_cube_mask, xspacing, yspacing, zspacing)
% function requires binary 3D structure and and spacing in 3D directions
no_vox = sum(sum(sum(struct_cube_mask)));
voxel_vol = xspacing*yspacing*zspacing;
volume = no_vox * voxel_vol;
end