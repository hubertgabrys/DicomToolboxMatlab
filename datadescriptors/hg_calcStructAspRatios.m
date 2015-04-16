function aspratios = hg_calcStructAspRatios( struct_cube_mask, xspacing, yspacing, zspacing  )
%UNTITLED7 Summary of this function goes here
%   http://www.academicos.ccadet.unam.mx/jorge.marquez/cursos/imagenes_neurobiomed/Morphometry/ShapeDescriptors_I.pdf
%   http://www.academicos.ccadet.unam.mx/jorge.marquez/cursos/imagenes_neurobiomed/Morphometry/ShapeDescriptors_II.pdf

eigenvals = hg_calcEigVals( struct_cube_mask, xspacing, yspacing, zspacing );


aspratios(1) = eigenvals(2)/eigenvals(1);
aspratios(2) = eigenvals(3)/eigenvals(1);
aspratios(3) = eigenvals(3)/eigenvals(2);


end

