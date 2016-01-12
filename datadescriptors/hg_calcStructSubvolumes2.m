function subvol_mean = hg_calcStructSubvolumes2(struct_cube, resolution)

dim_order = [1,2,3];

% first cubes
dim = dim_order(1);
first_idx = findborders(struct_cube, resolution, dim);
first_idx = [0, first_idx, size(struct_cube,dim)];
for i=1:resolution
    switch dim
        case 1
            subvol = struct_cube(first_idx(i)+1:first_idx(i+1),:,:);
        case 2
            subvol = struct_cube(:,first_idx(i)+1:first_idx(i+1),:);
        case 3
            subvol = struct_cube(:,:,first_idx(i)+1:first_idx(i+1));
    end
    first_cubes(i).dimension = dim;
    first_cubes(i).cube = subvol;
end

% second cubes
dim = dim_order(2);
for j=1:resolution
    struct_cube2 = first_cubes(j).cube;
    second_idx = findborders(struct_cube2, resolution, dim);
    second_idx = [0, second_idx, size(struct_cube2,dim)];
    for i=1:resolution
        switch dim
            case 1
                subvol = struct_cube2(second_idx(i)+1:second_idx(i+1),:,:);
            case 2
                subvol = struct_cube2(:,second_idx(i)+1:second_idx(i+1),:);
            case 3
                subvol = struct_cube2(:,:,second_idx(i)+1:second_idx(i+1));
        end
        second_cubes(j,i).dimension = dim;
        second_cubes(j,i).cube = subvol;
    end
end

% third cubes
dim = dim_order(3);
for k=1:resolution
    for j=1:resolution
        struct_cube3 = second_cubes(k,j).cube;
        third_idx = findborders(struct_cube3, resolution, dim);
        third_idx = [0, third_idx, size(struct_cube3,dim)];
        for i=1:resolution
            switch dim
                case 1
                    subvol = struct_cube3(third_idx(i)+1:third_idx(i+1),:,:);
                case 2
                    subvol = struct_cube3(:,third_idx(i)+1:third_idx(i+1),:);
                case 3
                    subvol = struct_cube3(:,:,third_idx(i)+1:third_idx(i+1));
            end
            third_cubes(k,j,i).dimension = dim;
            third_cubes(k,j,i).cube = subvol;
            subvol_mean.dim_order = dim_order;
            subvol_mean.(['sv',num2str(k),num2str(j),num2str(i)]) =...
                sum(sum(sum(subvol)))/nnz(subvol);
            %             if isnan(sum(sum(sum(subvol)))/nnz(subvol))
            %                 foo;
            %             end
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