function dvh = calc_dvh(struct_cube)
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

dose_domain = (0:0.1:100)';
% take only nonzero voxels
struct_dc2 = struct_cube(struct_cube ~= 0);
noVox = nnz(struct_dc2);
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
clear tmp;

%% prepare output
for k=1:99
    d_labels{k} = ['d', num2str(k)];
end
for k=1:70
    v_labels{k} = ['v', num2str(k)];
end

dvh.no_voxels = noVox;

for i=1:length(d_labels)
  dvh.(d_labels{i}) = dx(i);
end

for i=1:length(v_labels)
  dvh.(v_labels{i}) = vx(i);
end

%disp('DVHs calculated');
end