function tps_data = hg_dicomimport( dicompaths )

ct_paths = dicompaths.ct(:,1);
rtss_path = dicompaths.rtss{1};
rtdose_path = dicompaths.rtdose{1};
resolution = dicompaths.resolution;
save_matfile = dicompaths.save_matfile;
autosave = dicompaths.autosave;

ct_exists = ~isempty(dicompaths.ct);
rtdose_exists = length(dicompaths.rtdose) == 1;

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
if rtdose_exists
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