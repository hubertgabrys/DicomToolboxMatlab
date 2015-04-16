function slice = hg_plotdose( tps_data, selected_structures, slice, contourcolor, ax )
%
%
%
% h.gabrys@dkfz.de, 2014-15

cube = tps_data.dose.cube;
%dosecube = flip(dosecube,2);
xVec = tps_data.dose.xVec;
yVec = tps_data.dose.yVec;
zVec = tps_data.dose.zVec;

if slice == -1
    slice = round(length(zVec)/2);
end
if (slice > length(zVec))
    slice = slice-1;
end
if (slice < 1)
    slice = slice+1;
end
%disp(slice)

%% plot dose
axes(ax)
showTitle = true;
showLabels = false;
showScale = false;
structure_zCoordinate = zVec(slice);
[X, Y] = meshgrid(yVec, xVec);
Z = cube(:,:,slice);
surf(X, Y, Z, 'LineStyle', 'none');
cmax = ceil(max(cube(:))); % this finds maximum dose in the dosecube
caxis(ax, [0,cmax]); % this sets limits of colors on a plot
colormap(ax, jet(1024));
if showScale
    colorbar(ax, 'location','eastoutside');
end
if showLabels
    xlabel(ax, {'Transverse (y) axis'});
    ylabel(ax, {'Sagittal (x) axis'});
end
axis(ax, [min(yVec) max(yVec) min(xVec) max(xVec)])
view(ax, 0,-90)
if showTitle
    title(ax, {['Z coordinate: ' num2str(structure_zCoordinate)], ['Slice: ' num2str(slice)]});
end
hold on;

%% plot structure conturs
if ~isempty(selected_structures)
for i = 1:length(selected_structures)
    structure = tps_data.structures.(selected_structures{i});
    if size(structure.structure_vetrices,1) > 2
        sliceMin = find(zVec == min(structure.structure_vetrices(2:end,3)));
        sliceMax = find(zVec == max(structure.structure_vetrices(2:end,3)));
        if (sliceMax < sliceMin)
            temp = sliceMin;
            sliceMin = sliceMax;
            sliceMax = temp;
        end
        if and(slice <= sliceMax, slice >= sliceMin)        
            structure_xCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,1);
            structure_yCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,2);
            plot(ax, structure_xCoordinates,structure_yCoordinates, 'LineWidth', 2, 'Color', contourcolor(i,:));
        end
    end
end
end
hold off,
end