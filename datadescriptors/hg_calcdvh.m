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
% output
% dx - minimal dose to the 'hottest' volume x
% vx - volume reveiving at least dose x
%
% h.gabrys@dkfz.de, 2014-15
%

%% Initialization
dose_domain = (0:0.1:100)';
output.args = dose_domain;

%% Calculations for original cube
% take only nonzero voxels
struct_dc2 = struct_cube(struct_cube ~= 0);
d_min = min(struct_dc2(:));
d_max = max(struct_dc2(:));
d_mean = mean(struct_dc2(:));
% dv_median(j) = median(struct_dc2(:));
noVox = nnz(struct_dc2);
volume_relative = zeros(length(dose_domain),1);
for k=1:length(dose_domain)
    volume_relative(k) = nnz(struct_dc2 >= dose_domain(k))*100/nnz(struct_dc2);
    if volume_relative(k) > 100
        disp('what!?');
        disp(volume_relative(k));
    end
end
% for vx=100:-1:1
%     tmp = abs(volume_relative-vx);
%     if(vx~=100)
%         [idx idx] = min(tmp);
%     else
%         foo = find(tmp);
%         idx = foo(1);
%     end
%     dx(1,vx) = dose_domain(idx);
% end
struct_dc2_vec = sort(struct_dc2(:));

for x=1:99
    idx = round(length(struct_dc2_vec)*(1-x/100));
    if ~idx
        idx=1;
    end
    dx(x,1) = struct_dc2_vec(idx);
end
for x=1:70
    vx(x,1) = nnz(struct_dc2_vec >= x)/nnz(struct_dc2_vec);
end
output.vals = volume_relative;
clear tmp;

%% prepare output
%t1 = array2table({strucname}, 'VariableNames', {'structure'});
t2 = array2table([noVox, d_min, d_max, d_mean], 'VariableNames', {'no_voxels', 'min', 'max', 'mean'});
for k=1:99
    d_labels{k} = ['d', num2str(k)];
end
t3 = array2table(dx', 'VariableNames', d_labels);
for k=1:70
    v_labels{k} = ['v', num2str(k)];
end
t4 = array2table(vx', 'VariableNames', v_labels);
output.array = [t2, t3, t4];
output.variablenames = [{'no_voxels', 'min', 'max', 'mean'}, d_labels, v_labels];
%disp('DVHs calculated');
end