function subvol_mean = calc_subvolumes(struct_cube, resolution)

N = nnz(struct_cube);
n = floor(N/resolution);


z1 = permute(struct_cube, [1,2,3]);
z2 = permute(struct_cube, [2,1,3]);

z1_v = nonzeros(z1);
z2_v = nonzeros(z2);

x1 = permute(struct_cube, [1,3,2]);
x2 = permute(struct_cube, [3,1,2]);

x1_v = nonzeros(x1);
x2_v = nonzeros(x2);

y1 = permute(struct_cube, [2,3,1]);
y2 = permute(struct_cube, [3,2,1]);

y1_v = nonzeros(y1);
y2_v = nonzeros(y2);

for i=1:resolution
    subvol_mean1.(['subvol_x',num2str(i),'of',num2str(resolution)]) = mean(x1_v((i-1)*n+1:i*n));
    subvol_mean1.(['subvol_y',num2str(i),'of',num2str(resolution)]) = mean(y1_v((i-1)*n+1:i*n));
    subvol_mean1.(['subvol_z',num2str(i),'of',num2str(resolution)]) = mean(z1_v((i-1)*n+1:i*n));
end

for i=1:resolution
    subvol_mean2.(['subvol_x',num2str(i),'of',num2str(resolution)]) = mean(x2_v((i-1)*n+1:i*n));
    subvol_mean2.(['subvol_y',num2str(i),'of',num2str(resolution)]) = mean(y2_v((i-1)*n+1:i*n));
    subvol_mean2.(['subvol_z',num2str(i),'of',num2str(resolution)]) = mean(z2_v((i-1)*n+1:i*n));
end

fn = fieldnames(subvol_mean1);
for i=1:length(fn)
    subvol_mean.(fn{i}) = mean([subvol_mean1.(fn{i}),subvol_mean2.(fn{i})]);
end

% subvol_mean = struct2table(subvol_mean);

end