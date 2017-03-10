function output = calc_features( tps_data, verbose )
%calculateFeatures calls various functions to calculate dosimetric and ct
%descriptors of the rt structures.
%   tps_data - ct, dosimetric, and structure data from the tps
%   strucnames - names of rt structures

if nargin < 2
	verbose = 1;
end

organ = 'parotid';

dose_cube = tps_data.dose.cube;
xspac = tps_data.dose.xVec(2)-tps_data.dose.xVec(1);
yspac = tps_data.dose.yVec(2)-tps_data.dose.yVec(1);
zspac = tps_data.dose.zVec(2)-tps_data.dose.zVec(1);
strucnames = fieldnames(tps_data.structures);

if strcmp(organ, 'parotid')
    [parotidL_name, parotidR_name] = findLRparotids(strucnames);
    strucnames = {parotidL_name, parotidR_name}';
end

for i=1:length(strucnames)
    strucname = strucnames{i};
	if verbose
        progress_tool(i, length(strucnames));
    end
    
    % load structure dosecube
    struct_cube = load_cube(tps_data, strucname, 'dose' );
    struct_cube_msk = struct_cube>0;
    struct_indicator_msk = tps_data.structures.(strucname).indicator_mask;
    
    if strcmp(organ, 'parotid')
        parotidL_cube = load_cube(tps_data, parotidL_name, 'dose' );
        parotidR_cube = load_cube(tps_data, parotidR_name, 'dose' );
        if mean(parotidR_cube(parotidR_cube>0)) > mean(parotidL_cube(parotidL_cube>0))
            % flip cube if ipsigland on the right
            struct_cube = flip(struct_cube, 2);
            struct_cube_msk = flip(struct_cube_msk, 2);
            struct_indicator_msk = flip(struct_indicator_msk, 2);
            dose_cube = flip(dose_cube, 2);
        end
    end
    
    % dose-volume features
    dvh = calc_dvh(struct_cube);
    
    % subvolume features
    resolution = 2;
    subvol2 = calc_subvolumes(struct_cube, resolution);
    resolution = 3;
    subvol3 = calc_subvolumes(struct_cube, resolution);
    
    % 3D moments
    mom_def = [1 1 0; 1 0 1; 0 1 1; 2 0 0; 0 2 0; 0 0 2;...
        1 1 1; 2 1 0; 2 0 1; 1 2 0; 0 2 1; 0 1 2; 1 0 2;...
        3 0 0; 0 3 0; 0 0 3; 4 0 0; 0 4 0; 0 0 4; 3 1 0;...
        3 0 1; 1 3 0; 0 3 1; 1 0 3; 0 1 3; 2 2 2];
    moments = calc_moments(struct_cube, mom_def);
    
    % 3D gradients
    gradients = calc_gradients(dose_cube, xspac, yspac, zspac, struct_indicator_msk);
    
    % Shape features
    shape_features = calc_shape_features(struct_cube_msk, xspac, yspac, zspac);
    
    % Histogram features
    histogram_features = calc_hist_features(dose_cube, struct_indicator_msk);
    
    % merge the results
    feature_names = ['strucname'; fieldnames(histogram_features);...
        fieldnames(dvh); fieldnames(subvol2); fieldnames(subvol3);...
        fieldnames(gradients); fieldnames(moments);...
        fieldnames(shape_features)]';
    this_final_features = [strucname; struct2cell(histogram_features);...
        struct2cell(dvh); struct2cell(subvol2); struct2cell(subvol3);...
        struct2cell(gradients); struct2cell(moments);...
        struct2cell(shape_features)]';
 
    if ~exist('final_features', 'var')
        final_features = [feature_names; this_final_features];
    else
        final_features = [final_features; this_final_features];
    end
end
if verbose
	fprintf(repmat('\b',1,7)); % erase progress_tool output
end

%% output
output = final_features;

end


function [parotidL_name, parotidR_name] = findLRparotids(list_of_structures)
parotid_indices1 = ~cellfun(@isempty, regexpi(list_of_structures, 'paroti'));
parotid_indices2 = ~cellfun(@isempty, regexpi(list_of_structures, 'PARPTOS_RE'));
parotid_indices = (parotid_indices1+parotid_indices2)>=1;

parotids = list_of_structures(parotid_indices);

if length(parotids) > 2 % get rid of parotis hilfe, partois boost, etc.
    proper_parotids_ind = true(length(parotids),1);
    for i=1:length(parotids)
        if ~isempty(regexpi(parotids{i}, '[B,H]'))
            % remove this index
            proper_parotids_ind(i) = 0;
        end
    end
    parotids = parotids(proper_parotids_ind,:);
end
if length(parotids) == 2 % flip cellarray in a way that parotidL is always first
    if ~isempty(regexpi(parotids{1}, '_L')) && ~isempty(regexpi(parotids{2}, '_R'))
    elseif ~isempty(regexpi(parotids{1}, '_R')) && ~isempty(regexpi(parotids{2}, '_L'))
        parotids = flip(parotids);
    elseif ~isempty(regexpi(parotids{1}, 'L'))
    elseif ~isempty(regexpi(parotids{2}, 'L'))
        parotids = flip(parotids);
    else
        error('Problem with recoqnizing left and right parotid!');
    end
else
    error('Problem with recognizing parotid structures!');
end
parotidL_name = parotids{1};
parotidR_name = parotids{2};
end


function progress_tool(currentIndex, totalNumberOfEvaluations)
if (currentIndex > 1 && nargin < 3)
  Length = numel(sprintf('%3.2f%%',(currentIndex-1)/totalNumberOfEvaluations*100));
  fprintf(repmat('\b',1,Length));
end
fprintf('%3.2f%%',currentIndex/totalNumberOfEvaluations*100);
end