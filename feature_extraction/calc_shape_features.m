function shape = calc_shape_features(struct_cube_msk, xspac, yspac, zspac)

shape.area = calc_area(struct_cube_msk, xspac, yspac, zspac);
shape.volume = calc_volume(struct_cube_msk, xspac, yspac, zspac);
shape.eccentricity = calc_eccentricity(struct_cube_msk, xspac, yspac, zspac);    
shape.compactness = calc_compactness(struct_cube_msk, xspac, yspac, zspac);    
shape.density= calc_density(struct_cube_msk, xspac, yspac, zspac);      
shape.sphericity = calc_sphericity(struct_cube_msk, xspac, yspac, zspac);
% shape.aspratios = calc_shape_ratios(struct_cube_msk, xspac, yspac, zspac);

eigenvals = sort(calc_eigenvalues(struct_cube_msk, xspac, yspac, zspac));
shape.eigen_min = eigenvals(1);
shape.eigen_middle = eigenvals(2);
shape.eigen_max = eigenvals(3);

end

function area_total = calc_area(V, xspac, yspac, zspac)
% function requires binary 3D structure and and spac in 3D directions
for j=1:size(V,1)
    if j==1
        no_vox = sum(sum(V(j,:,:)));
    elseif j==size(V,1)
        tmp_area = sum(sum(V(j,:,:)));
        no_vox = no_vox+tmp_area;
    else
        foo = V(j,:,:)-V(j-1,:,:); % this is to prevent counting voxels that are within the structure
        tmp_area = sum(sum(abs(foo)));
        no_vox = no_vox+tmp_area;
    end
end
area_y = no_vox*xspac*zspac;
for j=1:size(V,2)
    if j==1
        no_vox = sum(sum(V(:,j,:)));
    elseif j==size(V,2)
        tmp_area = sum(sum(V(:,j,:)));
        no_vox = no_vox+tmp_area;
    else
        foo = V(:,j,:)-V(:,j-1,:);
        tmp_area = sum(sum(abs(foo)));
        no_vox = no_vox+tmp_area;
    end
end
area_x = no_vox*yspac*zspac;
for j=1:size(V,3)
    if j==1
        no_vox = sum(sum(V(:,:,j)));
    elseif j==size(V,3)
        tmp_area = sum(sum(V(:,:,j)));
        no_vox = no_vox+tmp_area;
    else
        foo = V(:,:,j)-V(:,:,j-1);
        tmp_area = sum(sum(abs(foo)));
        no_vox = no_vox+tmp_area;
    end
end
area_z = no_vox*xspac*yspac;
area_total = area_x+area_y+area_z;
end

function volume = calc_volume(struct_cube_mask, xspac, yspac, zspac)
% function requires binary 3D structure and and spac in 3D directions
no_vox = sum(sum(sum(struct_cube_mask)));
voxel_vol = xspac*yspac*zspac;
volume = no_vox * voxel_vol;
end

function eccentricity = calc_eccentricity(struct_cube_mask, xspac, yspac, zspac)
%UNTITLED Summary of this function goes here
%   https://en.wikipedia.org/wiki/Image_moment#Examples_2

eigenvals = calc_eigenvalues( struct_cube_mask, xspac, yspac, zspac );

eccentricity = 1-sqrt(min(eigenvals)/max(eigenvals));
%eccentricity = sqrt(1-min(eigenvals)/max(eigenvals));

end

function compactness = calc_compactness( struct_cube_mask, xspac, yspac, zspac  )
% eigvals = calc_eigenvalues( struct_cube_mask, xspac, yspac, zspac );
% volume = calc_volume(struct_cube_mask, xspac, yspac, zspac);
% compactness = 6*prod(eigvals)/volume;
area = calc_area(struct_cube_mask, xspac, yspac, zspac);
volume = calc_volume(struct_cube_mask, xspac, yspac, zspac);
compactness = area/volume;
end

function density = calc_density(struct_cube_mask, xspac, yspac, zspac  )
[~,covmat] = calc_eigenvalues(struct_cube_mask, xspac, yspac, zspac);
volume = calc_volume(struct_cube_mask, xspac, yspac, zspac);
density = nthroot(volume,3)/(covmat(1,1)+covmat(2,2)+covmat(3,3));
end

function sphericity = calc_sphericity(struct_cube_mask, xspac, yspac, zspac  )
%   https://en.wikipedia.org/wiki/Sphericity
area = calc_area(struct_cube_mask, xspac, yspac, zspac);
volume = calc_volume(struct_cube_mask, xspac, yspac, zspac);
sphericity = pi^(1/3)*(6*volume)^(2/3)/area;
end

% Apsect ratios not used yet
function aspratios = calc_shape_ratios(struct_cube_msk, xspac, yspac, zspac)
%   http://www.academicos.ccadet.unam.mx/jorge.marquez/cursos/imagenes_neurobiomed/Morphometry/ShapeDescriptors_I.pdf
%   http://www.academicos.ccadet.unam.mx/jorge.marquez/cursos/imagenes_neurobiomed/Morphometry/ShapeDescriptors_II.pdf

eigenvals = calc_eigenvalues(struct_cube_msk, xspac, yspac, zspac);

aspratios(1) = eigenvals(2)/eigenvals(1);
aspratios(2) = eigenvals(3)/eigenvals(1);
aspratios(3) = eigenvals(3)/eigenvals(2);

end