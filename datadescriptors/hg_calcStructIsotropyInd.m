function indices = hg_calcStructIsotropyInd( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED7 Summary of this function goes here

%   http://www.academicos.ccadet.unam.mx/jorge.marquez/cursos/imagenes_neurobiomed/Morphometry/ShapeDescriptors_II.pdf

eigenvals = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing );

error('Not implemented yet');


end

