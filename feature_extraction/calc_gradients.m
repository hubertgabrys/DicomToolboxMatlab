function gradients = calc_gradients(dose_cube, xspac, yspac, zspac, struct_cube_msk)

[gx, gy, gz] = gradient(dose_cube, xspac, yspac, zspac);

sgx = gx .* struct_cube_msk;
sgy = gy .* struct_cube_msk;
sgz = gz .* struct_cube_msk;

gradients.gradx = sum(sgx(:))/nnz(sgx(:));
gradients.grady = sum(sgy(:))/nnz(sgy(:));
gradients.gradz = sum(sgz(:))/nnz(sgz(:));

% gradients = struct2table(gradients);
end