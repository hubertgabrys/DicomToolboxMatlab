function [ eigvals, covmat ] = calc_eigenvalues( struct_cube_mask, xspacing, yspacing, zspacing )
%
% Hubert Gabrys <hubert.gabrys@gmail.com>, 2015-2016
% License: MIT

V = struct_cube_mask;
       
% Define grid
[X,Y,Z] = meshgrid(0:size(V,2)-1, 0:size(V,1)-1, 0:size(V,3)-1);
X = X * xspacing;
Y = Y * yspacing;
Z = Z * zspacing;

% Calculate mean values
xbar2 = sum(reshape(X .* V, numel(V), 1)) / sum(reshape(V, numel(V), 1));
ybar2 = sum(reshape(Y .* V, numel(V), 1)) / sum(reshape(V, numel(V), 1));
zbar2 = sum(reshape(Z .* V, numel(V), 1)) / sum(reshape(V, numel(V), 1));

mu_200 = sum(reshape(((X-xbar2).^2) .* V, numel(V), 1));
mu_020 = sum(reshape(((Y-ybar2).^2) .* V, numel(V), 1));
mu_002 = sum(reshape(((Z-zbar2).^2) .* V, numel(V), 1));
mu_110 = sum(reshape((X-xbar2) .* (Y-ybar2) .* V, numel(V), 1));
mu_101 = sum(reshape((X-xbar2) .* (Z-zbar2) .* V, numel(V), 1));
mu_011 = sum(reshape((Y-ybar2) .* (Z-zbar2) .* V, numel(V), 1));

covmat(1,1) = mu_200;
covmat(1,2) = mu_110;
covmat(1,3) = mu_101;
covmat(2,1) = mu_110;
covmat(2,2) = mu_020;
covmat(2,3) = mu_011;
covmat(3,1) = mu_101;
covmat(3,2) = mu_011;
covmat(3,3) = mu_002;

eigvals = eig(covmat);
end
