function tps_data = hg_dicomimport( varargin )

save_matfile = true;

if length(varargin) == 3
    ct_paths = varargin{1};
    rtss_path = varargin{2};
    resolution = varargin{3};
elseif length(varargin) == 4
    ct_paths = varargin{1};
    rtss_path = varargin{2};
    rtdose_path = varargin{3};
    resolution = varargin{4};
end

%% load CTs
[cube_ct, xVec_ct, yVec_ct, zVec_ct] = hg_loadCTCube(ct_paths);

%% interpolate CTs
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

%% calculate structures
tps_data.structures = hg_calcStructMasks(rtss_path, xVec_new, yVec_new, zVec_new);

%% load RTDOSE
[cube_d, xVec_d, yVec_d, zVec_d] = hg_loadDoseCube(rtdose_path);

%% interpolate RTDOSE
[x, y, z] = ndgrid(xVec_d,yVec_d,zVec_d);
[xi, yi, zi] = ndgrid(xVec_new,yVec_new,zVec_new);
cube_d_new = interpn(x,y,z,cube_d,xi,yi,zi);
clear x y z xi yi zi;
tps_data.dose.cube = cube_d_new;
tps_data.dose.xVec = xVec_new;
tps_data.dose.yVec = yVec_new;
tps_data.dose.zVec = zVec_new;

%% Save cubes as 'tps_data.mat'
if save_matfile
    [pathstr,~,~] = fileparts(rtss_path);
    [FileName,PathName] = uiputfile(fullfile(pathstr, 'tps_data.mat'),'Save as...');
    if ischar(FileName)
        save([PathName, FileName],'tps_data', '-v7.3');
    end
    disp('All structures calculated and saved to tps_data.mat');
end
end