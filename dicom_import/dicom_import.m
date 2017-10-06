function tps_data = dicom_import( varargin )
% the cube is in LPS coordinate system 

%
if length(varargin) == 1
    %old version
    dicompaths = varargin{1};
    ct_paths = dicompaths.ct(:,1);
    rtss_path = dicompaths.rtss{1};
    rtdose_path = dicompaths.rtdose;
    resolution = dicompaths.resolution;
    save_matfile = dicompaths.save_matfile;
    default_save_path = dicompaths.default_save_path;
elseif length(varargin) == 5
    % new version
    input_path = varargin{1};
    resolution = varargin{2};
    save_matfile = varargin{3};
    default_save_path = varargin{4};
    showGUI = varargin{5};
    [fileList,patientList ] = scan_import_dir(input_path);
    dicompaths.ct = fileList(strcmp(fileList(:,2),'CT'),1);
    dicompaths.rtss = fileList(strcmp(fileList(:,2),'RTSTRUCT'),1);
    dicompaths.rtdose = fileList(strcmp(fileList(:,2),'RTDOSE'),1);
    if length(patientList)~=1 || length(dicompaths.rtss)~=1 || length(dicompaths.rtdose)>2
        if showGUI
            msgbox(['Check DICOMs: ', input_path], 'Error','error');
            error(['Check DICOMs: ', input_path]);
        end
    end
    ct_paths = dicompaths.ct(:,1);
    rtss_path = dicompaths.rtss{1};
    rtdose_path = dicompaths.rtdose;
end


ct_exists = ~isempty(dicompaths.ct);
%ct_exists = false;

%% interpolate CTs
if ct_exists
    [cube_ct, xVec_ct, yVec_ct, zVec_ct] = load_ct_cube(ct_paths);
    xVec_new = (xVec_ct(1):resolution:xVec_ct(end))';
    yVec_new = (yVec_ct(1):resolution:yVec_ct(end))';
    zVec_new = (zVec_ct(1):resolution:zVec_ct(end))';
    [x, y, z] = meshgrid(xVec_ct,yVec_ct,zVec_ct);
    [xi, yi, zi] = meshgrid(xVec_new,yVec_new,zVec_new);
    cube_ct_new = interp3(x,y,z,double(cube_ct),xi,yi,zi);
    clear x y z xi yi zi;
    tps_data.ct.cube = cube_ct_new;
    tps_data.ct.xVec = xVec_new;
    tps_data.ct.yVec = yVec_new;
    tps_data.ct.zVec = zVec_new;
end

%% interpolate RTDOSE
if size(rtdose_path,1) == 1
    [cube_d, xVec_d, yVec_d, zVec_d] = load_dose_cube(rtdose_path{1});
    if ~ct_exists
        xVec_new = (xVec_d(1):resolution:xVec_d(end))';
        yVec_new = (yVec_d(1):resolution:yVec_d(end))';
        zVec_new = (zVec_d(1):resolution:zVec_d(end))';
    end
    [x, y, z] = meshgrid(xVec_d,yVec_d,zVec_d);
    [xi, yi, zi] = meshgrid(xVec_new,yVec_new,zVec_new);
    cube_d_new = interp3(x,y,z,cube_d,xi,yi,zi);
    cube_d_new(isnan(cube_d_new)) = 0;
    clear x y z xi yi zi;
    tps_data.dose.cube = cube_d_new;
    tps_data.dose.xVec = xVec_new;
    tps_data.dose.yVec = yVec_new;
    tps_data.dose.zVec = zVec_new;
elseif size(rtdose_path,1) == 2 && ct_exists
    error('not supported!');
elseif size(rtdose_path,1) == 2 && ~ct_exists
    [cube1_d, xVec1_d, yVec1_d, zVec1_d] = load_dose_cube(rtdose_path{1});
    [cube2_d, xVec2_d, yVec2_d, zVec2_d] = load_dose_cube(rtdose_path{2});
    % find the one with the larger spread in z direction
    if (length(zVec1_d) > length(zVec2_d)) && (length(xVec1_d) == length(xVec2_d)) && (length(yVec1_d) == length(yVec2_d))
        xVec_new = (xVec1_d(1):resolution:xVec1_d(end))';
        yVec_new = (yVec1_d(1):resolution:yVec1_d(end))';
        zVec_new = (zVec1_d(1):resolution:zVec1_d(end))';
    elseif (length(xVec1_d) == length(xVec2_d)) && (length(yVec1_d) == length(yVec2_d))
        xVec_new = (xVec2_d(1):resolution:xVec2_d(end))';
        yVec_new = (yVec2_d(1):resolution:yVec2_d(end))';
        zVec_new = (zVec2_d(1):resolution:zVec2_d(end))';
    end
    [x, y, z] = meshgrid(xVec1_d,yVec1_d,zVec1_d);
    [xi, yi, zi] = meshgrid(xVec_new,yVec_new,zVec_new);
    cube1_d_new = interp3(x,y,z,cube1_d,xi,yi,zi);
    cube1_d_new(isnan(cube1_d_new)) = 0;
    clear x y z;
    [x, y, z] = meshgrid(xVec2_d,yVec2_d,zVec2_d);
    cube2_d_new = interp3(x,y,z,cube2_d,xi,yi,zi);
    cube2_d_new(isnan(cube2_d_new)) = 0;
    clear x y z xi yi zi;
    tps_data.dose.cube = cube1_d_new+cube2_d_new;
    tps_data.dose.xVec = xVec_new;
    tps_data.dose.yVec = yVec_new;
    tps_data.dose.zVec = zVec_new;
elseif size(rtdose_path,1) > 2
    dimensions = ndims(load_dose_cube(rtdose_path{1}));
    if dimensions == 2
        for i=1:length(rtdose_path)
            [cube_d(:,:,i), xVec_d, yVec_d, zVec_d(i,1)] = load_dose_cube(rtdose_path{i});
        end
    elseif dimensions == 3
        error('More than 2 RTDOSE dicoms not supported!');
    end
    if zVec_d(2) - zVec_d(1) < 0 % Flip cube if zVec is descending
        zVec_d(:,1) = flip(zVec_d);
        cube_d = flip(cube_d, 3);
    end
    if ~ct_exists
        xVec_new = (xVec_d(1):resolution:xVec_d(end))';
        yVec_new = (yVec_d(1):resolution:yVec_d(end))';
        zVec_new = (zVec_d(1):resolution:zVec_d(end))';
    end
    [x, y, z] = meshgrid(xVec_d,yVec_d,zVec_d);
    [xi, yi, zi] = meshgrid(xVec_new,yVec_new,zVec_new);
    cube_d_new = interp3(x,y,z,cube_d,xi,yi,zi);
    cube_d_new(isnan(cube_d_new)) = 0;
    clear x y z xi yi zi;
    tps_data.dose.cube = cube_d_new;
    tps_data.dose.xVec = xVec_new;
    tps_data.dose.yVec = yVec_new;
    tps_data.dose.zVec = zVec_new;
end


%% calculate structures
tps_data.structures = calc_struct_masks(rtss_path, xVec_new, yVec_new, zVec_new);


%% Save cubes as 'tps_data.mat'
if save_matfile
    [pathstr,~,~] = fileparts(rtss_path);
    if default_save_path
        save(fullfile(pathstr, 'tps_data.mat'),'tps_data', '-v7.3');
    else
        [FileName,PathName] = uiputfile(fullfile(pathstr, 'tps_data.mat'),'Save as...');
        if ischar(FileName)
            save([PathName, FileName],'tps_data', '-v7.3');
        end
    end
end
end