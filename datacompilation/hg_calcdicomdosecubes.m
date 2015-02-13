function dcs = hg_calcdicomdosecubes(rtdose_path,rtstruc_path,output_dir )

% hg_calcdicomdosecubes calculates dosecubes based on rtdose and rtstruc
% dicoms
%
% h.gabrys@dkfz.de, 2014

%% Load a dose cube
fprintf('Loading the dose cube...');
[dc, dc_xVec, dc_yVec, dc_zVec] = loadDoseCube(rtdose_path, rtstruc_path);
fprintf('finished!\n');

%% Add dosecube to dosecubes structure
dcs.dosecube.dosecube = dc;
dcs.dosecube.dosecube_xVector = dc_xVec;
dcs.dosecube.dosecube_yVector = dc_yVec;
dcs.dosecube.dosecube_zVector = dc_zVec;

%% Calculate structures
if ischar(rtstruc_path)
    prefix = '';
    dcs = calcStrucDcs(dc_xVec, dc_yVec, dc_zVec, rtstruc_path, dcs, prefix);
elseif iscell(rtstruc_path) && length(rtstruc_path) == 2
    prefix = 'a_';
    disp('First structure set');
    dcs = calcStrucDcs(dc_xVec, dc_yVec, dc_zVec, rtstruc_path{1}, dcs, prefix);
    prefix = 'b_';
    disp('Second structure set');
    dcs = calcStrucDcs(dc_xVec, dc_yVec, dc_zVec, rtstruc_path{2}, dcs, prefix);
end

%% Save dosecubes as 'dosecubes.mat'
save([output_dir 'dosecubes.mat'], 'dcs');
disp('All structures calculated and saved to dosecubes.mat');
end


function [dc, dc_xVec, dc_yVec, dc_zVec] = loadDoseCube(rtdose_path, ...
    rtstruc_path)
% one rtdose dicom and one rtstruc dicom
if ischar(rtdose_path) && ischar(rtstruc_path)
    [dc, dc_xVec, dc_yVec, dc_zVec] = loadRaw(rtdose_path);
    [dc, dc_xVec, dc_yVec, dc_zVec] = fixing(dc, dc_xVec, dc_yVec, dc_zVec, rtstruc_path);
% two rtdose dicoms and one rtstruc dicom
elseif iscell(rtdose_path) && length(rtdose_path) == 2 && ischar(rtstruc_path)
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = loadRaw(rtdose_path{1});
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = loadRaw(rtdose_path{2});
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = fixing(dc1, dc_xVec1, dc_yVec1, dc_zVec1, rtstruc_path);
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = fixing(dc2, dc_xVec2, dc_yVec2, dc_zVec2, rtstruc_path);
    if size(dc1,1) == size(dc2,1) && size(dc1,2) == size(dc2,2) && size(dc1,3) == size(dc2,3)
        dc = dc1 + dc2;
    else
        error('Basic plan and boost dosecubes have nonmatching dimensions');
    end
    if isequal(dc_xVec1,dc_xVec2) && isequal(dc_yVec1,dc_yVec2) && isequal(dc_zVec1,dc_zVec2)
        dc_xVec = dc_xVec1;
        dc_yVec = dc_yVec1;
        dc_zVec = dc_zVec1;
    else
        error('Basic plan and boost dosecubes'' vectors are nonmatching!');
    end
% three rtdose dicoms and one rtstruc dicom
elseif iscell(rtdose_path) && length(rtdose_path) == 3 && ischar(rtstruc_path)
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = loadRaw(rtdose_path{1});
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = loadRaw(rtdose_path{2});
    [dc3, dc_xVec3, dc_yVec3, dc_zVec3] = loadRaw(rtdose_path{3});
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = fixing(dc1, dc_xVec1, dc_yVec1, dc_zVec1, rtstruc_path);
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = fixing(dc2, dc_xVec2, dc_yVec2, dc_zVec2, rtstruc_path);
    [dc3, dc_xVec3, dc_yVec3, dc_zVec3] = fixing(dc3, dc_xVec3, dc_yVec3, dc_zVec3, rtstruc_path);
    if size(dc1,1) == size(dc2,1) && size(dc1,2) == size(dc2,2) && size(dc1,3) == size(dc2,3)
        if size(dc1,1) == size(dc3,1) && size(dc1,2) == size(dc3,2) && size(dc1,3) == size(dc3,3)
            dc = dc1 + dc2 + dc3;
        else
            error('Basic plan and boost dosecubes have nonmatching dimensions');
        end
    else
        error('Basic plan and boost dosecubes have nonmatching dimensions');
    end
    if isequal(dc_xVec1,dc_xVec2,dc_xVec3) && isequal(dc_yVec1,dc_yVec2,dc_yVec3) && ...
            isequal(dc_zVec1,dc_zVec2,dc_zVec3)
        dc_xVec = dc_xVec1;
        dc_yVec = dc_yVec1;
        dc_zVec = dc_zVec1;
    else
        error('Basic plan and boost dosecubes'' vectors are nonmatching!');
    end
% two rtdose dicoms and two rtstruc dicoms
%{
BULLSHIT!
elseif iscell(rtdose_path) && length(rtdose_path) == 2 && iscell(rtstruc_path) && length(rtstruc_path) == 2
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = loadRaw(rtdose_path{1});
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = loadRaw(rtdose_path{2});
    [dc1, dc_xVec1, dc_yVec1, dc_zVec1] = fixing(dc1, dc_xVec1, dc_yVec1, dc_zVec1, rtstruc_path{1});
    [dc2, dc_xVec2, dc_yVec2, dc_zVec2] = fixing(dc2, dc_xVec2, dc_yVec2, dc_zVec2, rtstruc_path{2});
    dc_xVec = unique([dc_xVec1; dc_xVec2]);
    dc_yVec = unique([dc_yVec1; dc_yVec2]);
    dc_zVec = sort(unique([dc_zVec1; dc_zVec2]),'descend');
    [X1, Y1, Z1] = ndgrid(dc_xVec1, dc_yVec1, dc_zVec1);
    [X2, Y2, Z2] = ndgrid(dc_xVec2, dc_yVec2, dc_zVec2);
    [Xq, Yq, Zq] = ndgrid(dc_xVec, dc_yVec, dc_zVec);
    dc1b = interpn(X1,Y1,Z1,dc1,Xq,Yq,Zq,'linear');
    dc2b = interpn(X2,Y2,Z2,dc2,Xq,Yq,Zq,'linear');
    dc = dc1b + dc2b;
    dc(isnan(dc)) = 0;
else
    error('Check number of input rtdose and rtstruc');
%}
end


    function [dc, dc_xVec, dc_yVec, dc_zVec] = loadRaw(rtdose_path)
        dicomDoseInfo = dicominfo(rtdose_path);
        % first two dimensions are x or y, third dimension is maybe an alpha
        % channel, fourth dimension is a number of slices
        dicomDose = dicomread(rtdose_path);
        dc(:, :, :) = dicomDose(:,:,1,:);
        dc = double(dc); % convert dose values to double
        % multiply by DoseGridScaling to obtain dose in Gy
        dc = dc * dicomDoseInfo.DoseGridScaling;
        [dc_xVec, dc_yVec, dc_zVec] = getPatientsCoords(dicomDoseInfo);
        
        function [xVec, yVec, zVec] = getPatientsCoords(dicomDoseInfo)
            yVec = dicomDoseInfo.ImagePositionPatient(1) + ...
                (0:double(dicomDoseInfo.Columns-1))' * dicomDoseInfo.PixelSpacing(1);
            xVec = dicomDoseInfo.ImagePositionPatient(2) + ...
                (0:double(dicomDoseInfo.Rows-1))' * dicomDoseInfo.PixelSpacing(2);
            % get offset
            if dicomDoseInfo.GridFrameOffsetVector(1) ~= 0
                offset = dicomDoseInfo.GridFrameOffsetVector - ...
                    dicomDoseInfo.GridFrameOffsetVector(1);
            else
                offset = dicomDoseInfo.GridFrameOffsetVector;
            end
            zVec = dicomDoseInfo.ImagePositionPatient(3) + offset;
        end
        
    end

    function [dc, dc_xVec, dc_yVec, dc_zVec] = fixing(dc, dc_xVec, dc_yVec, dc_zVec, rtstruc_path)
        % fixing:
        %   1.  flips cube if zVec is ascending, so zVec is always
        %       descending
        %   2.  Interpolates dosecube by means of all possible structure z
        %       coordinates
        %   3.  If there are any NaN values in cube, change them to 0
        
        %% Flip cube if zVec is ascending
        if dc_zVec(2) - dc_zVec(1) > 0
            dc_zVec(:,1) = flip(dc_zVec);
            dc = flip(dc, 3);
            %dc_yVec(:,1) = flip(dc_yVec);
            %dc = flip(dc, 2);
        end
        % now slices go in cranial-caudal direction
        %% Interpolate the dosecube
        % set spacing manually
        % sometimes instead 0.5 one finds 0.49999. Let's approximate
        % dc_zVec = round(dc_zVec*10)/10;
        % spacing = (dc_zVec(2) - dc_zVec(1))/2;
        % dc_zVeci = dc_zVec(1):spacing:dc_zVec(end);
        %
        % get spacing by analyzing all possible strucutre z coords
        dc_zVeci = findzvec(rtstruc_path);
        dc_xVeci = dc_xVec;
        dc_yVeci = dc_yVec;
        [X1o,X2o,X3o] = ndgrid(dc_xVec, dc_yVec, dc_zVec);
        [X1i,X2i,X3i] = ndgrid(dc_xVeci, dc_yVeci, dc_zVeci);
        dc = interpn(X1o,X2o,X3o,dc,X1i,X2i,X3i,'linear');
        %% Change NaNs to 0
        dc(isnan(dc)) = 0;
        dc_xVec = dc_xVeci;
        dc_yVec = dc_yVeci;
        dc_zVec = dc_zVeci;
        
        function zVec = findzvec(rtstruc_path)
            dicom_struc_info = dicominfo(rtstruc_path);
            % dicomStructuresInfo.ROIContourSequence contains a list of all contoured
            % structers
            list_of_contoured_strucs = ...
                fieldnames(dicom_struc_info.ROIContourSequence);
            i = 1;
            for j = 1:(length(list_of_contoured_strucs)); % for every structure
                %% Calculate contour polygon and indicator_mask
                % list of slices of a given structure
                list_of_slices = fieldnames(dicom_struc_info.ROIContourSequence.(...
                    list_of_contoured_strucs{j}).ContourSequence);
                for k = 1:length(list_of_slices) % for every slice in a given structure
                    % get structure_slice
                    struc_slice = dicom_struc_info.ROIContourSequence.(...
                        list_of_contoured_strucs{j}).ContourSequence.(...
                        list_of_slices{k});
                    if strcmpi(struc_slice.ContourGeometricType, 'POINT')
                        continue;
                    end
                    % get z coordinate of this slice
                    zVec(i,1) = struc_slice.ContourData(3);
                    i = i+1;
                end
            end
            zVec = sort(unique(zVec),'descend');
        end
        
    end
end


function dcs = calcStrucDcs(dc_xVec,dc_yVec,dc_zVec, rtstruc_path, dcs, prefix)
dicom_struc_info = dicominfo(rtstruc_path);
% dicomStructuresInfo.StructureSetROISequence contains a list of all
% defined structers
list_of_defined_struc = ...
    fieldnames(dicom_struc_info.StructureSetROISequence);
% dicomStructuresInfo.ROIContourSequence contains a list of all contoured
% structers
list_of_contoured_strucs = ...
    fieldnames(dicom_struc_info.ROIContourSequence);


for j = 1:(length(list_of_contoured_strucs)); % for every structure
    %% structure_name formating section
    roinumber  = dicom_struc_info.ROIContourSequence.(...
        list_of_contoured_strucs{j}).ReferencedROINumber;
    % get name of a structure
    for k = 1:length(list_of_defined_struc)
        if roinumber == dicom_struc_info.StructureSetROISequence.(...
                list_of_defined_struc{k}).ROINumber;
            struc_name = dicom_struc_info.StructureSetROISequence.(...
                list_of_defined_struc{k}).ROIName;
            break;
        end
    end
    %struc_name = dicom_struc_info.StructureSetROISequence.(...
    %    list_of_defined_struc{roinumber}).ROIName;
    % change nonalphanumeric chars to underscore
    struc_name(~isstrprop(struc_name, 'alphanum')) = '_';
    struc_name = regexprep(struc_name,'[^a-zA-Z0-9]','_');
    % change all chars to uppercase
    struc_name = [prefix upper(struc_name)];
    fprintf('Calculating %s contours...', struc_name);
    % initialize indicator_mask of a size of the dosecube
    %initialization is important. if you don't do this structure dosecube
    % will contain only one line
    indicator_mask = false(length(dc_xVec), length(dc_yVec), ...
        length(dc_zVec));
    %% Calculate contour polygon and indicator_mask
    % list of slices of a given structure
    list_of_slices = fieldnames(dicom_struc_info.ROIContourSequence.(...
        list_of_contoured_strucs{j}).ContourSequence);
    struc_vetrices = zeros(1,3);
    for k = 1:length(list_of_slices) % for every slice in a given structure
        % get structure_slice
        struc_slice = dicom_struc_info.ROIContourSequence.(...
            list_of_contoured_strucs{j}).ContourSequence.(...
            list_of_slices{k});
        if strcmpi(struc_slice.ContourGeometricType, 'POINT')
            continue;
        end
        % check if structure_slice is inside the dosecube
        % get z coordinate of this slice
        struc_zCoord = struc_slice.ContourData(3);
        struc_inside_dc = sum(dc_zVec == struc_zCoord);
        % sometimes structures are defined outside the dosecube.
        % This 'if' is skipping them.
        if struc_inside_dc
            % [structure_xCoordinates, structure_yCoordinates] vectors are
            % cartesian coordinates of polygon vertices
            [struc_xCoord, struc_yCoord] = calcContourPolygon(struc_slice);
            struc_vetrices = vertcat(struc_vetrices, [struc_xCoord, ...
                struc_yCoord, ones(length(struc_xCoord),1)*struc_zCoord]);
            % find index of this slice in the doseCube
            dc_zIndex = dc_zVec == struc_zCoord;
            % Indicator_mask which represents voxels enclosed by the
            % structure
            indicator_mask(:,:,dc_zIndex) = ...
                calcIndicatorMaskSlice(dc_xVec, dc_yVec, struc_xCoord, ...
                struc_yCoord);
        elseif (struc_zCoord > dc_zVec(1) && ...
                struc_zCoord < dc_zVec(end)) || ...
                (struc_zCoord < dc_zVec(1) && ...
                struc_zCoord > dc_zVec(end))
            %error('Structure slice between slices of the dosecube!');
            disp('Structure slice between slices of the dosecube!');
        end
    end
    fprintf('finished!\n');
    %% Add indicator_mask and structure_vetrices to dosecubes structure
    dcs.(struc_name).indicator_mask = indicator_mask;
    dcs.(struc_name).structure_vetrices = struc_vetrices;
end


    function [struc_xCoord, struc_yCoord] = calcContourPolygon(struc_slice)
        struc_xCoord = zeros(struc_slice.NumberOfContourPoints,1); % prealocation
        struc_yCoord = zeros(struc_slice.NumberOfContourPoints,1); % prealocation
        mx = 1;
        my = 2;
        %for every contour point in this structure_slice
        for m = 1:struc_slice.NumberOfContourPoints;
            struc_xCoord(m) = struc_slice.ContourData(mx);
            struc_yCoord(m) = struc_slice.ContourData(my);
            mx = mx + 3;
            my = my + 3;
        end
        struc_xCoord = [struc_xCoord; struc_xCoord(1)]; % close the contour
        struc_yCoord = [struc_yCoord; struc_yCoord(1)]; % close the contour
    end


    function indicator_mask_slice = calcIndicatorMaskSlice(dc_xVec, dc_yVec,...
            struc_xCoords, struc_yCoords)
        [X, Y] = meshgrid(dc_yVec, dc_xVec); % create a meshgrid
        % create logical mask of points inside the polygon
        indicator_mask_slice = inpolygon(X, Y, struc_xCoords, struc_yCoords);
    end

end