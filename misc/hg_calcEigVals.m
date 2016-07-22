function [ eigvals, covmat ] = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing )
%
% Hubert Gabrys <hubert.gabrys@gmail.com>, 2015-2016
% This file is licensed under GPLv2
%

mu_200 = hg_calcmom3d(struct_cube_mask,2,0,0,'transinv', xspacing, yspacing, zspacing);
mu_020 = hg_calcmom3d(struct_cube_mask,0,2,0,'transinv', xspacing, yspacing, zspacing);
mu_002 = hg_calcmom3d(struct_cube_mask,0,0,2,'transinv', xspacing, yspacing, zspacing);
mu_110 = hg_calcmom3d(struct_cube_mask,1,1,0,'transinv', xspacing, yspacing, zspacing);
mu_101 = hg_calcmom3d(struct_cube_mask,1,0,1,'transinv', xspacing, yspacing, zspacing);
mu_011 = hg_calcmom3d(struct_cube_mask,0,1,1,'transinv', xspacing, yspacing, zspacing);

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
