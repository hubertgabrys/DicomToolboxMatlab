function features_all = calc_features_batch( input_dir, organ, recalcFeatures, showGUI )

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
            features_all = [features_all; [ids_table, features_table]];
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
    
    % parotid features 1
    fprintf('\n');
    [features_parotids_all, features_parotids_all2] = get_parotid_features(path);
    path = fullfile(input_dir, 'features_parotids_all.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(features_parotids_all, path);
    
    % parotid features 2
    path = fullfile(input_dir, 'features_parotids_all2.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(features_parotids_all2, path);
    
    if showGUI
        close(h)
    end
end
fprintf(repmat('\b',1,7));
fprintf('DONE\n');
end