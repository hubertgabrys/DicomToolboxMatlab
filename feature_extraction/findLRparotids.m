function [parotidL_name, parotidR_name] = findLRparotids(list_of_structures)
%findLRparotids finds structure names corresponding to left and right 
% parotid glands.

parotidL_il_ind = ~cellfun(@isempty, regexpi(list_of_structures, 'il_lparotid'));
parotidL_cl_ind = ~cellfun(@isempty, regexpi(list_of_structures, 'cl_lparotid'));
parotidL_ind = parotidL_il_ind + parotidL_cl_ind;
parotidR_il_ind = ~cellfun(@isempty, regexpi(list_of_structures, 'il_rparotid'));
parotidR_cl_ind = ~cellfun(@isempty, regexpi(list_of_structures, 'cl_rparotid'));
parotidR_ind = parotidR_il_ind + parotidR_cl_ind;
parotids = list_of_structures((parotidL_ind + parotidR_ind) == 1);

if length(parotids) == 2
    parotidL_name = list_of_structures{parotidL_ind == 1};
    parotidR_name = list_of_structures{parotidR_ind == 1};
else
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
end