function output = hg_calcdvh(dosecubes, strucnames)
% This function expects as input two structures.
% dosecubes - dosecube structure obtainable from hg_calcdicomdosecubes function
% input - call array containing two strings which are name of two structures for which dvh is to be calculated
% output - a table containing misc parameters (mean, max, min, median dose etc.)
%
% TODO:
% - make the function recognize how many structures were set as an input and process
% them correctly.
%
% x1gv is a sagittal axis. It goes from anterior to posterior.
% x2gv is a transverse axis. It goes form the right to the left; in case of
% parotis it is always from medial to lateral
% x3gv is a longitudinal axis. It goes from superior to inferior
%
% SA - sagittal axis
% TA - transverse axis
% VA - vertical axis
%
% dosecube is SA x TA x VA
% http://www.pt.ntu.edu.tw/hmchai/PTglossary/kines.files/CardinalPlane.gif
%
% h.gabrys@dkfz.de, 2014-15
%

%% Parameters
crop_shift = 'zero';
interp_method = 'nearest';
interp_interval = 2.5;
interpolation = false;

%% Initialization
dv_total = zeros(length(strucnames), 1);
dv_min = zeros(length(strucnames), 1);
dv_max = zeros(length(strucnames), 1);
dv_mean = zeros(length(strucnames), 1);
dv_median = zeros(length(strucnames), 1);
dv_noVox = zeros(length(strucnames), 1);
dvh_domain = 0:0.1:70;
output.args = dvh_domain;

for j=1:2 % for each dosecube
    %% Load dosecube
    dc = dosecubes.dosecube.dosecube;
    indmsk = dosecubes.(strucnames{j}).indicator_mask;
    % in case that there are voxels with 0 dose inside volume, change 0
    % to 0.00001 (or any small value)
    dc(dc == 0 & indmsk == 1) = 0.00001;
    struct_dc = dc .* indmsk;
    struct_x1gv = dosecubes.dosecube.dosecube_xVector;
    struct_x2gv = dosecubes.dosecube.dosecube_yVector;
    struct_x3gv = dosecubes.dosecube.dosecube_zVector;
    
    %% Crop dosecube
    [struct_dc, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(...
        struct_dc, struct_x1gv, struct_x2gv, struct_x3gv, crop_shift);
    
    %% Interpolate dosecube
    if interpolation
    [X1,X2,X3] = ndgrid(struct_x1gv, struct_x2gv, struct_x3gv);
    struct_x1gvi = struct_x1gv(1):interp_interval:struct_x1gv(end);
    struct_x2gvi = struct_x2gv(1):interp_interval:struct_x2gv(end);
    struct_x3gvi = struct_x3gv(1):interp_interval:struct_x3gv(end);
    [X1i,X2i,X3i] = ndgrid(struct_x1gvi, struct_x2gvi, struct_x3gvi);
    struct_dc = interpn(X1,X2,X3,struct_dc,X1i,X2i,X3i,interp_method);
    disp('dosecube interpolated');
    end
    
    %% Calculations for original cube
    % take only nonzero voxels
    struct_dc2 = struct_dc(struct_dc ~= 0);
    dv_total(j) = sum(struct_dc2(:));
    dv_min(j) = min(struct_dc2(:));
    dv_max(j) = max(struct_dc2(:));
    dv_mean(j) = mean(struct_dc2(:));
    dv_median(j) = median(struct_dc2(:));
    dv_noVox(j) = nnz(struct_dc2);
    dvh_vals = zeros(length(dvh_domain),1);
    for k=1:length(dvh_domain)
        dvh_vals(k) = nnz(struct_dc2 >= dvh_domain(k))*100/nnz(struct_dc2);
        if dvh_vals(k) > 100
            disp('what!?');
            disp(dvh_vals(k));
        end
    end
    output.vals.(strucnames{j}) = dvh_vals;
    
end
dv_meanBoth(1,1) = sum(dv_total)/sum(dv_noVox);
dv_meanBoth(2,1) = sum(dv_total)/sum(dv_noVox);

%% prepare output
if length(strucnames) == 2
    array = [{'left';'right'} mat2cell(dv_min, [1 1]) mat2cell(dv_max, [1 1]) ...
        mat2cell(dv_mean, [1 1]) mat2cell(dv_median, [1 1]) ...
        mat2cell(dv_meanBoth, [1 1])];
    variableNames = {'side' 'min', 'max', 'mean', 'median', 'mean_both'};
    output.array = cell2table(array, 'VariableNames', variableNames);
end
disp('DVHs calculated');
end