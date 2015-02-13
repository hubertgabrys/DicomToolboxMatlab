function hg_plotdose( dosecubes, selected_structures, slice, contourcolor )
%
%
%
% h.gabrys@dkfz.de, 2014-15

dosecube = dosecubes.dosecube.dosecube;
%dosecube = flip(dosecube,2);
xVector = dosecubes.dosecube.dosecube_xVector;
yVector = dosecubes.dosecube.dosecube_yVector;
zVector = dosecubes.dosecube.dosecube_zVector;

%% plot dose
structure_zCoordinate = zVector(slice);
[X, Y] = meshgrid(yVector, xVector);
Z = dosecube(:,:,slice);
surf(X, Y, Z, 'LineStyle', 'none');
cmax = ceil(max(dosecube(:))); % this finds maximum dose in the dosecube
caxis([0,cmax]); % this sets limits of colors on a plot
colormap(jet(1024));
colorbar('location','eastoutside');
xlabel({'Transverse (y) axis'});
ylabel({'Sagittal (x) axis'});
view(0,-90)
title({['Z coordinate: ' num2str(structure_zCoordinate)], ['Slice: ' num2str(slice)]});
hold on;

%% plot structure conturs
if ~isempty(selected_structures)
for i = 1:length(selected_structures)
    structure = dosecubes.(selected_structures{i});
    if size(structure.structure_vetrices,1) > 2
        sliceMin = find(zVector == min(structure.structure_vetrices(2:end,3)));
        sliceMax = find(zVector == max(structure.structure_vetrices(2:end,3)));
        if (sliceMax < sliceMin)
            temp = sliceMin;
            sliceMin = sliceMax;
            sliceMax = temp;
        end
        if and(slice <= sliceMax, slice >= sliceMin)        
            structure_xCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,1);
            structure_yCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,2);
            plot(structure_xCoordinates,structure_yCoordinates, 'LineWidth', 2, 'Color', contourcolor(i,:));
        end
    end
end
end
hold off,
end