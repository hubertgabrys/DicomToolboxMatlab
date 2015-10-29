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
        
        if ~recalcFeatures && exist(fullfile(input_dir, dirnames{i}, 'features.xls'), 'file')
            %load xls file
            features = readtable(fullfile(input_dir, dirnames{i}, 'features.xls'));
            %fprintf('Features loaded from xls file!\n');
        else
            load(fullfile(input_dir, dirnames{i},'tps_data'));
            features = calculateFeatures(tps_data);
            writetable(features, fullfile(input_dir, dirnames{i}, 'features.xls'));
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
    if exist(fullfile(input_dir, 'features_all.xls'), 'file')
        delete(fullfile(input_dir, 'features_all.xls'));
    end
    writetable(features_all, fullfile(input_dir, 'features_all.xls'))
    if showGUI
        close(h)
    end
end

fprintf('DONE\n');
end

