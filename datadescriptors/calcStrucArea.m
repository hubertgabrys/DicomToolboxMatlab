function area_total = calcStrucArea(V, xspac, yspac, zspac)
% function requires binary 3D structure and and spacing in 3D directions
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
area_x = no_vox*yspac*zspac;
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
area_y = no_vox*xspac*zspac;
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