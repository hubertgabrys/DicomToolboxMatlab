function [parotidL_name, parotidR_name] = findLRparotids(list_of_structures)
%findLRparotids finds structure names corresponding to left and right 
% parotid glands.

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