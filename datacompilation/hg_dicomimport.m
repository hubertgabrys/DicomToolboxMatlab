function tps_data = hg_dicomimport(rtdose_path,rtstruc_path,ct_dir,output_dir )

% hg_calcdicomdosecubes calculates dosecubes based on rtdose and rtstruc
% dicoms
%
% h.gabrys@dkfz.de, 2014

%% Load a dose cube
fprintf('Loading the dose cube...');
[dose_cube, dose_xVec, dose_yVec, dose_zVec] = loadDoseCube(rtdose_path, rtstruc_path);
fprintf('finished!\n');

%% Load a CT cube
fprintf('Loading the CT cube...');
[ct_cube, ct_xVec, ct_yVec, ct_zVec] = loadCTCube(ct_dir);
fprintf('finished!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHOOSE HERE IF YOU WOULD LIKE TO:
%%   1. EXPAND DC TO THE CT
%%   2. CROP CT DO THE DC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% Expand dose cube to the ct cube
% % x direction
% ct_xVec_e = ceil(100*round(ct_xVec,3)/100);
% dose_xVec_e = ceil(100*round(dose_xVec,3)/100);
% dose_cube_e = dose_cube;
% if ct_xVec_e(1) < dose_xVec_e(1)
%     margin = find(ct_xVec_e == dose_xVec_e(1))-1;
%     dose_xVec_e = [ct_xVec_e(1:margin);dose_xVec_e];
%     delta = margin;
%     dose_cube_e = cat(1, zeros(delta, length(dose_yVec), length(dose_zVec)), dose_cube_e);
% end
% if ct_xVec_e(end) > dose_xVec_e(end)
%     margin = find(ct_xVec_e == dose_xVec_e(end));
%     dose_xVec_e = [dose_xVec_e; ct_xVec_e(margin+1:end)];
%     delta = length(ct_xVec_e)-margin;
%     dose_cube_e = cat(1, dose_cube_e, zeros(delta, length(dose_yVec), length(dose_zVec)));
% end
% if ~isequal(ct_xVec_e,dose_xVec_e)
%     error('ct and dose vectors not equal!')
% end
% 
% % y direction
% ct_yVec_e = ceil(100*round(ct_yVec,3)/100);
% dose_yVec_e = ceil(100*round(dose_yVec,3)/100);
% if ct_yVec_e(1) < dose_yVec_e(1)
%     margin = find(ct_yVec_e == dose_yVec_e(1))-1;
%     dose_yVec_e = [ct_yVec_e(1:margin);dose_yVec_e];
%     delta = margin;
%     dose_cube_e = cat(2, zeros(length(dose_xVec_e), delta, length(dose_zVec)), dose_cube_e);
% end
% if ct_yVec_e(end) > dose_yVec_e(end)
%     margin = find(ct_yVec_e == dose_yVec_e(end));
%     dose_yVec_e = [dose_yVec_e; ct_yVec_e(margin+1:end)];
%     delta = length(ct_yVec_e)-margin;
%     dose_cube_e = cat(2, dose_cube_e, zeros(length(dose_xVec_e), delta, length(dose_zVec)));
% end
% if ~isequal(ct_yVec_e,dose_yVec_e)
%     error('ct and dose vectors not equal!')
% end
% 
% % z direction
% ct_zVec_e = ceil(100*round(ct_zVec,3)/100);
% dose_zVec_e = ceil(100*round(dose_zVec,3)/100);
% ct_zVec_e = flip(ct_zVec_e);
% dose_zVec_e = flip(dose_zVec_e);
% dose_cube_e = flip(dose_cube_e,3);
% if ct_zVec_e(1) < dose_zVec_e(1)
%     margin = find(ct_zVec_e == dose_zVec_e(1))-1;
%     dose_zVec_e = [ct_zVec_e(1:margin);dose_zVec_e];
%     delta = margin;
%     dose_cube_e = cat(3, zeros(length(dose_xVec_e), length(dose_yVec_e), delta), dose_cube_e);
% end
% if ct_zVec_e(end) > dose_zVec_e(end)
%     margin = find(ct_zVec_e == dose_zVec_e(end));
%     dose_zVec_e = [dose_zVec_e; ct_zVec_e(margin+1:end)];
%     delta = length(ct_zVec_e)-margin;
%     dose_cube_e = cat(3, dose_cube_e, zeros(length(dose_xVec_e), length(dose_yVec_e), delta));
% end
% ct_zVec_e = flip(ct_zVec_e);
% dose_zVec_e = flip(dose_zVec_e);
% dose_cube_e = flip(dose_cube_e,3);
% if ~isequal(ct_zVec_e,dose_zVec_e)
%     error('ct and dose vectors not equal!')
% end


%% Crop ct cube to the dose cube
% x direction
ct_xVec_c = ceil(100*round(ct_xVec,3)/100);
dose_xVec_c = ceil(100*round(dose_xVec,3)/100);
ct_cube_new = ct_cube;
if ct_xVec_c(1) <= dose_xVec_c(1)
    margin_start = find(ct_xVec_c == dose_xVec_c(1));
end
if ct_xVec_c(end) >= dose_xVec_c(end)
    margin_end = find(ct_xVec_c == dose_xVec_c(end));
end
ct_xVec_new = ct_xVec(margin_start:margin_end);
ct_cube_new = ct_cube_new(margin_start:margin_end,:,:);
diff = mean(abs(ct_xVec_new-dose_xVec));
if diff > 0.01 % allow some small difference
    error('ct and dose vectors not equal!')
end

% y direction
ct_yVec_c = ceil(100*round(ct_yVec,3)/100);
dose_yVec_c = ceil(100*round(dose_yVec,3)/100);
if ct_yVec_c(1) <= dose_yVec_c(1)
    margin_start = find(ct_yVec_c == dose_yVec_c(1));
end
if ct_yVec_c(end) >= dose_yVec_c(end)
    margin_end = find(ct_yVec_c == dose_yVec_c(end));
end
ct_yVec_new = ct_yVec(margin_start:margin_end);
ct_cube_new = ct_cube_new(:,margin_start:margin_end,:);
diff = mean(abs(ct_yVec_new-dose_yVec));
if diff > 0.01 % allow some small difference
    error('ct and dose vectors not equal!')
end

% z direction
ct_zVec_c = ceil(100*round(ct_zVec,3)/100);
dose_zVec_c = ceil(100*round(dose_zVec,3)/100);
ct_zVec_c = flip(ct_zVec_c);
ct_zVec = flip(ct_zVec);
dose_zVec_c = flip(dose_zVec_c);
ct_cube_new = flip(ct_cube_new,3);
if ct_zVec_c(1) <= dose_zVec_c(1)
    margin_start = find(ct_zVec_c == dose_zVec_c(1));
end
if ct_zVec_c(end) >= dose_zVec_c(end)
    margin_end = find(ct_zVec_c == dose_zVec_c(end));
end
ct_zVec_new = ct_zVec(margin_start:margin_end);
ct_cube_new = ct_cube_new(:,:,margin_start:margin_end);
ct_zVec_new = flip(ct_zVec_new);
%dose_zVec_new = flip(dose_zVec_new);
ct_cube_new = flip(ct_cube_new,3);
%ct_zVec = flip(ct_zVec);
diff = mean(abs(ct_zVec_new-dose_zVec));
if diff > 0.01 % allow some small difference
    error('ct and dose vectors not equal!')
end


%% Add dosecube to dosecubes structure
tps_data.dose.cube = dose_cube;
tps_data.dose.xVec = dose_xVec;
tps_data.dose.yVec = dose_yVec;
tps_data.dose.zVec = dose_zVec;
tps_data.ct.cube = ct_cube_new;
tps_data.ct.xVec = ct_xVec_new;
tps_data.ct.yVec = ct_yVec_new;
tps_data.ct.zVec = ct_zVec_new;

%% Calculate structures
if ischar(rtstruc_path)
    prefix = '';
    tps_data = calcStrucContours(dose_xVec, dose_yVec, dose_zVec, rtstruc_path, tps_data, prefix);
elseif iscell(rtstruc_path) && length(rtstruc_path) == 2
    prefix = 'a_';
    disp('First structure set');
    tps_data = calcStrucContours(dose_xVec, dose_yVec, dose_zVec, rtstruc_path{1}, tps_data, prefix);
    prefix = 'b_';
    disp('Second structure set');
    tps_data = calcStrucContours(dose_xVec, dose_yVec, dose_zVec, rtstruc_path{2}, tps_data, prefix);
end

%% Save dosecubes as 'tps_data.mat'
save([output_dir 'tps_data.mat'], 'tps_data');
disp('All structures calculated and saved to dosecubes.mat');
end


function [dc_ct, dc_xVec_ct, dc_yVec_ct, dc_zVec_ct] = loadCTCube(ct_dir)
input_files_list = dir(ct_dir); % get a list of input files
input_files_list = input_files_list(3:end); % discard first two files (which are '.' and '..')
for i = 1:length(input_files_list) % for every file of a given patient
    %% load dicominfo
    input_file_filename = input_files_list(i).name; % get name of  a file
    dicomInfo = dicominfo([ct_dir input_file_filename]);
    series = dicomInfo.SeriesInstanceUID;
    dc_ct(:,:,i) = dicomread(dicomInfo);
    dc_zVec_ct(i,1) = dicomInfo.ImagePositionPatient(3);
end
dc_xVec_ct = dicomInfo.ImagePositionPatient(2) + (0:double(dicomInfo.Rows-1))' * dicomInfo.PixelSpacing(2);
dc_yVec_ct = dicomInfo.ImagePositionPatient(1) + (0:double(dicomInfo.Columns-1))' * dicomInfo.PixelSpacing(1);

%rounding
% dc_xVec_ct_2 = round(ceil(1000*dc_xVec_ct)/1000,2);
% dc_yVec_ct_2 = round(ceil(1000*dc_yVec_ct)/1000,2);
% dc_zVec_ct_2 = round(ceil(1000*dc_zVec_ct)/1000,2);
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
        
        function [xVec, yVec, zVec] = getPatientsCoords(dicomInfo)
            yVec = dicomInfo.ImagePositionPatient(1) + ...
                (0:double(dicomInfo.Columns-1))' * dicomInfo.PixelSpacing(1);
            xVec = dicomInfo.ImagePositionPatient(2) + ...
                (0:double(dicomInfo.Rows-1))' * dicomInfo.PixelSpacing(2);
            % get offset
            if dicomInfo.GridFrameOffsetVector(1) ~= 0
                offset = dicomInfo.GridFrameOffsetVector - ...
                    dicomInfo.GridFrameOffsetVector(1);
            else
                offset = dicomInfo.GridFrameOffsetVector;
            end
            zVec = dicomInfo.ImagePositionPatient(3) + offset;
        end
        
    end

    function [dc, dc_xVec, dc_yVec, dc_zVec] = fixing(dc, dc_xVec, dc_yVec, dc_zVec, rtstruc_path)
        % fixing:
        %   1.  flips cube if zVec is ascending, so zVec is always
        %       descending
        %   2.  Interpolates dosecube by means of all possible structure z
        %       coordinates
        %   3.  If there are any NaN values in cube, change them to 0
        
        roundprec = 3;
        interp = 'linear';
        
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
        dc = interpn(X1o,X2o,X3o,dc,X1i,X2i,X3i,interp);
        %% Change NaNs to 0
        dc(isnan(dc)) = 0;
%         dc_xVec = round(ceil(1000*dc_xVeci)/1000,2);
%         dc_yVec = round(ceil(1000*dc_yVeci)/1000,2);
%         dc_zVec = round(ceil(1000*dc_zVeci)/1000,2);
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


function tps_data = calcStrucContours(dc_xVec,dc_yVec,dc_zVec, rtstruc_path, tps_data, prefix)
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
    while strcmp(struc_name(end),'_')
        struc_name(end) = '';
    end
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
    tps_data.structures.(struc_name).indicator_mask = indicator_mask;
    tps_data.structures.(struc_name).structure_vetrices = struc_vetrices;
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