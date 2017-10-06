function slice = plot_structure_dose( tps_data, selected_structures, slice, contourcolor, ax )

cube = tps_data.dose.cube;
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
showScale = true;
structure_zCoordinate = zVec(slice);
[X, Y] = meshgrid(xVec, yVec);
Z = cube(:,:,slice);
surf(X, Y, Z, 'LineStyle', 'none');
cmax = ceil(max(cube(:))); % this finds maximum dose in the dosecube
caxis(ax, [0,cmax]); % this sets limits of colors on a plot
colormap(ax, jet(1024));
if showScale
    %colorbar(ax, 'location','eastoutside');
    % colorbar('location','eastoutside');
end
if showLabels
    xlabel(ax, {'Transverse (y) axis'});
    ylabel(ax, {'Sagittal (x) axis'});
end
axis(ax, [min(xVec) max(xVec) min(yVec) max(yVec)])
view(ax, 0,-90)
hold on;

%% plot structure conturs
x_min = xVec(end);
x_max = xVec(1);
y_min = yVec(end);
y_max = yVec(1);
if ~isempty(selected_structures)
    for i = 1:length(selected_structures)
        structure = tps_data.structures.(selected_structures{i});
        % plot interpolated contours
        B = bwboundaries(bwperim(structure.indicator_mask(:,:,slice)),'noholes');
        for j=1:size(B,1)
            poly = B{j};
            structure_xCoordinates = (poly(:,2)-1)*(xVec(2)-xVec(1))+xVec(1);
            structure_yCoordinates = (poly(:,1)-1)*(yVec(2)-yVec(1))+yVec(1);
            plot(ax, structure_xCoordinates,structure_yCoordinates, 'LineWidth', 2, 'Color', contourcolor(i,:));
            if min(structure_xCoordinates) < x_min
                x_min = min(structure_xCoordinates);
            end
            if max(structure_xCoordinates) > x_max
                x_max = max(structure_xCoordinates);
            end
            if min(structure_yCoordinates) < y_min
                y_min = min(structure_yCoordinates);
            end
            if max(structure_yCoordinates) > y_max
                y_max = max(structure_yCoordinates);
            end
        axis(ax, [x_min x_max y_min y_max]);    
        end
        % plot original countours <- DO NOT DELETE THIS!
        % structure_xCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,1);
        % structure_yCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,2);
        % plot(ax, structure_xCoordinates,structure_yCoordinates, 'LineWidth', 1, 'Color', 'Red');
    break;
    end
end
hold off,
end