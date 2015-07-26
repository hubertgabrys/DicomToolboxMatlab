function tps_data = hg_dicomimport( dicompaths )

ct_paths = dicompaths.ct(:,1);
rtss_path = dicompaths.rtss{1};
rtdose_path = dicompaths.rtdose;
resolution = dicompaths.resolution;
save_matfile = dicompaths.save_matfile;
autosave = dicompaths.autosave;

ct_exists = ~isempty(dicompaths.ct);

%% interpolate CTs
if ct_exists
    [cube_ct, xVec_ct, yVec_ct, zVec_ct] = hg_loadCTCube(ct_paths);
    xVec_new = (xVec_ct(1):resolution:xVec_ct(end))';
    yVec_new = (yVec_ct(1):resolution:yVec_ct(end))';
    zVec_new = (zVec_ct(1):-resolution:zVec_ct(end))';
    [x, y, z] = ndgrid(xVec_ct,yVec_ct,zVec_ct);
    [xi, yi, zi] = ndgrid(xVec_new,yVec_new,zVec_new);
    cube_ct_new = interpn(x,y,z,double(cube_ct),xi,yi,zi);
    clear x y z xi yi zi;
    tps_data.ct.cube = cube_ct_new;
    tps_data.ct.xVec = xVec_new;
    tps_data.ct.yVec = yVec_new;
    tps_data.ct.zVec = zVec_new;
end

%% interpolate RTDOSE
if size(rtdose_path,1) == 1
    [cube_d, xVec_d, yVec_d, zVec_d] = hg_loadDoseCube(rtdose_path);
    if ~ct_exists
        xVec_new = (xVec_d(1):resolution:xVec_d(end))';
        yVec_new = (yVec_d(1):resolution:yVec_d(end))';
        zVec_new = (zVec_d(1):-resolution:zVec_d(end))';
    end
    [x, y, z] = ndgrid(xVec_d,yVec_d,zVec_d);
    [xi, yi, zi] = ndgrid(xVec_new,yVec_new,zVec_new);
    cube_d_new = interpn(x,y,z,cube_d,xi,yi,zi);
    clear x y z xi yi zi;
    tps_data.dose.cube = cube_d_new;
    tps_data.dose.xVec = xVec_new;
    tps_data.dose.yVec = yVec_new;
    tps_data.dose.zVec = zVec_new;
elseif size(rtdose_path,1) == 2 && ct_exists
    error('not implemented yet!');
elseif size(rtdose_path,1) == 2 && ~ct_exists
    [cube1_d, xVec1_d, yVec1_d, zVec1_d] = hg_loadDoseCube(rtdose_path{1});
    [cube2_d, xVec2_d, yVec2_d, zVec2_d] = hg_loadDoseCube(rtdose_path{2});
    % find the one with the larger spread in z direction
    if (length(zVec1_d) > length(zVec2_d)) && (length(xVec1_d) == length(xVec2_d)) && (length(yVec1_d) == length(yVec2_d))
        xVec_new = (xVec1_d(1):resolution:xVec1_d(end))';
        yVec_new = (yVec1_d(1):resolution:yVec1_d(end))';
        zVec_new = (zVec1_d(1):-resolution:zVec1_d(end))';
    elseif (length(xVec1_d) == length(xVec2_d)) && (length(yVec1_d) == length(yVec2_d))
        xVec_new = (xVec2_d(1):resolution:xVec2_d(end))';
        yVec_new = (yVec2_d(1):resolution:yVec2_d(end))';
        zVec_new = (zVec2_d(1):-resolution:zVec2_d(end))';
    end
    [x, y, z] = ndgrid(xVec1_d,yVec1_d,zVec1_d);
    [xi, yi, zi] = ndgrid(xVec_new,yVec_new,zVec_new);
    cube1_d_new = interpn(x,y,z,cube1_d,xi,yi,zi);
    cube1_d_new(isnan(cube1_d_new)) = 0;
    clear x y z;
    [x, y, z] = ndgrid(xVec2_d,yVec2_d,zVec2_d);
    cube2_d_new = interpn(x,y,z,cube2_d,xi,yi,zi);
    cube2_d_new(isnan(cube2_d_new)) = 0;
    clear x y z xi yi zi;
    tps_data.dose.cube = cube1_d_new+cube2_d_new;
    tps_data.dose.xVec = xVec_new;
    tps_data.dose.yVec = yVec_new;
    tps_data.dose.zVec = zVec_new;
end


%% calculate structures
tps_data.structures = hg_calcStructMasks(rtss_path, xVec_new, yVec_new, zVec_new);


%% Save cubes as 'tps_data.mat'
if save_matfile
    [pathstr,~,~] = fileparts(rtss_path);
    if autosave
        save(fullfile(pathstr, 'tps_data.mat'),'tps_data', '-v7.3');
    else
        [FileName,PathName] = uiputfile(fullfile(pathstr, 'tps_data.mat'),'Save as...');
        if ischar(FileName)
            save([PathName, FileName],'tps_data', '-v7.3');
        end
    end
    disp('All structures calculated and saved to tps_data.mat');
end
end