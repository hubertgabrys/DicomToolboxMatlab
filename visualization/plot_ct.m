function slice = plot_ct( tps_data, selected_structures, slice, contourcolor, ax )
%
% Hubert Gabrys <hubert.gabrys@gmail.com>
% License: MIT
%

cube = tps_data.ct.cube;
%dosecube = flip(dosecube,2);
xVec = tps_data.ct.xVec;
yVec = tps_data.ct.yVec;
zVec = tps_data.ct.zVec;

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
showLabels = true;
showScale = false;
structure_zCoordinate = zVec(slice);
[X, Y] = meshgrid(xVec, yVec);
Z = cube(:,:,slice);
surf(X, Y, Z, 'LineStyle', 'none');
cmax = ceil(max(cube(:))); % this finds maximum dose in the dosecube
caxis(ax, [0,cmax]); % this sets limits of colors on a plot
colormap(ax, gray(1024));
if showScale
    colorbar(ax, 'location','eastoutside');
end
if showLabels
    xlabel(ax, {'X: right -> left'});
    ylabel(ax, {'Y: posterior <- anterior'});
end
axis(ax, [min(xVec) max(xVec) min(yVec) max(yVec)])
view(ax, 0,-90)
if showTitle
    title(ax, {['Z coordinate: ' num2str(structure_zCoordinate)], ['Slice: ' num2str(slice)]});
end
hold on;

%% plot structure conturs
if ~isempty(selected_structures)
    for i = 1:length(selected_structures)
        structure = tps_data.structures.(selected_structures{i});
        % plot interpolated contours
        B = bwboundaries(bwperim(structure.indicator_mask(:,:,slice)),'noholes');
        for j=1:size(B,1)
            poly = B{j};
            structure_xCoordinates = (poly(:,2)-1)*(xVec(2)-xVec(1))+xVec(1);
            structure_yCoordinates = (poly(:,1)-1)*(yVec(2)-yVec(1))+yVec(1);
            plot(ax, structure_xCoordinates,structure_yCoordinates, 'LineWidth', 1, 'Color', contourcolor(i,:));
        end
        % plot original countours <- DO NOT DELETE THIS!
        % structure_xCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,1);
        % structure_yCoordinates = structure.structure_vetrices(structure.structure_vetrices(:,3) == structure_zCoordinate,2);
        % plot(ax, structure_xCoordinates,structure_yCoordinates, 'LineWidth', 1, 'Color', 'Red');
    end
end
hold off,
end