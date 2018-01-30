function structures = calc_struct_masks(rtss_path, xVec, yVec, zVec)
% The function calculates logical masks of structures defined in RTSTRUCT
% dicom file. The grid is defined by the grid vectors xVec, yVec, zVec.
% Interpolation between binary slices is based on the algorithm presented
% in Schenk et al., Efficient semiautomatic segmentation of 3D objects in
% medical images.
%
% Hubert Gabrys <hubert.gabrys@gmail.com>
% License: MIT
%

% structures to skip
struct2skip = {'AUSSENKONTUR', 'SKIN'};
%struct2skip = {''};

% calculate structures' masks
dicom_info = read_dicominfo(rtss_path, true, false);
list_of_contoured_strucs = fieldnames(dicom_info.ROIContourSequence);
for j = 1:length(list_of_contoured_strucs) % for every contoured structure
    roinumber  = dicom_info.ROIContourSequence.(list_of_contoured_strucs{j}).ReferencedROINumber;
    struct_name = getStructName(dicom_info,roinumber);
    if nnz(ismember(struct2skip, struct_name)) % don't calculate structures defined in struct2skip
        continue;
    end
    try
        list_of_slices = fieldnames(dicom_info.ROIContourSequence.(list_of_contoured_strucs{j}).ContourSequence);
    catch
        % warning('Reference to non-existent field ContourSequence. Moving to the next structure.');
        continue;
    end
    %i = 0;
    %zCoords = zeros(length(list_of_slices),1);
    temp_struct_mask = zeros(0);
    for k = 1:length(list_of_slices) % for every slice in a given structure
        slice = dicom_info.ROIContourSequence.(list_of_contoured_strucs{j}).ContourSequence.(list_of_slices{k});
        if ~strcmpi(slice.ContourGeometricType, 'POINT') % if the slice is NOT a point
            [slice_mask, slice_vetrices, zCoord] = calcSliceMask(slice, xVec, yVec);
            
            temp_struct_mask{k,1} = zCoord;
            temp_struct_mask{k,2} = slice_mask;
            temp_struct_mask{k,3} = slice_vetrices;

%             if k == 1
%                 struct_vetrices = slice_vetrices;
%             else
%                 struct_vetrices = vertcat(struct_vetrices,slice_vetrices);
%             end
%             zCoords(k) = zCoord;
%             if k>1 && zCoord == zCoords(k-1)
%                 struct_mask(:,:,i) = struct_mask(:,:,i)+slice_mask;
%             else
%                 i = i+1;
%                 struct_mask(:,:,i) = slice_mask;
%             end
        end
    end
    if strcmpi(slice.ContourGeometricType, 'POINT') % skip reference point
       continue; 
    end
    
    struct_zVec = sort(unique(cell2mat(temp_struct_mask(:,1))));
    for ii=1:length(struct_zVec) %for each slice
        slice_masks = temp_struct_mask(cell2mat(temp_struct_mask(:,1)) == struct_zVec(ii),2);
        slice_vetrices = temp_struct_mask(cell2mat(temp_struct_mask(:,1)) == struct_zVec(ii),3);
        for jj=1:size(slice_masks,1) % there may be multiple struct definintions on one slice
            if jj == 1
                struct_mask(:,:,ii) = cell2mat(slice_masks(jj,1));
                struct_vetrices = cell2mat(slice_vetrices(jj,1));
            else
                struct_mask(:,:,ii) = struct_mask(:,:,ii)+cell2mat(slice_masks(jj,1));
                struct_vetrices = vertcat(struct_vetrices, cell2mat(slice_vetrices(jj,1)));
            end
        end
    end
%     if ~(isequal(zCoords, sort(zCoords,'descend')) || isequal(zCoords, sort(zCoords,'ascend'))) %safe check
%         disp('slices definitions non monotonic!'); % Fix it!
%         pause;
%         continue;
%     end
    if exist('struct_vetrices', 'var')
        % interpolate structure mask to cube
        %struct_zVec = unique(struct_vetrices(:,3));
        if length(struct_zVec) > 1
            [x, y, z] = meshgrid(xVec,yVec,struct_zVec); % existing data
            [xi, yi, zi] = meshgrid(xVec,yVec,zVec); % including new slice
            imdist = @(x) -bwdist(bwperim(x)).*~x + bwdist(bwperim(x)).*x;
            struct_mask = +struct_mask;
            struct_mask_dist = zeros(0);
            for m = 1:size(struct_mask,3)
                struct_mask_dist(:,:,m) = imdist(struct_mask(:,:,m));
            end
            struct_mask_i = interp3(x,y,z,struct_mask_dist,xi,yi,zi);
            clear x y z struct_mask_dist xi yi zi struct_mask
            struct_mask_i = struct_mask_i>=0;
            
            noofnonzeroslices = 0;
            for m = 1:size(struct_mask_i,3)
                if sum(sum(struct_mask_i(:,:,m))) > 0
                    noofnonzeroslices = noofnonzeroslices+1;
                end
            end
            if noofnonzeroslices < 2 % number of nonzero slices
                % disp('Single slice structure skipped!'); % Fix it!
                continue;
            end
%             emptyplanes = false;
%             for k=1:size(struct_mask_i,3)
%                 if ~sum(sum(struct_mask_i(:,:,k)))
%                     emptyplanes = true;
%                 end
%             end
%             if emptyplanes
%                 disp('Remove planes within the structure dosecube where strucutre contour is not defined!');
%                 continue;
%             end
            
            structures.(struct_name).indicator_mask = struct_mask_i;
            structures.(struct_name).structure_vetrices = struct_vetrices;
            clear struct_mask_i struct_vetrices;
        else
            % disp('Single slice structure skipped!'); % Fix it!
        end
    end
end

function struc_name = getStructName(dicom_info, roinumber)
% dicomStructuresInfo.StructureSetROISequence contains a list of all
% defined structers
list_of_defined_struc = ...
    fieldnames(dicom_info.StructureSetROISequence);
% get name of a structure
for k = 1:length(list_of_defined_struc)
    if roinumber == dicom_info.StructureSetROISequence.(...
            list_of_defined_struc{k}).ROINumber
        struc_name = dicom_info.StructureSetROISequence.(...
            list_of_defined_struc{k}).ROIName;
        break;
    end
end
%struc_name = dicom_struc_info.StructureSetROISequence.(...
%    list_of_defined_struc{roinumber}).ROIName;
% change nonalphanumeric characters to underscore
struc_name_oryg = struc_name;
struc_name(~isstrprop(struc_name, 'alphanum')) = '_';
struc_name = regexprep(struc_name,'[^a-zA-Z0-9]','_');
while strcmp(struc_name(end),'_')
    struc_name = [struc_name, 'ux'];
end
while strcmp(struc_name(1),'_')
    struc_name = ['ux', struc_name];
end
% if ~strcmp(struc_name_oryg,struc_name)
%     fprintf('\n')
%     fprintf([struc_name_oryg, ' changed to ', struc_name, '\n'])
% end
    
% change all characters to lowercase
struc_name = lower(struc_name);

function [slice_mask, slice_vetrices, zCoord] = calcSliceMask(slice, xVec, yVec)
zCoord = slice.ContourData(3);
xCoord = zeros(slice.NumberOfContourPoints,1); % prealocation
yCoord = zeros(slice.NumberOfContourPoints,1); % prealocation
mx = 1;
my = 2;
%for every contour point in this structure_slice
for m = 1:slice.NumberOfContourPoints;
    xCoord(m) = slice.ContourData(mx);
    yCoord(m) = slice.ContourData(my);
    mx = mx + 3;
    my = my + 3;
end
xCoord = [xCoord; xCoord(1)]; % close the contour
yCoord = [yCoord; yCoord(1)]; % close the contour
slice_vetrices = [xCoord, yCoord, ones(length(xCoord),1)*zCoord];
[X, Y] = meshgrid(xVec, yVec);
slice_mask = inpolygon(X, Y, xCoord, yCoord);

