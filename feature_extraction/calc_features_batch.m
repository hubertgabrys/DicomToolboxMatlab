function features_all = calc_features_batch( input_dir, organ, recalcFeatures, showGUI )
%calc_features_batch calculates features for all patients present in
% 'input_dir'. It also generates csv files containing features for parotid
% glands only.

if ischar(input_dir) % in case the user choose cancel
    fprintf('Calculating features for all VOIs...');
    dirnames = get_subdir_list( input_dir );
    
    if showGUI
        h = waitbar(0,'Please wait...');
        steps = length(dirnames);
    end
    for i=1:length(dirnames)
        progress_tool(i, length(dirnames));
        if showGUI
            waitbar(i / steps)
        end
        %fprintf('%s\n', dirnames{i});
        path = fullfile(input_dir, dirnames{i}, 'features.csv');
        if ~recalcFeatures && exist(path, 'file')
            %load csv file
            features_table = readtable(path);
            %fprintf('Features loaded from csv file!\n');
        else          
            load(fullfile(input_dir, dirnames{i},'tps_data'));
            features = calc_features(tps_data, organ, 0);
            features_table = cell2table(features(2:end, :));
            features_table.Properties.VariableNames = features(1, :);
            writetable(features_table, path);
        end
        
        ids = {};
        for j=1:size(features_table,1)
            ids{j,1} = dirnames{i};
        end
        ids_table = table(ids, 'VariableNames', {'ID'});
        if exist('features_all', 'var')
            try
                features_all = [features_all; [ids_table, features_table]];
            catch
                error('Problem stacking the features.');
            end
        else
            features_all = [ids_table, features_table];
        end
    end
    % all features
    path = fullfile(input_dir, 'features_all.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(features_all, path);
    
    % parotid features
    fprintf('\n');
    [feat_par_lr, feat_par_ic] = get_parotid_features(path);
    
    % parotid features left right
    path = fullfile(input_dir, 'features_parotids_lr.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(feat_par_lr, path);
    
    % parotid features ipsilateral contralateral
    path = fullfile(input_dir, 'features_parotids_ic.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(feat_par_ic, path);
    
    if showGUI
        close(h)
    end
end
fprintf(repmat('\b',1,7));
fprintf('DONE\n');
end

function [feat_par_oryg, feat_par_ic] = get_parotid_features(input_path)
%get_parotid_features extract features of parotids from the input csv file
% containing features of all structures. It outputs: 'feat_par_oryg' which
% contains parotid features in the same format as in the input csv file 
% (ie. each parotid in a separate row) and 'feat_par_ic' which contains
% features of both parotid glands in a single row. 'i_' and 'c_' prefixes
% are added to feature names to indicate ipsipalteral and contralateral
% parotid, respectively.

fprintf('Extracting all parotid features...');

features_all = readtable(input_path);
patlist = unique(features_all.ID);
for i=1:length(patlist)
    %fprintf('%s\n',patlist{i});
    progress_tool(i,length(patlist));
    features = features_all(strcmp(features_all.ID, patlist{i}),:);
    list_of_structures = features.strucname;
    
    % recognize left and right parotid
    [parotidL_name, parotidR_name] = findLRparotids(list_of_structures);
    parotidL = features(strcmp(features.strucname, parotidL_name),:);
    parotidR = features(strcmp(features.strucname, parotidR_name),:);
    
    if i == 1
        feat_par_oryg = [parotidL; parotidR];
    else
        feat_par_oryg = [feat_par_oryg; [parotidL; parotidR]];
    end
    
    % add '_r' and '_l' to variable names of right and left parotid
    parotidR.Properties.VariableNames(3:end) = ...
        cellfun(@(x) ['r_', x],parotidR.Properties.VariableNames(3:end),...
        'UniformOutput', false);
    parotidL.Properties.VariableNames(3:end) = ...
        cellfun(@(x) ['l_', x],parotidL.Properties.VariableNames(3:end),...
        'UniformOutput', false);
    
    parotidR.strucname = [];
    parotidL.strucname = [];
    
    % decide which one is ipsilateral
    if parotidR.r_mean > parotidL.l_mean
        ipsiparotid = 'right';
        parotidI = parotidR;
        parotidC = parotidL;
    else
        ipsiparotid = {'left'};
        parotidI = parotidL;
        parotidC = parotidR;
    end
    
    % add 'i_' and 'c_' to variable names of ipsi and contra parotids
    parotidI.Properties.VariableNames(2:end) = ...
        cellfun(@(x) ['i_', x(3:end)],parotidI.Properties.VariableNames(2:end),...
        'UniformOutput', false);
    parotidC.Properties.VariableNames(2:end) = ...
        cellfun(@(x) ['c_', x(3:end)],parotidC.Properties.VariableNames(2:end),...
        'UniformOutput', false);
    
    %output
    foo.ipsiparotid = ipsiparotid;
    if i == 1
        %feat_par_ic = [parotidL, parotidR(:,2:end), parotidI(:,2:end), parotidC(:,2:end)];
        feat_par_ic = [parotidI(:,1), struct2table(foo), parotidI(:,2:end),...
            parotidC(:,2:end)];
    else
        %feat_par_ic = [feat_par_ic; [parotidL, parotidR(:,2:end), parotidI(:,2:end), parotidC(:,2:end)]];
        feat_par_ic = [feat_par_ic; [parotidI(:,1), struct2table(foo),...
            parotidI(:,2:end), parotidC(:,2:end)]];
    end
end
feat_par_oryg.ID = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), feat_par_oryg.ID, 'UniformOutput', false);
feat_par_oryg.Properties.VariableNames{1} = 'MyPatientID';
feat_par_ic.ID = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), feat_par_ic.ID, 'UniformOutput', false);
feat_par_ic.Properties.VariableNames{1} = 'MyPatientID';

fprintf(repmat('\b',1,7)); % this is to erase the progress tool
fprintf('DONE\n');
end