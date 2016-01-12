function subvol_mean = hg_calcStructSubvolumes(struct_cube, resolution)

x_idx = findborders(struct_cube, resolution, 1);
y_idx = findborders(struct_cube, resolution, 2);
z_idx = findborders(struct_cube, resolution, 3);
x_idx = [0, x_idx, size(struct_cube,1)];
y_idx = [0, y_idx, size(struct_cube,2)];
z_idx = [0, z_idx, size(struct_cube,3)];

for i=1:resolution
    for j=1:resolution
        for k=1:resolution
            subvol = struct_cube(x_idx(i)+1:x_idx(i+1),...
                y_idx(j)+1:y_idx(j+1),z_idx(k)+1:z_idx(k+1));
            %subvol_mean(i,j,k) = sum(sum(sum(subvol)))/nnz(subvol);
            subvol_mean.(['sv',num2str(i),num2str(j),num2str(k)]) =...
                sum(sum(sum(subvol)))/nnz(subvol);
        end
    end
end
subvol_mean = struct2table(subvol_mean);
end

function idx = findborders(struct_cube, resolution, dim)
dimlength = size(struct_cube, dim);
dim_nnz = zeros(dimlength,1);
dim_nnz_cum = zeros(dimlength,1);
for i=1:dimlength
    switch dim
        case 1
            dim_nnz(i,1) = nnz(struct_cube(i,:,:));
        case 2
            dim_nnz(i,1) = nnz(struct_cube(:,i,:));
        case 3
            dim_nnz(i,1) = nnz(struct_cube(:,:,i));
    end
    dim_nnz_cum(i,1) = sum(dim_nnz);
end
pVol = round(nnz(struct_cube)/resolution);
for i=1:resolution-1
    [~, idx(i)] = min(abs(dim_nnz_cum-i*pVol)); %index of closest value
end
end