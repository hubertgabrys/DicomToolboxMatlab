function [features_parotids, features_parotids2] = get_parotid_features(input_path)
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
        features_parotids = [parotidL; parotidR];
    else
        features_parotids = [features_parotids; [parotidL; parotidR]];
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
    if parotidR.r_mean > parotidL.l_mean;
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
        %features_parotids2 = [parotidL, parotidR(:,2:end), parotidI(:,2:end), parotidC(:,2:end)];
        features_parotids2 = [parotidI(:,1), struct2table(foo), parotidI(:,2:end),...
            parotidC(:,2:end)];
    else
        %features_parotids2 = [features_parotids2; [parotidL, parotidR(:,2:end), parotidI(:,2:end), parotidC(:,2:end)]];
        features_parotids2 = [features_parotids2; [parotidI(:,1), struct2table(foo),...
            parotidI(:,2:end), parotidC(:,2:end)]];
    end
end
features_parotids.ID = str2double(cellfun(@(x) x(3:5), features_parotids.ID,...
    'UniformOutput', false));
features_parotids.Properties.VariableNames{1} = 'MyPatientID';
features_parotids2.ID = str2double(cellfun(@(x) x(3:5), features_parotids2.ID,...
    'UniformOutput', false));
features_parotids2.Properties.VariableNames{1} = 'MyPatientID';

fprintf(repmat('\b',1,7)); % this is to erase progress tool
fprintf('DONE\n');
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