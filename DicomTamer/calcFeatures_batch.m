function features_all = calcFeatures_batch( input_dir, recalcFeatures, showGUI )

if ischar(input_dir) % in case the user choose cancel
    fprintf('Calculating features...');
    dirnames = getSubDirList( input_dir );
    
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
            features = readtable(path, 'Delimiter', ';');
            %fprintf('Features loaded from csv file!\n');
        else
            load(fullfile(input_dir, dirnames{i},'tps_data'));
            features = calculateFeatures(tps_data);
            writetable(features, path, 'Delimiter', ';');
        end
        
        ids = {};
        for j=1:size(features,1)
            ids{j,1} = dirnames{i};
        end
        ids_table = table(ids, 'VariableNames', {'ID'});
        if exist('features_all', 'var')
            features_all = [features_all; [ids_table, features]];
        else
            features_all = [ids_table, features];
        end
    end
    path = fullfile(input_dir, 'features_all.csv');
    if exist(path, 'file')
        delete(path);
    end
    writetable(features_all, path, 'Delimiter', ';');
    if showGUI
        close(h)
    end
end

fprintf('DONE\n');
end