function output = hg_calcdvh(struct_cube)
% tps_data - structure obtainable from hg_dicomimport function
% strucname - string representing name of the structure for which dvh is to be calculated
% output - a table containing misc parameters (mean, max, min, median dose etc.)
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

%% Initialization
dvh_domain = 0:0.1:100;
output.args = dvh_domain;

%% Calculations for original cube
% take only nonzero voxels
struct_dc2 = struct_cube(struct_cube ~= 0);
dv_min = min(struct_dc2(:));
dv_max = max(struct_dc2(:));
dv_mean = mean(struct_dc2(:));
% dv_median(j) = median(struct_dc2(:));
dv_noVox = nnz(struct_dc2);
dvh_vals = zeros(length(dvh_domain),1);
for k=1:length(dvh_domain)
    dvh_vals(k) = nnz(struct_dc2 >= dvh_domain(k))*100/nnz(struct_dc2);
    if dvh_vals(k) > 100
        disp('what!?');
        disp(dvh_vals(k));
    end
end
for k=100:-1:1
    tmp = abs(dvh_vals-k);
    if(k~=100)
        [idx idx] = min(tmp);
    else
        foo = find(tmp);
        idx = foo(1);
    end
    dvh(1,k) = dvh_domain(idx);
end
output.vals = dvh_vals;
clear tmp;

%% prepare output
for k=1:100
    dvh_labels{k} = ['dvh', num2str(k)];
end
%t1 = array2table({strucname}, 'VariableNames', {'structure'});
t2 = array2table([dv_noVox, dv_min, dv_max, dv_mean], 'VariableNames', {'no_voxels', 'min', 'max', 'mean'});
t3 = array2table(dvh, 'VariableNames', dvh_labels);
output.array = [t2, t3];
output.variablenames = [{'no_voxels', 'min', 'max', 'mean'}, dvh_labels];
%disp('DVHs calculated');
end